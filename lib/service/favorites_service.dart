import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  // Add a manga ID to favorites
  Future<void> addToFavorites(String mangaId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];

    if (!favorites.contains(mangaId)) {
      favorites.add(mangaId);
      await prefs.setStringList('favorites', favorites);
    }
  }

  // Get all favorite manga IDs
  Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('favorites') ?? [];
  }

  // Remove a manga ID from favorites
  Future<void> removeFromFavorites(String mangaId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];

    if (favorites.contains(mangaId)) {
      favorites.remove(mangaId);
      await prefs.setStringList('favorites', favorites);
    }
  }

  // Check if a manga ID is a favorite
  Future<bool> isFavorite(String mangaId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];
    return favorites.contains(mangaId);
  }
}
