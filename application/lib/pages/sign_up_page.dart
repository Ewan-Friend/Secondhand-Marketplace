import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../services/api_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _apiMessage = "Checking API connection...";
  String _registrationMessage = "";

  @override
  void initState() {
    super.initState();
    _checkApi();
  }

  Future<void> _checkApi() async {
    final apiService = APIService();

    try {
      final message = await apiService.checkConnection(); // <-- String dönüyor
      if (!mounted) return;

      setState(() {
        _apiMessage = message;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _apiMessage = "Error: $e";
      });
    }
  }

  Future<void> _registerUser() async {
    final String email = _emailController.text.trim();
    final String username = _usernameController.text.trim();
    final String password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty || email.isEmpty) {
      setState(() {
        _registrationMessage = "One of the required fields is left empty";
      });
      return;
    }

    final url = Uri.parse('${AppConfig.apiBaseUrl}/register');

    final Map<String, String> body = {
      'email': email,
      'username': username,
      'password': password,
    };

    setState(() {
      _registrationMessage = 'Registering User...';
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      final dynamic decoded = jsonDecode(response.body);
      final Map<String, dynamic> responseData =
          decoded is Map<String, dynamic> ? decoded : <String, dynamic>{};

      if (!mounted) return;

      if (response.statusCode == 201 || response.statusCode == 202) {
        setState(() {
          _registrationMessage =
              (responseData['message'] as String?) ?? 'Registration successful!';
        });
      } else {
        setState(() {
          _registrationMessage =
              (responseData['message'] as String?) ?? 'Registration failed';
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _registrationMessage = 'Network Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sign Up Page',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
                ),
                Text(
                  _apiMessage,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 50),
                const Text(
                  'Create Your Account',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),

                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: _registerUser,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 30,
                    ),
                  ),
                  child: const Text('Register', style: TextStyle(fontSize: 35)),
                ),

                const SizedBox(height: 20),

                if (_registrationMessage.isNotEmpty)
                  Center(
                    child: Text(
                      _registrationMessage,
                      style: TextStyle(
                        color: _registrationMessage
                                    .toLowerCase()
                                    .contains('success') ||
                                _registrationMessage
                                    .toLowerCase()
                                    .contains('successfully')
                            ? Colors.green
                            : Colors.red,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}