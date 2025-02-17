import 'dart:convert';
import 'package:newscan/data/constant.dart';
import 'package:newscan/model/manga.dart';
import 'package:http/http.dart' as http;

class MangaService {
  MangaService();

  Future<String> _kfetchMangaCover(String mangaId) async {
    final response = await http.get(Uri.parse('https://api.mangadex.org/cover?manga[]=$mangaId'));

    if (response.statusCode == 200) {
      try {
        final decodedJson = jsonDecode(response.body);
        final mangaData = decodedJson['data'] as List;

        if (mangaData.isEmpty) {
          throw Exception("Aucune donnée trouvée pour l'ID: $mangaId");
        }

        final fileName = mangaData.first['attributes']['fileName'];

        return 'https://uploads.mangadex.org/covers/$mangaId/$fileName.256.jpg';
      } catch (e) {
        throw Exception("Erreur lors du traitement des données: $e");
      }
    } else {
      throw Exception(
          "Impossible de charger l'image du manga avec l'ID: $mangaId (code: ${response.statusCode})");
    }
  }

  Future<Manga> fetchMangaDetails(String mangaId) async {
    final response = await http.get(Uri.parse("$kMangaByIdUrl/$mangaId"));

    // Affiche la réponse complète du serveur
    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final decodedJson = jsonDecode(response.body);
      final mangaData = decodedJson['data'];

      final titleMap = mangaData['attributes']['title'];
      final title = titleMap is Map && titleMap.isNotEmpty
          ? titleMap.entries.first.value.toString()
          : 'Titre Inconnu';

      // Affiche le titre
      print("Title: $title");

      // Récupérer la description en anglais ou une valeur par défaut
      final descriptionMap = mangaData['attributes']['description'];
      final description = descriptionMap != null && descriptionMap is Map
          ? descriptionMap['en'] ?? 'Description indisponible'
          : 'Description indisponible';

      // Affiche la description
      print("Description: $description");

      final mangaAttributes = mangaData['attributes'];

      String status = mangaAttributes['status'];
      int year = mangaAttributes['year'];

      // Affiche le statut et l'année
      print("Status: $status");
      print("Year: $year");

      final imageUrl = await _kfetchMangaCover(mangaId);

      // Affiche l'URL de l'image
      print("Image URL: $imageUrl");

      // Retourne le Manga
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
      throw Exception("Erreur lors de la récupération du manga: $mangaId");
    }
  }


  Future<List<Manga>> fetchLatestUploadedManga() async {
    final response = await http.get(Uri.parse(kLatestUploadsUrl));

    if (response.statusCode == 200) {
      final decodedJson = jsonDecode(response.body);
      final mangasData = decodedJson['data'] as List;

      List<Manga> mangas = await Future.wait(mangasData.map((mangaData) async {
        final id = mangaData['id'];
        final imageUrl = await _kfetchMangaCover(id);
        return Manga(id: id, imageUrl: imageUrl);
      }));

      return mangas;
    } else {
      throw Exception("Échec du chargement des mangas (code: ${response.statusCode})");
    }
  }

  Future<List<Manga>> fetchMangasByCategory(String categoryUrl) async {
    final response = await http.get(Uri.parse(categoryUrl));

    if (response.statusCode == 200) {
      final decodedJson = jsonDecode(response.body);
      final mangasData = decodedJson['data'] as List;

      List<Manga> mangas = await Future.wait(mangasData.map((mangaData) async {
        final id = mangaData['id'];
        final imageUrl = await _kfetchMangaCover(id);
        return Manga(id: id, imageUrl: imageUrl);
      }));

      return mangas;
    } else {
      throw Exception("Échec du chargement des mangas de la catégorie");
    }
  }
}
