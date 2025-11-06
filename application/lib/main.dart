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
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJha3l4emtmZG50Ym1oaGprbHRwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE5MTgwMTQsImV4cCI6MjA3NzQ5NDAxNH0.0YGZOLNn-nSba2B1fXJ4Hevq1zNPw7VIKyiGI2-CeWs',
  );



void main() async{

  // Create API service instance then check connection on startup
  // Morseso to test connection and can likely be discarded at a later point
  // WidgetsFlutterBinding.ensureInitialized();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Secondhand Marketplace',

     //Use AuthGate as the sole entry point
      home: AuthGate(),

      theme:  ThemeData(fontFamily: 'Poppins'),
      // ~~~~~~~~ Change initial route to desired starting page ~~~~~~~~~
      initialRoute: '/signup',
      routes: {
        '/home':   (_) => const HomePage(),
        '/item':   (_) => const ItemDetailPage(),
        '/login':  (_) => const LoginPage(),
        '/signup': (_) => const SignUpPage(),
        '/create': (_) => const CreateListingPage(),
        '/profile':(_) => const ProfilePage(),
      },

      // Unknown route fallback: automatically redirect users to the login page for safety and consistency.
      onUnknownRoute: (_) =>
          MaterialPageRoute(builder: (_) => const LoginPage()),

      // Simple theme
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6D8BFE)),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
