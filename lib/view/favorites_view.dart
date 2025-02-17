import 'package:flutter/material.dart';
import 'package:newscan/data/constant.dart';

class FavoritesView extends StatefulWidget {
  const FavoritesView({super.key});

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Favorites View', style: TextStyle(
        color: Color(kTitleColor)
      ),),
    );
  }
}
