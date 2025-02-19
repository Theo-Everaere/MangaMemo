class Manga {
  final String id;
  final String title;
  final String description;
  final String status;
  final int year;
  final String imageUrl;

  Manga({
    required this.id,
    this.title = "No title available",
    this.description = "No description",
    this.status = "Unknown status",
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

  factory Manga.fromJson(Map<String, dynamic> json) {
    return Manga(
      id: json['id'] ?? '',
      title: json['title'] ?? "No title available",
      description: json['description'] ?? "No description",
      status: json['status'] ?? "Unknown status",
      year: json['year'] ?? 0,
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}
