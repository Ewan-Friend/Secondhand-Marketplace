import 'package:application/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _apiMessage = "Checking API connection..."; // Shows API status
  String _registrationMessage = ""; //Shows registration status (fail/success)

  void initState(){
    super.initState();
    // Calls check on API
    _checkApi();
  }

  void _checkApi() async {
    final apiService = APIService();
    final result = await apiService.checkConnection();
    // Only checks when the sign up page is in the tree
    if (mounted) {
      setState(() {
        _apiMessage = result['message'] ?? 'Unknown';
      });
    }
  }

  // Function that registers user according to validity rules
  void _registerUser() async{
    final String email = _emailController.text;
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    // Makes sure that both username and password are filled in correctly
    if (username.isEmpty || password.isEmpty || email.isEmpty) {
      setState(() {
        _registrationMessage = "One of the required fields is left empty";
      });
      return;
    }
    
    final url = Uri.parse('${APIService.baseUrl}/register');

    // Prepares the JSON payload to send to backend
    final Map<String, String> body = {
      'email' : email,
      'username': username,
      'password': password,
    };

    setState(() {
      _registrationMessage = 'Registering User...';
    });

    // TODO: try catch: success / error with sending HTTP post package
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sign Up Page',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800
              ),
              ),
            
            Text( 
              _apiMessage,
              style: const TextStyle(
              color: Colors.red,
              fontSize: 10,
              fontWeight: FontWeight.bold
              )
            ),

            const SizedBox(height: 50),

            const Text(
              'Create Your Account', 
              style: TextStyle(
                fontSize: 24, 
                fontWeight: FontWeight.bold
              )),
            const SizedBox(height: 30),

            // Email Field
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Username Field
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Password Field
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),

            // Register Button
            ElevatedButton(
              onPressed: _registerUser, // Call the registration method
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              ),
              child: const Text('Register', style: TextStyle(fontSize: 35)),
            ),
            const SizedBox(height: 20),

            // TODO: registration status message
          ],
        )
      )
    );
  }
  
}