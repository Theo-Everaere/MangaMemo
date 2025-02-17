import 'dart:convert';
import 'package:newscan/data/constant.dart';
import 'package:newscan/model/manga.dart';
import 'package:http/http.dart' as http;
import 'package:newscan/service/manga_cache_service.dart';

class MangaService {
  final MangaCacheService cacheService;

  MangaService(this.cacheService);

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

  Future<Manga> fetchMangaDetails(String mangaId) async{
    final response = await http.get(Uri.parse("$kMangaByIdUrl/$mangaId"));

    if(response.statusCode ==200){
      final decodedJson = jsonDecode(response.body);
      final mangaData = decodedJson['data'];

      String id = mangaData['id'];
      final mangaAttributes = mangaData['attributes'];
      String title = mangaAttributes['title']['en'];
      String description = mangaAttributes['description']['en'];
      String status = mangaAttributes['status'];
      String year = mangaAttributes['year'];
      final imageUrl = await _kfetchMangaCover(id);

      Manga manga = Manga(id: id, title: title, description: description, status: status, year: year, imageUrl: imageUrl);
      return manga;

    } else {
      throw Exception("Erreur lors de la récupération du manga: $mangaId");
    }
  }
  
  Future<List<Manga>> fetchLatestUploadedManga() async {
    if (cacheService.isCacheValid()) {
      final cachedMangas = cacheService.getMangas();
      if (cachedMangas != null && cachedMangas.isNotEmpty) {
        return cachedMangas;
      }
    }

    final response = await http.get(Uri.parse(kLatestUploadsUrl));

    if (response.statusCode == 200) {
      final decodedJson = jsonDecode(response.body);
      final mangasData = decodedJson['data'] as List;

      List<Manga> mangas = await Future.wait(mangasData.map((mangaData) async {
        final id = mangaData['id'];
        final titleMap = mangaData['attributes']['title'];
        final title = titleMap is Map && titleMap.isNotEmpty
            ? titleMap.entries.first.value.toString()
            : 'Titre Inconnu';

        // Récupérer la description en anglais ou une valeur par défaut
        final descriptionMap = mangaData['attributes']['description'];
        final description = descriptionMap != null && descriptionMap is Map
            ? descriptionMap['en'] ?? 'Description indisponible'
            : 'Description indisponible';

        final imageUrl = await _kfetchMangaCover(id);
        return Manga(id: id, title: title, description: description, imageUrl: imageUrl);
      }));

      await cacheService.saveMangas(mangas);
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
        final titleMap = mangaData['attributes']['title'];
        final title = titleMap is Map && titleMap.isNotEmpty
            ? titleMap.entries.first.value.toString()
            : 'Titre Inconnu';

        // Récupérer la description en anglais ou une valeur par défaut
        final descriptionMap = mangaData['attributes']['description'];
        final description = descriptionMap != null && descriptionMap is Map
            ? descriptionMap['en'] ?? 'Description indisponible'
            : 'Description indisponible';

        final imageUrl = await _kfetchMangaCover(id);
        return Manga(id: id, title: title, description: description, imageUrl: imageUrl);
      }));

      return mangas;
    } else {
      throw Exception("Échec du chargement des mangas de la catégorie");
    }
  }
}
