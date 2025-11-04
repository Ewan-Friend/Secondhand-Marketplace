import 'package:flutter/material.dart';
import 'pages/home_page.dart';import 'pages/item_detail_page.dart';
import 'pages/profile_page.dart';
import 'pages/login_page.dart';
import 'pages/sign_up_page.dart';
import 'pages/create_listing_page.dart';
import 'services/api_service.dart';


void main() async{

  // Create API service instance then check connection on startup
  // Morseso to test connection and can likely be discarded at a later point
  // WidgetsFlutterBinding.ensureInitialized();

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
      theme:  ThemeData(fontFamily: 'Poppins'),
      // ~~~~~~~~ Change initial route to desired starting page ~~~~~~~~~
      initialRoute: '/signup',
      routes: {
        '/': (context) => const HomePage(),
        '/item': (context) => const ItemDetailPage(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/create': (context) => const CreateListingPage(),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}


