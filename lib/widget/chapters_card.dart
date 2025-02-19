import 'package:flutter/material.dart';
import 'package:newscan/data/constant.dart';
import 'package:newscan/model/chapter.dart';
import 'package:newscan/service/chapters_read_service.dart';
import 'package:newscan/service/chapters_service.dart';
import 'package:newscan/view/read_manga_view.dart';

class ChaptersCard extends StatefulWidget {
  final String mangaId;
  const ChaptersCard({super.key, required this.mangaId});

  @override
  State<ChaptersCard> createState() => _ChaptersCardState();
}

class _ChaptersCardState extends State<ChaptersCard> {
  late final ChaptersService chaptersService;
  late final ChaptersReadService chaptersReadService;
  late Future<List<Chapter>> _chaptersFuture;

  @override
  void initState() {
    super.initState();
    chaptersService = ChaptersService();
    chaptersReadService = ChaptersReadService();
    _chaptersFuture = _fetchChapters(widget.mangaId);
  }

  Future<List<Chapter>> _fetchChapters(String mangaId) async {
    try {
      final chaptersList = await chaptersService.fetchChapters(mangaId);
      if (chaptersList.isEmpty) {
        throw Exception("No chapters found.");
      }
      return chaptersList;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _toggleAsRead(String chapterId) async {
    final bool currentStatus = await chaptersReadService.isChapterRead(
      chapterId,
    );

    if (currentStatus) {
      await chaptersReadService.removeChapterAsRead(chapterId);
    } else {
      await chaptersReadService.markChapterAsRead(chapterId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<List<Chapter>>(
        future: _chaptersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(kTitleColor)),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Failed to load chapters: ${snapshot.error}",
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          if (snapshot.hasData && snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No chapters available.',
                style: TextStyle(color: Color(kTitleColor)),
              ),
            );
          }

          final chapters = snapshot.data!;
          return ListView.builder(
            itemCount: chapters.length,
            itemBuilder: (context, index) {
              final chapter = chapters[index];
              final ValueNotifier<bool> isChapterReadNotifier =
              ValueNotifier<bool>(false);

              chaptersReadService.isChapterRead(chapter.id).then((isRead) {
                isChapterReadNotifier.value = isRead;
              });

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
                    vertical: 6,
                    horizontal: 10,
                  ),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(kBottomNavColor),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              chapter.title.isNotEmpty
                                  ? chapter.title
                                  : 'No title available',
                              style: const TextStyle(
                                color: Color(kTitleColor),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Vol. ${chapter.volume} - Ch. ${chapter.chapter}',
                              style: const TextStyle(
                                color: Color(kTitleColor),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ValueListenableBuilder<bool>(
                        valueListenable: isChapterReadNotifier,
                        builder: (context, isRead, child) {
                          return GestureDetector(
                            onTap: () async {
                              await _toggleAsRead(chapter.id);
                              isChapterReadNotifier.value = !isRead;
                            },
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: isRead
                                  ? Icon(
                                Icons.bookmark,
                                color: Colors.green,
                                key: const ValueKey("read"),
                                size: 32,
                              )
                                  : Icon(
                                Icons.bookmark_border,
                                color: const Color(kTextColor),
                                key: const ValueKey("unread"),
                                size: 32,
                              ),
                            ),
                          );
                        },
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
