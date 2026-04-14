import 'package:flutter/material.dart';
import '../widgets/header.dart';

class FavouritesPage extends StatelessWidget {
  const FavouritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: Header(showSearch: false, showBackButton: true), // search functionality disabled
      ),
      body: const Center(child: Text('Favourites Page')),
    );
  }
}