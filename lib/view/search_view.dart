import 'package:flutter/material.dart';
import 'package:newscan/data/constant.dart';
import 'package:newscan/model/manga.dart';
import 'package:newscan/service/search_service.dart';
import 'package:newscan/view/manga_details_view.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _controller = TextEditingController();
  List<Manga> _searchResults = [];
  bool _isLoading = false;

  void _searchManga() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final service = SearchService();
      final result = await service.searchMangaByTitle(_controller.text);
      setState(() {
        _searchResults = [result];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle error
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
              child: Expanded(
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final manga = _searchResults[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    MangaDetailsView(mangaId: manga.id),
                          ),
                        );
                      },
                      child: Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 3),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(7),
                                child: Image.network(
                                  manga.imageUrl,
                                  width: 280,
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) =>
                                          const Icon(
                                            Icons.image_not_supported,
                                            size: 100,
                                            color: Colors.grey,
                                          ),
                                ),
                              ),
                              Container(
                                width: 280,
                                color: Color(kWhiteColor),
                                padding: const EdgeInsets.all(6),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    manga.title,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(kTitleColor),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
