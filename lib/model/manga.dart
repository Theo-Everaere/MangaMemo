class Manga {
  final String id;
  final String title;
  final String description;
  final String status;
  final int year;
  final String imageUrl;

  Manga({
    required this.id,
    this.title = "Pas de titre disponible",
    this.description = "Pas de description",
    this.status = "Statut inconnu",
    this.year = 0,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'year': year,
      'imageUrl': imageUrl,
    };
  }

  // Handling missing fields with default values
  factory Manga.fromJson(Map<String, dynamic> json) {
    return Manga(
      id: json['id'] ?? '',
      title: json['title'] ?? "Title unavailable",
      description: json['description'] ?? "Description unavailable",
      status: json['status'] ?? "Status unknown",
      year: json['year'] ?? "Year unknown",
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}
