import 'dart:convert';

import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  String _apiMessage = "Checking API connection...";

  void initState(){
    super.initState();
    // Calls check on API
    _checkApi();
  }

  void _checkApi() async {
    final apiService = APIService();
    final result = await apiService.checkConnection();
    setState(() {
      _apiMessage = result['message'] ?? 'Unknown';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: const Center(child: Text('Login Page')),
    );
  }
  
}