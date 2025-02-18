import 'dart:convert';
import 'package:newscan/data/constant.dart';
import 'package:newscan/model/chapter.dart';
import 'package:http/http.dart' as http;

class ChaptersService {
  Future<List<Chapter>> fetchChapters(String mangaId) async {
    final response = await http.get(
      Uri.parse("$kChaptersByMangaIdUrl=$mangaId&limit=100"),
    );

    if (response.statusCode == 200) {
      final decodedJson = jsonDecode(response.body);
      final chaptersList = decodedJson['data'] as List;

      // Filtrer et regrouper par chapitre
      final Map<String, Chapter> uniqueChapters = {};

      for (var chapter in chaptersList) {
        final attributes = chapter['attributes'];
        final lang = attributes['translatedLanguage'];
        final chapNum = attributes['chapter'] ?? "?";

        // Vérifier la langue et la validité du numéro de chapitre
        if (lang == 'en' && chapNum != "?") {
          final current = uniqueChapters[chapNum];
          final newChapter = Chapter(
            id: chapter['id'],
            title:
                (attributes['title']?.isNotEmpty ?? false)
                    ? attributes['title']
                    : "Untitled",
            volume: attributes['volume'] ?? "?",
            chapter: chapNum,
            translatedLanguage: lang,
          );

          // Remplacer uniquement si le nouveau a un titre et l'ancien non
          if (current == null ||
              (current.title == "Untitled" && newChapter.title != "Untitled")) {
            uniqueChapters[chapNum] = newChapter;
          }
        }
      }

      // Convertir la map en liste et trier par numéro de chapitre
      final chapters =
          uniqueChapters.values.toList()..sort(
            (a, b) => (double.tryParse(a.chapter) ?? 0).compareTo(
              double.tryParse(b.chapter) ?? 0,
            ),
          );

      if (chapters.isEmpty) {
        throw Exception("No chapters found.");
      }

      return chapters;
    } else {
      throw Exception("Error fetching chapter details: ${response.statusCode}");
    }
  }

  Future<List<String>> fetchPagesWithChapterId(String chapterId) async {
    try {
      // Effectuer la requête HTTP
      final response = await http.get(
        Uri.parse("https://api.mangadex.org/at-home/server/$chapterId"),
      );

      if (response.statusCode == 200) {
        // Décoder le JSON de la réponse
        final decodedJson = jsonDecode(response.body);
        final baseUrl = decodedJson['baseUrl'];
        final chapterData = decodedJson['chapter'];

        // Vérifier que 'data' est une liste
        if (chapterData != null && chapterData['data'] is List) {
          final List<String> dataChapter = List<String>.from(
            chapterData['data'] ?? [],
          );

          // Préfixer chaque nom d'image avec la baseUrl
          final List<String> fullImageUrls =
              dataChapter.map((imageFileName) {
                return '$baseUrl/data/${chapterData['hash']}/$imageFileName';
              }).toList();

          return fullImageUrls;
        } else {
          throw Exception(
            "Format de données invalide pour les pages du chapitre.",
          );
        }
      } else {
        throw Exception(
          "Erreur lors de la récupération des pages du chapitre : Code de statut ${response.statusCode}",
        );
      }
    } catch (e) {
      throw Exception(
        "Erreur lors de la récupération des pages du chapitre : $e",
      );
    }
  }


}
