import 'package:flutter/material.dart';
import 'package:newscan/data/constant.dart';
import 'package:newscan/service/manga_cache_service.dart';
import 'package:newscan/view/favorites_view.dart';
import 'package:newscan/view/library_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final cacheService = MangaCacheService(prefs);

  runApp(MyApp(cacheService: cacheService));
}

class MyApp extends StatelessWidget {
  final MangaCacheService cacheService;

  const MyApp({super.key, required this.cacheService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Manga App',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: MyHomePage(cacheService: cacheService),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final MangaCacheService cacheService;

  const MyHomePage({super.key, required this.cacheService});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  // Déclare _views sans initialisation
  late final List<Widget> _views;

  @override
  void initState() {
    super.initState();
    // Initialiser _views avec cacheService dans initState
    _views = [
      LibraryView(cacheService: widget.cacheService),
      const FavoritesView(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(kMainBgColor),
      body: SafeArea(
        child: _views[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(kBottomNavColor),
        fixedColor: const Color(kIconActiveColor),
        unselectedItemColor: Color(kIconInactiveColor),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_rounded),
            label: 'Library',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}

