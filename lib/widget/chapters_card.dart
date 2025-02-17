import 'package:flutter/material.dart';
import 'package:newscan/data/constant.dart';
import 'package:newscan/model/chapter.dart';
import 'package:newscan/service/chapters_service.dart';
import 'package:newscan/view/read_manga.dart';

class ChaptersCard extends StatefulWidget {
  final String mangaId;
  const ChaptersCard({super.key, required this.mangaId});

  @override
  State<ChaptersCard> createState() => _ChaptersCardState();
}

class _ChaptersCardState extends State<ChaptersCard> {
  late ChaptersService chaptersService;
  late Future<List<Chapter>> _chaptersFuture;

  @override
  void initState() {
    super.initState();
    chaptersService = ChaptersService();
    _chaptersFuture = _fetchChapters(widget.mangaId);
  }

  Future<List<Chapter>> _fetchChapters(String mangaId) async {
    try {
      return await chaptersService.fetchChapters(mangaId);
    } catch (e) {
      throw Exception("Error fetching chapters: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<List<Chapter>>(
        future: _chaptersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Color(kWhiteColor)),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No chapters available.',
                style: TextStyle(color: Color(kWhiteColor)),
              ),
            );
          }

          final chapters = snapshot.data!;
          return ListView.builder(
            itemCount: chapters.length,
            itemBuilder: (context, index) {
              final chapter = chapters[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReadManga(chapterId: chapter.id),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 10,
                  ),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(kAccentColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Volume: ${chapter.volume} / Chapter: ${chapter.chapter}',
                            style: const TextStyle(color: Color(kTextColor)),
                          ),
                          Expanded(child: Container()),
                          Icon(Icons.check, color: Color(kTextColor)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            chapter.title,
                            style: const TextStyle(color: Color(kTextColor)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
