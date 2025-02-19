import 'package:flutter/material.dart';
import 'package:newscan/data/constant.dart';
import 'package:newscan/service/chapters_service.dart';

class ReadManga extends StatefulWidget {
  final String chapterId;

  const ReadManga({required this.chapterId});

  @override
  _ReadMangaState createState() => _ReadMangaState();
}

class _ReadMangaState extends State<ReadManga> {
  late Future<List<String>> pages;

  @override
  void initState() {
    super.initState();
    pages = ChaptersService().fetchPagesWithChapterId(widget.chapterId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(kMainBgColor),
      body: FutureBuilder<List<String>>(
        future: pages,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(kTitleColor)),
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No pages available.'));
          }

          final List<String> pagesList = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              children: pagesList.map((url) {
                return Image.network(
                  url,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;  // Image loaded
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                              (loadingProgress.expectedTotalBytes ?? 1)
                              : null,
                          color: const Color(kTitleColor),
                        ),
                      );
                    }
                  },
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
