import 'package:flutter/material.dart';
import 'package:newscan/data/constant.dart';
import 'package:newscan/model/manga.dart';
import 'package:newscan/service/search_service.dart';
import 'package:newscan/view/manga_details_view.dart';
import 'package:newscan/widget/search_result_card.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _controller = TextEditingController();
  Future<List<Manga>> _searchResults = Future.value([]);
  bool _isLoading = false;

  void _searchManga() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final service = SearchService();
      _searchResults = service.searchMangaByTitle(_controller.text);
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
      print('Search error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(kMainBgColor),
      appBar: AppBar(
        title: const Text(
          'Search by Title',
          style: TextStyle(color: Color(kTitleColor)),
        ),
        backgroundColor: Color(kMainBgColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              style: TextStyle(color: Color(kTextColor)),
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter manga title here',
                labelStyle: TextStyle(color: Color(kTextColor)),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  color: Color(kTextColor),
                  onPressed: _searchManga,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(kTitleColor), width: 2.0),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
              onSubmitted: (_) => _searchManga(),
            ),
            const SizedBox(height: 10),
            if (_isLoading)
              const CircularProgressIndicator(color: Color(kTitleColor)),
            Expanded(
              child: FutureBuilder<List<Manga>>(
                future: _searchResults,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Color(kTitleColor)),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "No manga found for this title, please try again.",
                        style: const TextStyle(color: Color(kTitleColor)),
                      ),
                    );
                  }

                  final mangas = snapshot.data ?? [];

                  if (mangas.isEmpty) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Enter manga title',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Color(kTitleColor)),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.arrow_upward, color: Color(kTitleColor),)
                      ],
                    );
                  }

                  return ListView.builder(
                    itemCount: mangas.length,
                    itemBuilder: (context, index) {
                      final manga = mangas[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MangaDetailsView(mangaId: manga.id),
                            ),
                          );
                        },
                        child: SearchResultCard(manga: manga),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

