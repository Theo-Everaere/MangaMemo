class Chapter {
  final String id;
  final String title;
  final String volume;
  final String chapter;
  final String translatedLanguage;
  final List<String> pages;

  Chapter({
    required this.id,
    this.title = "Title unavailable",
    this.volume = "?",
    this.chapter = "?",
    this.translatedLanguage = "en",
    this.pages = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'volume': volume,
      'chapter': chapter,
      'translatedLanguage': translatedLanguage,
      'pages': pages,
    };
  }

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      id: json['id'] ?? '',
      title: json['title'] ?? "Title unavailable",
      chapter: json['chapter'] ?? "?",
      translatedLanguage: json['translatedLanguage'] ?? "en",
      volume: json['volume'] ?? "?",
      pages: json['pages'] ?? "Pages not found",
    );
  }
}
