import 'package:flutter/material.dart';
import 'package:newscan/data/constant.dart';
import 'package:newscan/view/favorites_view.dart';
import 'package:newscan/view/library_view.dart';
import 'package:newscan/view/search_view.dart';
import 'package:newscan/view/splash_view.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [routeObserver],
      title: 'MangaMemo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: SplashScreen(), // Définir SplashScreen comme page d'accueil
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  late final List<Widget> _views;

  @override
  void initState() {
    super.initState();
    _views = [const LibraryView(), const SearchView(), const FavoritesView()];
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
      body: SafeArea(child: _views[_selectedIndex]),
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
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
