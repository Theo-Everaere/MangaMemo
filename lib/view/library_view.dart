import 'package:flutter/material.dart';
import 'package:newscan/model/manga.dart';
import 'package:newscan/service/manga_cache_service.dart';
import 'package:newscan/service/manga_service.dart';
import 'package:newscan/widget/manga_card.dart';

import '../data/constant.dart';

class LibraryView extends StatefulWidget {
  final MangaCacheService cacheService;
  const LibraryView({super.key, required this.cacheService});

  @override
  State<LibraryView> createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView> {
  late MangaService mangaService;
  List<Manga> latestMangas = [];
  List<Manga> martialArtsMangas = [];
  List<Manga> fantasyMangas = [];
  String? error;
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    mangaService = MangaService(widget.cacheService);
    _loadMangas();
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  Future<void> _loadMangas() async {
    try {
      final latest = await mangaService.fetchLatestUploadedManga();
      final martialArts = await mangaService.fetchMangasByCategory(kMartialArtsMangaCategoryUrl); // URL directe
      final fantasy = await mangaService.fetchMangasByCategory(kFantasyMangaCategoryUrl); // URL directe

      if (_isMounted) {
        setState(() {
          latestMangas = latest;
          martialArtsMangas = martialArts;
          fantasyMangas = fantasy;
        });
      }
    } catch (e) {
      if (_isMounted) {
        setState(() => error = e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (error != null) {
      return Center(child: Text('Erreur: $error'));
    }

    return latestMangas.isEmpty && martialArtsMangas.isEmpty && fantasyMangas.isEmpty
        ? const Center(child: CircularProgressIndicator(color: Color(kTitleColor),),)
        : SingleChildScrollView(
      child: Column(
        children: [
          // Latest Section
          _buildSection('Latest', latestMangas),

          // Martial Arts Section
          _buildSection('Martial Arts', martialArtsMangas),

          // Fantasy Section
          _buildSection('Fantasy', fantasyMangas),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Manga> mangas) {
    return mangas.isEmpty
        ? const SizedBox.shrink()
        : Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(kTitleColor),

                ),
              ),
            ),
          ),
          SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: mangas.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(right: 4.0),
                  child: MangaCard(manga: mangas[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

