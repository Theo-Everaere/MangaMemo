import 'package:flutter/material.dart';
import 'package:newscan/data/constant.dart';
import 'package:newscan/model/manga.dart';
import 'package:newscan/service/favorites_service.dart';
import 'package:newscan/view/manga_details_view.dart';

class MangaCard extends StatefulWidget {
  final Manga manga;

  const MangaCard({super.key, required this.manga});

  @override
  State<MangaCard> createState() => _MangaCardState();
}

class _MangaCardState extends State<MangaCard> {
  late FavoritesService favoritesService;

  @override
  void initState() {
    super.initState();
    favoritesService = FavoritesService();
  }

  // Fonction pour changer le statut des favoris
  Future<void> _toggleFavorite() async {
    final bool currentStatus = await favoritesService.isFavorite(widget.manga.id);

    if (currentStatus) {
      await favoritesService.removeFromFavorites(widget.manga.id);
    } else {
      await favoritesService.addToFavorites(widget.manga.id);
    }

    // Après avoir ajouté ou retiré, rafraîchir l'interface
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MangaDetailsView(mangaId: widget.manga.id),
          ),
        );
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white, width: 2),
            ),
            margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.network(
                widget.manga.imageUrl,
                width: 100,
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.image_not_supported,
                  size: 100,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          Positioned(
            top: 2,
            right: 2,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(kTitleColor),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
                border: const Border(
                  left: BorderSide(color: Colors.white, width: 2),
                  bottom: BorderSide(color: Colors.white, width: 2),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: GestureDetector(
                  onTap: _toggleFavorite,
                  child: FutureBuilder<bool>(
                    future: favoritesService.isFavorite(widget.manga.id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator(
                          color: Colors.white,
                        );
                      }

                      if (snapshot.hasError || !snapshot.hasData) {
                        return Icon(
                          Icons.favorite_border,
                          color: Color(kWhiteColor),
                        );
                      }

                      final isFavorite = snapshot.data!;

                      return isFavorite
                          ? const Icon(Icons.favorite, color: Colors.red)
                          : const Icon(Icons.favorite, color: Colors.white);
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
