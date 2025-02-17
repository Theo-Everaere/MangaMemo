import 'package:flutter/material.dart';
import 'package:newscan/data/constant.dart';
import 'package:newscan/model/manga.dart';

class MangaDetailsView extends StatefulWidget {
  final Manga manga;

  const MangaDetailsView({super.key, required this.manga});


  @override
  _MangaDetailsViewState createState() => _MangaDetailsViewState();
}

class _MangaDetailsViewState extends State<MangaDetailsView> {

  bool _isExpanded = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }



  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: const Color(kMainBgColor),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(kIconActiveColor)),
        title: const Text(
          "Détails du Manga",
          style: TextStyle(color: Color(kTitleColor)),
        ),
        backgroundColor: Color(kMainBgColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image avec gestion des erreurs
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  widget.manga.imageUrl,
                  height: 300,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => const Icon(
                        Icons.image_not_supported,
                        size: 100,
                        color: Colors.grey,
                      ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Titre du manga
            Text(
              widget.manga.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(kTitleColor),
              ),
            ),
            const SizedBox(height: 10),

            // Description partielle avec un bouton "Voir plus"
            Text(
              _isExpanded
                  ? widget
                      .manga
                      .description // Afficher la description complète
                  : widget.manga.description.length > 100
                  ? widget.manga.description.substring(0, 100) +
                      '...' // Afficher un extrait
                  : widget
                      .manga
                      .description, // Si la description est courte, afficher tout
              style: TextStyle(fontSize: 16, color: Color(kTextColor)),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 10),

            // Bouton pour voir plus ou moins de texte
            if (widget.manga.description.length > 100)
              TextButton(
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Text(
                  _isExpanded ? 'Voir moins' : 'Voir plus',
                  style: TextStyle(color: Color(kTextSecondaryColor)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
