import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/item_detail_page.dart';
import 'pages/profile_page.dart';
import 'pages/login_page.dart';
import 'pages/create_listing_page.dart';

void main() {
  runApp(const MainApp());
}

// StatelessWidget is a class that is used when creating an UI element that has no dynamic data
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // build will return a widget that will be rendered on the screen
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Secondhand Marketplace',
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/item': (context) => const ItemDetailPage(),
        '/login': (context) => const LoginPage(),
        '/create': (context) => const CreateListingPage(),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}
