import 'dart:convert';

import 'package:newscan/data/constant.dart';
import 'package:newscan/model/manga.dart';
import 'package:http/http.dart' as http;

class SearchService {
  Future<Manga> searchMangaByTitle(String enteredTitle) async {
    final encodedTitle = Uri.encodeComponent(enteredTitle);
    final response = await http.get(
      Uri.parse(kSearchMangaByTitleUrl + encodedTitle),
    );

    if (response.statusCode == 200) {
      try {
        final decodedJson = jsonDecode(response.body);
        final mandaData = decodedJson['data'];

        if (mandaData == null || mandaData.isEmpty) {
          throw Exception('No manga found for this title');
        }

        String id = mandaData[0]['id'];
        String title = mandaData[0]['attributes']['title']['en'];
        String imageUrl = await _fetchMangaCover(id);

        Manga manga = Manga(id: id, title: title, imageUrl: imageUrl);
        return manga;
      } catch (e) {
        throw Exception('Error while parsing manga data: $e');
      }
    } else {
      throw Exception(
        'Failed to load manga data. Status code: ${response.statusCode}',
      );
    }
  }

  Future<String> _fetchMangaCover(String mangaId) async {
    final response = await http.get(
      Uri.parse('https://api.mangadex.org/cover?manga[]=$mangaId'),
    );

    if (response.statusCode == 200) {
      try {
        final decodedJson = jsonDecode(response.body);
        final mangaData = decodedJson['data'] as List;

        if (mangaData.isEmpty) {
          throw Exception("No cover data found for manga ID: $mangaId");
        }

        final fileName = mangaData.first['attributes']['fileName'];
        return 'https://uploads.mangadex.org/covers/$mangaId/$fileName.256.jpg';
      } catch (e) {
        throw Exception("Error while fetching manga cover: $e");
      }
    } else {
      throw Exception(
        "Unable to fetch manga cover for ID: $mangaId (Status code: ${response.statusCode})",
      );
    }
  }
}
