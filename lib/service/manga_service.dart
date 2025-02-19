import 'dart:convert';
import 'package:newscan/data/constant.dart';
import 'package:newscan/model/manga.dart';
import 'package:http/http.dart' as http;

class MangaService {
  MangaService();

  Future<String> _fetchMangaCover(String mangaId) async {
    final response = await http.get(
      Uri.parse('https://api.mangadex.org/cover?manga[]=$mangaId'),
    );

    if (response.statusCode == 200) {
      try {
        final decodedJson = jsonDecode(response.body);
        final mangaData = decodedJson['data'] as List;

        if (mangaData.isEmpty) {
          throw Exception("No data found for ID: $mangaId");
        }

        final fileName = mangaData.first['attributes']['fileName'];

        return 'https://uploads.mangadex.org/covers/$mangaId/$fileName.256.jpg';
      } catch (e) {
        throw Exception("Error processing data: $e");
      }
    } else {
      throw Exception(
        "Failed to load manga image with ID: $mangaId (code: ${response.statusCode})",
      );
    }
  }

  Future<Manga> fetchMangaDetails(String mangaId) async {
    final response = await http.get(Uri.parse("$kMangaByIdUrl/$mangaId"));

    if (response.statusCode == 200) {
      final decodedJson = jsonDecode(response.body);
      final mangaData = decodedJson['data'];

      final titleMap = mangaData['attributes']['title'];
      final title =
      titleMap is Map && titleMap.isNotEmpty
          ? titleMap.entries.first.value.toString()
          : 'Unknown Title';

      final descriptionMap = mangaData['attributes']['description'];
      final description =
      descriptionMap != null && descriptionMap is Map
          ? descriptionMap['en'] ?? 'Description not available'
          : 'Description not available';

      final mangaAttributes = mangaData['attributes'];

      String status = mangaAttributes['status'] ?? 'Unknown Status'; // Default to 'Unknown Status'
      int year = mangaAttributes['year'] is int ? mangaAttributes['year'] : 0; // Default to 0 if not an integer

      final imageUrl = await _fetchMangaCover(mangaId);

      Manga manga = Manga(
        id: mangaId,
        title: title,
        description: description,
        status: status,
        year: year,
        imageUrl: imageUrl,
      );
      return manga;
    } else {
      throw Exception("Error retrieving manga: $mangaId");
    }
  }


  Future<List<Manga>> fetchLatestUploadedManga() async {
    final response = await http.get(Uri.parse(kLatestUploadsUrl));

    if (response.statusCode == 200) {
      final decodedJson = jsonDecode(response.body);
      final mangasData = decodedJson['data'] as List;

      List<Manga> mangas = await Future.wait(
        mangasData.map((mangaData) async {
          final id = mangaData['id'];
          final imageUrl = await _fetchMangaCover(id);
          return Manga(id: id, imageUrl: imageUrl);
        }),
      );

      return mangas;
    } else {
      throw Exception(
        "Failed to load latest mangas (code: ${response.statusCode})",
      );
    }
  }

  Future<List<Manga>> fetchMangasByCategory(String categoryUrl) async {
    final response = await http.get(Uri.parse(categoryUrl));

    if (response.statusCode == 200) {
      final decodedJson = jsonDecode(response.body);
      final mangasData = decodedJson['data'] as List;

      List<Manga> mangas = await Future.wait(
        mangasData.map((mangaData) async {
          final id = mangaData['id'];
          final imageUrl = await _fetchMangaCover(id);
          return Manga(id: id, imageUrl: imageUrl);
        }),
      );

      return mangas;
    } else {
      throw Exception("Failed to load mangas for the category");
    }
  }
}
