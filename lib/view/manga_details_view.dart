import 'package:flutter/material.dart';
import 'package:newscan/data/constant.dart';
import 'package:newscan/service/favorites_service.dart';
import 'package:newscan/service/manga_service.dart';
import 'package:newscan/model/manga.dart';
import 'package:newscan/widget/chapters_card.dart';

class MangaDetailsView extends StatefulWidget {
  final String mangaId;
  const MangaDetailsView({super.key, required this.mangaId});

  @override
  _MangaDetailsViewState createState() => _MangaDetailsViewState();
}

class _MangaDetailsViewState extends State<MangaDetailsView>
    with SingleTickerProviderStateMixin {
  late MangaService mangaService;
  late FavoritesService favoritesService;
  bool _isExpanded = false;
  late Future<Manga> _mangaFuture;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    mangaService = MangaService();
    favoritesService = FavoritesService();
    _mangaFuture = mangaService.fetchMangaDetails(widget.mangaId);
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _toggleFavorites() async {
    final bool currentStatus = await favoritesService.isFavorite(
      widget.mangaId,
    );
    if (currentStatus) {
      await favoritesService.removeFromFavorites(widget.mangaId);
    } else {
      await favoritesService.addToFavorites(widget.mangaId);
    }
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(kMainBgColor),
      appBar: AppBar(
        title: const Text(
          'Details',
          style: TextStyle(color: Color(kAccentColor)),
        ),
        iconTheme: IconThemeData(color: Color(kAccentColor)),
        backgroundColor: Color(kMainBgColor),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'Overview'), Tab(text: 'Chapters')],
          indicatorColor: Color(kAccentColor),
          labelColor: Color(kAccentColor),
          unselectedLabelColor: Color(kTextColor),
        ),
      ),
      body: FutureBuilder<Manga>(
        future: _mangaFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(kTitleColor)),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No manga found.'));
          }

          final manga = snapshot.data!;

          return TabBarView(
            controller: _tabController,
            children: [
              // TAB "Details"
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.network(manga.imageUrl),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Padding(
                            padding: const EdgeInsets.only(
                              top: 15,
                              bottom: 15
                            ),
                            child: Text('Favorite Status  : ', style: TextStyle(
                                fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(kTextColor),
                            ),),
                          ),
                          GestureDetector(
                            onTap: _toggleFavorites,
                            child: FutureBuilder<bool>(
                              future: favoritesService.isFavorite(
                                widget.mangaId,
                              ),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator(
                                    color: Color(kTitleColor),
                                  );
                                }
                                if (snapshot.hasError || !snapshot.hasData) {
                                  return Icon(
                                    Icons.favorite_outline,
                                    color: Color(kWhiteColor),
                                  );
                                }
                                final isFavorite = snapshot.data!;
                                return isFavorite
                                    ? Icon(Icons.favorite, color: Colors.red)
                                    : Icon(
                                      Icons.favorite,
                                      color: Color(kWhiteColor),
                                    );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        manga.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(kTitleColor),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _isExpanded
                            ? manga.description
                            : manga.description.length > 100
                            ? manga.description.substring(0, 100) + '...'
                            : manga.description,
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(kTextColor),
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 10),
                      if (manga.description.length > 100)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isExpanded = !_isExpanded;
                            });
                          },
                          child: Text(
                            _isExpanded ? 'Show less' : 'Show more',
                            style: TextStyle(color: Color(kTextSecondaryColor)),
                          ),
                        ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Text(
                            'Status: ',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(kTitleColor),
                            ),
                          ),
                          Text(
                            manga.status,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(kTextColor),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Text(
                            'Year: ',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(kTitleColor),
                            ),
                          ),
                          Text(
                            manga.year.toString(),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(kTextColor),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // TAB "Chapters"
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [ChaptersCard(mangaId: manga.id)],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
