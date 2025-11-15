import 'package:application/auth/auth_gate.dart';
import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/item_detail_page.dart';
import 'pages/profile_page.dart';
import 'pages/login_page.dart';
import 'pages/sign_up_page.dart';
import 'pages/create_listing_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://rakyxzkfdntbmhhjkltp.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJha3l4emtmZG50Ym1oaGprbHRwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE5MTgwMTQsImV4cCI6MjA3NzQ5NDAxNH0.0YGZOLNn-nSba2B1fXJ4Hevq1zNPw7VIKyiGI2-CeWs',
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Secondhand Marketplace',

      // Single Entry Point
      home: const HomePage(),

      // Routing table
      routes: {
        '/home':   (_) => HomePage(),
        '/item':   (_) => ItemDetailPage(),
        '/login':  (_) => LoginPage(),
        '/signup': (_) => SignUpPage(),
        '/create': (_) => CreateListingPage(),
        '/profile':(_) => ProfilePage(),
      },

      // Unknown route protection: redirect to login page
      onUnknownRoute: (_) =>
          MaterialPageRoute(builder: (_) => const LoginPage()),

      //Unified theme
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6D8BFE)),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
