import 'dart:ui_web';
import 'package:application/pages/favourites_page.dart';
import 'package:application/pages/messages_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_strategy/url_strategy.dart';
import 'pages/home_page.dart';
import 'pages/item_detail_page.dart';
import 'pages/profile_page.dart';
import 'pages/login_page.dart';
import 'pages/post_items_page.dart';
import 'pages/sign_up_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Secondhand Marketplace',

      routerConfig: _router,

      // Unified theme
      theme: ThemeData(
        useMaterial3: true,
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            overlayColor: WidgetStateProperty.all(
              Colors.grey.shade100,
            ),
          ),
        ),
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE36D6D),
        ).copyWith(
          primary: const Color(0xFFE36D6D),
          surface: const Color.fromARGB(255, 255, 255, 255),
        ),
      ),
    );
  }
}

// --- This allows for named URLs to be on the site, allowing easier access ---
final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (context, state) {
        return const HomePage();
      },
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) {
        return const LoginPage();
      },
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) {
        return const SignUpPage();
      },
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) {
        return const ProfilePage();
      },
    ),
    GoRoute(
      path: '/post',
      builder: (context, state) {
        return const PostItemsPage();
      },
    ),
    GoRoute(
      path: '/item/:id',
      builder: (context, state) {
        final itemId = state.pathParameters['id']!;
        return ItemDetailPage(itemId: itemId);
      }
    ),
    GoRoute(
      path: '/favourites',
      builder: (context, state) {
        return const FavouritesPage();
      },
    ),
    GoRoute(
      path: '/messages',
      builder: (context, state) {
        return const MessagesPage();
      },
    ),
  ]
);
