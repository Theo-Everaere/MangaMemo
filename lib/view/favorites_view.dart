import 'package:flutter/material.dart';
import 'package:newscan/data/constant.dart';
import 'package:newscan/model/manga.dart';
import 'package:newscan/service/favorites_service.dart';
import 'package:newscan/service/manga_service.dart';
import 'package:newscan/widget/favorites_card.dart';

class FavoritesView extends StatefulWidget {
  const FavoritesView({super.key});

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  late FavoritesService favoritesService;
  late MangaService mangaService;
  late Future<List<Manga>> _favoriteMangas;

  @override
  void initState() {
    super.initState();
    favoritesService = FavoritesService();
    mangaService = MangaService();
    _favoriteMangas = _loadFavoriteMangas();
  }

  // Load mangas from favorites
  Future<List<Manga>> _loadFavoriteMangas() async {
    final ids = await favoritesService.getFavorites();
    List<Manga> mangas = [];
    for (var id in ids) {
      final manga = await mangaService.fetchMangaDetails(id);
      mangas.add(manga);
    }
    return mangas;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            'My Favorites',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(kTitleColor),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: FutureBuilder<List<Manga>>(
              future: _favoriteMangas,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(kTitleColor)),
                  );
                } else if (snapshot.hasError) {
                  return const Text(
                    "Error loading favorite mangas.",
                    style: TextStyle(color: Color(kTitleColor)),
                  );
                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      "No favorites found.",
                      style: TextStyle(color: Color(kTitleColor)),
                    ),
                  );
                } else if (snapshot.hasData) {
                  final mangas = snapshot.data!;
                  return ListView.separated(
                    itemCount: mangas.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final manga = mangas[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: FavoritesCard(
                          manga: manga,
                          onDelete: () async {
                            await favoritesService.removeFromFavorites(
                              manga.id,
                            );
                            setState(() {
                              _favoriteMangas = _loadFavoriteMangas();
                            });
                          },
                        ),
                      );
                    },
                  );
                }
                return const Text("Unexpected state.");
              },
            ),
          ),
        ],
      ),
    );
  }
}
