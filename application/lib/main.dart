import 'package:application/auth/auth_gate.dart';
import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/item_detail_page.dart';
import 'pages/profile_page.dart';
import 'pages/login_page.dart';
import 'pages/post_items_page.dart';
import 'pages/sign_up_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Secondhand Marketplace',

      // start off at home page (can change to login at some point)
      initialRoute: '/',

      // Static routing table
      routes: {
        '/':   (_) => const HomePage(),
        '/login':  (_) => const LoginPage(),
        '/signup': (_) => const SignUpPage(),
        '/profile':(_) => const ProfilePage(),
        '/post':   (_) => const PostItemsPage(),
      },

      // Dynamic route
      onGenerateRoute: (proposedRoute){
        // open unique item page
        if (proposedRoute != null && proposedRoute.name!.startsWith("/item")){
          // Take the ID by removing everything before the last '/'
          final String itemId = proposedRoute.name!.split('/').last;

          return MaterialPageRoute(
            builder: (context) => ItemDetailPage(itemId: itemId)
          );
        }
      } ,

      // Unknown route protection: redirect to login page
      onUnknownRoute: (_) =>
          MaterialPageRoute(builder: (_) => const LoginPage()),

      //Unified theme
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
          primary: const Color(0xFFE36D6D), // force your exact color
          surface: const Color.fromARGB(255, 255, 255, 255), // force your exact color
        ),
      ),
    );
  }
}
