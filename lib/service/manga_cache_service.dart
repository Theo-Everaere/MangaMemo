import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:newscan/model/manga.dart';

class MangaCacheService {
  final SharedPreferences prefs;

  MangaCacheService(this.prefs);

  static const String cacheKey = 'latest_mangas';
  static const String cacheTimestampKey = 'latest_mangas_timestamp';

  // Enregistrer les mangas en cache
  Future<void> saveMangas(List<Manga> mangas) async {
    final encodedMangas = jsonEncode(mangas.map((m) => m.toJson()).toList());
    await prefs.setString(cacheKey, encodedMangas);
    await prefs.setInt(
      cacheTimestampKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  // Charger les mangas depuis le cache
  List<Manga>? getMangas() {
    final encodedMangas = prefs.getString(cacheKey);
    if (encodedMangas != null) {
      final List decoded = jsonDecode(encodedMangas);
      return decoded.map((e) => Manga.fromJson(e)).toList();
    }
    return null;
  }

  // Vérifier si le cache est valide (ex. moins d'une heure)
  bool isCacheValid({int maxAgeInMinutes = 60}) {
    final timestamp = prefs.getInt(cacheTimestampKey);
    if (timestamp == null) return false;

    final now = DateTime.now().millisecondsSinceEpoch;
    final diffMinutes = (now - timestamp) / (1000 * 60);
    return diffMinutes <= maxAgeInMinutes;
  }
}
