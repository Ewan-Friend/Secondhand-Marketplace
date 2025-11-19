// Imports
import 'dart:convert';
// import 'dart:nativewrappers/_internal/vm/lib/ffi_patch.dart';
import 'package:http/http.dart' as http;
import '../models/item_model.dart';
import 'package:flutter/foundation.dart';

class APIService {

  static const String baseUrl = 'http://localhost:5000/api';
  // Client for use in other methods/classes
  static final http.Client httpClient = http.Client();

  Future<Map<String, dynamic>> checkConnection() async {
      // Construct URL
      final url = Uri.parse('$baseUrl/status');

      try {
        // request http using GET
        final response = await http.get(url);

        // Checks statusCode of message response sent from routes.py
        if (response.statusCode == 200) {
          // Return decoded data (connection message in this case)
          return json.decode(response.body);
        } else {
          // If status code is not 200, return the actual status code
          return {'message': 'Connection Failed: ${response.statusCode}'};
        }
      }
      catch (e) {
        // Handle in case of errors
        throw Exception('Network/Server error: Ensure Flask server is running. $e');
      }
  }

  Future<List<Item>> getItems() async {
    //Construct URL
    final url = Uri.parse('$baseUrl/items');

    try {
      final response = await http.get(url);
        // Checks statusCode of items response sent from routes.py
        if (response.statusCode == 200) {

          // Return decoded data (A list of the class 'Item')
          final Map<String, dynamic> responseData = json.decode(response.body);
          final List<dynamic> data = responseData['table_data'];

          if (kDebugMode) {
            debugPrint(response.body); 
          }

          return data.map((json) => Item.fromJson(json)).toList();
        } else {
          // If status code is not 200, return the actual status code
          throw Exception('Failed to load items: Server returned status ${response.statusCode}');
        }
    }
    catch (e){
        // Handle in case of errors
        throw Exception('Network/Server error: Ensure Flask server is running. $e');
    }
  }
}
