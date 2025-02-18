import 'package:flutter/material.dart';
import 'package:newscan/main.dart';
import 'package:newscan/model/manga.dart';
import 'package:newscan/service/manga_service.dart';
import 'package:newscan/widget/manga_card.dart';
import '../data/constant.dart';

class LibraryView extends StatefulWidget {
  const LibraryView({super.key});

  @override
  State<LibraryView> createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView> with RouteAware {
  late MangaService mangaService;
  List<Manga> latestMangas = [];
  List<Manga> martialArtsMangas = [];
  List<Manga> fantasyMangas = [];
  List<Manga> fullColorMangas = [];
  String? error;

  @override
  void initState() {
    super.initState();
    mangaService = MangaService();
    _loadMangas();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final modalRoute = ModalRoute.of(context);
    if (modalRoute is PageRoute) {
      routeObserver.subscribe(this, modalRoute);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    _loadMangas();
  }

  Future<void> _loadMangas() async {
    try {
      final latest = await mangaService.fetchLatestUploadedManga();
      final martialArts = await mangaService.fetchMangasByCategory(kMartialArtsCategoryUrl);
      final fantasy = await mangaService.fetchMangasByCategory(kFantasyCategoryUrl);
      final fullColor = await mangaService.fetchMangasByCategory(kFullColorCategoryUrl);

      if (mounted) {
        setState(() {
          latestMangas = latest;
          martialArtsMangas = martialArts;
          fantasyMangas = fantasy;
          fullColorMangas = fullColor;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => error = e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (error != null) {
      return Center(child: Text('Erreur: $error'));
    }

    return latestMangas.isEmpty &&
        martialArtsMangas.isEmpty &&
        fantasyMangas.isEmpty
        ? const Center(
      child: CircularProgressIndicator(color: Color(kTitleColor)),
    )
        : SingleChildScrollView(
      child: Column(
        children: [
          _buildSection('Latest', latestMangas),
          _buildSection('Martial Arts', martialArtsMangas),
          _buildSection('Fantasy', fantasyMangas),
          _buildSection('Full Color', fullColorMangas),
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
                  fontSize: 18,
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
