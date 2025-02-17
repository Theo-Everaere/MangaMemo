import 'package:flutter/material.dart';
import 'package:newscan/data/constant.dart';
import 'package:newscan/service/chapters_service.dart';

class ReadManga extends StatefulWidget {
  final String chapterId;

  ReadManga({required this.chapterId});

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
      backgroundColor: Color(kMainBgColor),
      body: FutureBuilder<List<String>>(
        future: pages,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No pages available.'));
          }

          final List<String> pagesList = snapshot.data!;

          return SafeArea(
            child: ListView.builder(
              itemCount: pagesList.length,
              itemBuilder: (context, index) {
                return Image.network(pagesList[index], fit: BoxFit.contain);
              },
            ),
          );
        },
      ),
    );
  }
}
