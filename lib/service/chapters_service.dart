import 'dart:convert';
import 'package:newscan/data/constant.dart';
import 'package:newscan/model/chapter.dart';
import 'package:http/http.dart' as http;

class ChaptersService {
  Future<List<Chapter>> fetchChapters(String mangaId) async {
    List<Chapter> allChapters = [];
    int limit = 100;
    int offset = 0;
    int total = 0;

    do {
      final response = await http.get(
        Uri.parse("$kChaptersByMangaIdUrl=$mangaId&limit=$limit&offset=$offset"),
      );

      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(response.body);
        final chaptersList = decodedJson['data'] as List;
        total = decodedJson['total'];

        // Filter and group by chapter
        final Map<String, Chapter> uniqueChapters = {};

        for (var chapter in chaptersList) {
          final attributes = chapter['attributes'];
          final lang = attributes['translatedLanguage'];
          final chapNum = attributes['chapter'] ?? "?";

          // Check language and validity of the chapter number
          if (lang == 'en' && chapNum != "?") {
            final current = uniqueChapters[chapNum];
            final newChapter = Chapter(
              id: chapter['id'],
              title: (attributes['title']?.isNotEmpty ?? false)
                  ? attributes['title']
                  : "Untitled",
              volume: attributes['volume'] ?? "?",
              chapter: chapNum,
              translatedLanguage: lang,
            );

            // Replace only if the new one has a title and the old one does not
            if (current == null ||
                (current.title == "Untitled" && newChapter.title != "Untitled")) {
              uniqueChapters[chapNum] = newChapter;
            }
          }
        }

        // Add the chapters from this page to the global list
        allChapters.addAll(uniqueChapters.values);

        // Increase offset to fetch the next page
        offset += limit;
      } else {
        throw Exception("Error fetching chapter details: ${response.statusCode}");
      }
    } while (offset < total); // Continue until everything is retrieved

    // Sort chapters by number
    allChapters.sort((a, b) => (double.tryParse(a.chapter) ?? 0)
        .compareTo(double.tryParse(b.chapter) ?? 0));

    if (allChapters.isEmpty) {
      throw Exception("No chapters found.");
    }

    return allChapters;
  }

  Future<List<String>> fetchPagesWithChapterId(String chapterId) async {
    try {
      // Perform HTTP request
      final response = await http.get(
        Uri.parse("https://api.mangadex.org/at-home/server/$chapterId"),
      );

      if (response.statusCode == 200) {
        // Decode the JSON response
        final decodedJson = jsonDecode(response.body);
        final baseUrl = decodedJson['baseUrl'];
        final chapterData = decodedJson['chapter'];

        // Check that 'data' is a list
        if (chapterData != null && chapterData['data'] is List) {
          final List<String> dataChapter = List<String>.from(
            chapterData['data'] ?? [],
          );

          // Prefix each image name with the baseUrl
          final List<String> fullImageUrls =
          dataChapter.map((imageFileName) {
            return '$baseUrl/data/${chapterData['hash']}/$imageFileName';
          }).toList();

          return fullImageUrls;
        } else {
          throw Exception(
            "Invalid data format for chapter pages.",
          );
        }
      } else {
        throw Exception(
          "Error fetching chapter pages: Status code ${response.statusCode}",
        );
      }
    } catch (e) {
      throw Exception(
        "Error fetching chapter pages: $e",
      );
    }
  }
}
