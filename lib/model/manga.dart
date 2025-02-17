class Manga {
  final String id;
  final String title;
  final String description;
  final String status;
  final String year;
  final String imageUrl;

  Manga({
    required this.id,
    this.title = "Pas de titre disponible",
    this.description = "Pas de description",
    this.status = "Statut inconnu",
    this.year = "Année inconnue",
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

  // Gestion des champs manquants via des valeurs par défaut
  factory Manga.fromJson(Map<String, dynamic> json) {
    return Manga(
      id: json['id'] ?? '',
      title: json['title'] ?? "Pas de titre disponible",
      description: json['description'] ?? "Pas de description",
      status: json['status'] ?? "Statut inconnu",
      year: json['year'] ?? "Année inconnue",
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}
