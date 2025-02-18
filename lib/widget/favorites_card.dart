import 'package:flutter/material.dart';
import 'package:newscan/data/constant.dart';
import 'package:newscan/model/manga.dart';
import 'package:newscan/view/manga_details_view.dart';

class FavoritesCard extends StatelessWidget {
  final Manga manga;
  final VoidCallback onDelete;

  const FavoritesCard({super.key, required this.manga, required this.onDelete});

  // Widget réutilisable pour l'image
  Widget _buildImage(String imageUrl) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          imageUrl,
          width: 80,
          height: 120,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(kBottomNavColor),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return MangaDetailsView(mangaId: manga.id);
              },
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              // Utilisation du widget réutilisable
              _buildImage(manga.imageUrl),

              const SizedBox(width: 12),

              // Texte du manga avec un contrôle sur la taille et les débordements
              Expanded(
                child: Text(
                  manga.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis, // "..."
                  style: TextStyle(
                    color: Color(kTitleColor),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),

              // Bouton de suppression
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
