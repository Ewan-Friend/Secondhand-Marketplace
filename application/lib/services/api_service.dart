// Imports
import 'dart:convert';
// import 'dart:nativewrappers/_internal/vm/lib/ffi_patch.dart';
import 'package:http/http.dart' as http;

const String _baseUrl = 'http://localhost:5000/api';

class APIService {
  Future<Map<String, dynamic>> checkConnection() async {
      // Construct URL
      final url = Uri.parse('$_baseUrl/status');

      try {
        // request http using GET
        final response = await http.get(url);

        // Checks statusCode of message response sent from routes.py
        if (response.statusCode == 200) {
          // Return decoded data (connection message in this case)
          return jsonDecode(response.body);
        } else {
          // If status code is not 200, return the actual status code
          return {'message': 'Connection Failed: ${response.statusCode}'};
        }
      }
      catch (e) {
        // Handle in case of errors
        return {'message': 'Network Error: $e'};
      }
  }
}