import 'package:flutter/material.dart';
import 'package:newscan/data/constant.dart';
import 'package:newscan/model/manga.dart';
import 'package:newscan/service/favorites_service.dart';

class SearchResultCard extends StatefulWidget {
  final Manga manga;
  const SearchResultCard({super.key, required this.manga});

  @override
  State<SearchResultCard> createState() => _SearchResultCardState();
}

class _SearchResultCardState extends State<SearchResultCard> {
  late FavoritesService favoritesService;

  @override
  void initState() {
    favoritesService = FavoritesService();
    super.initState();
  }

  Future<void> _toggleFavorite() async {
    final bool currentStatus = await favoritesService.isFavorite(
      widget.manga.id,
    );

    if (currentStatus) {
      await favoritesService.removeFromFavorites(widget.manga.id);
    } else {
      await favoritesService.addToFavorites(widget.manga.id);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 3),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: Image.network(
                    widget.manga.imageUrl,
                    width: 280,
                    height: MediaQuery.of(context).size.height * 0.5,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => const Icon(
                          Icons.image_not_supported,
                          size: 100,
                          color: Colors.grey,
                        ),
                  ),
                ),
                Container(
                  width: 280,
                  color: Color(kWhiteColor),
                  padding: const EdgeInsets.all(6),
                  child: Text(
                    widget.manga.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(kTitleColor),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 10,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Color(kTitleColor),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
                border: Border(
                  left: BorderSide(color: Colors.white, width: 2),
                  bottom: BorderSide(color: Colors.white, width: 2),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: GestureDetector(
                  onTap: _toggleFavorite, // Lorsque l'icône est tapée, basculer les favoris
                  child: FutureBuilder<bool>(
                    future: favoritesService.isFavorite(widget.manga.id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator(
                          color: Color(kTitleColor),
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
                          ? Icon(Icons.favorite, color: Colors.red)
                          : Icon(Icons.favorite, color: Colors.white);
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
