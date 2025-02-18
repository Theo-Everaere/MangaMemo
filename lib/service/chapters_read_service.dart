import 'package:shared_preferences/shared_preferences.dart';

class ChaptersReadService {
  static const String _key = 'read_chapters';

  Future<void> markChapterAsRead(String chapterId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> readChapters = prefs.getStringList(_key) ?? [];

    if (!readChapters.contains(chapterId)) {
      readChapters.add(chapterId);
      await prefs.setStringList(_key, readChapters);
    }
  }

  Future<void> removeChapterAsRead(String chapterId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> readChapters = prefs.getStringList(_key) ?? [];

    if (readChapters.contains(chapterId)) {
      readChapters.remove(chapterId);
      await prefs.setStringList(_key, readChapters);
    }
  }

  Future<bool> isChapterRead(String chapterId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> readChapters = prefs.getStringList(_key) ?? [];
    return readChapters.contains(chapterId);
  }
}
