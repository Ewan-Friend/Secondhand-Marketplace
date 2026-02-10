import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../models/item_model.dart';

class APIService {
  final http.Client _client;

  APIService({http.Client? client}) : _client = client ?? http.Client();

  /// Builds a safe URL by avoiding double slashes and duplicate `/api`.
  Uri _uri(String path) {
    final base = AppConfig.apiBaseUrl.trim();

    // Ensure base has no trailing slash
    final normalizedBase = base.endsWith('/')
        ? base.substring(0, base.length - 1)
        : base;

    // Ensure path starts with a slash
    final normalizedPath = path.startsWith('/') ? path : '/$path';

    return Uri.parse('$normalizedBase$normalizedPath');
  }

  /// Returns backend status message if reachable; throws otherwise.
  Future<String> checkConnection() async {
    final url = _uri('/status');

    try {
      final response = await _client.get(url);

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded is Map<String, dynamic>) {
          final msg = decoded['message'];
          return (msg is String && msg.isNotEmpty) ? msg : 'Backend reachable';
        }
        return 'Backend reachable';
      }

      throw Exception('Backend unreachable (${response.statusCode})');
    } catch (e) {
      throw Exception('Network/Server error: $e');
    }
  }

  Future<List<Item>> getItems() async {
    final url = _uri('/items');

    try {
      final response = await _client.get(url);

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded is Map<String, dynamic>) {
          final raw = decoded['table_data'];
          final list = (raw is List) ? raw : <dynamic>[];

          // if (kDebugMode) {
          //   debugPrint(response.body); 
          // }

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

  Future<Item> getItemFromID(dynamic id) async {

    if (id == null) throw Exception("Item id is Null");

    //Construt URL
    final url = Uri.parse('$baseUrl/item/$id');

    try{
        final response = await http.get(url);
        // Check status code of single item response by routes.py
        if (response.statusCode == 200){

          // Return decoded Item
          final Map<String, dynamic> data = json.decode(response.body);

          if (kDebugMode) {
            debugPrint(response.body); 
          }
          
          // Return data as an Item
          return Item.fromJson(data['table_data']);
        } else {
          throw Exception('Failed to load item: Server returned status ${response.statusCode}');
        }
    }
    catch (e){
      // Handles in case of errors
      throw Exception('Network/Server error: Ensure Flask server is running. $e');
    }
  }

  Future<Item> getItemFromID(dynamic id) async {
    if (id == null) throw Exception("Item id is Null");

    final url = _uri('/item/$id');

    try {
      final response = await _client.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (kDebugMode) {
          debugPrint(response.body);
        }
        return Item.fromJson(data['table_data']);
      } else {
        throw Exception('Failed to load item: Server returned status ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network/Server error: Ensure Flask server is running. $e');
    }
  }

  // ---- TEMP STUBS (to keep app compiling) ----
  Future<Map<String, dynamic>> getCurrentUserProfile() async {
    return {
      'data': {
        'id': 0,
        'email': 'placeholder@example.com',
        'display_name': 'Placeholder User',
      },
      'status_code': 200,
    };
  }

  Future<Map<String, dynamic>> getUserItems(int userId) async {
    return {
      'data': [],
      'status_code': 200,
    };
  }

  Future<Map<String, dynamic>> getUserReviews(int userId) async {
    return {
      'data': [],
      'status_code': 200,
    };
  }

  Future<Map<String, dynamic>> updateUserProfile({
    String? displayName,
    String? location,
  }) async {
    return {
      'message': 'Profile update stubbed',
      'status_code': 200,
    };
  }

  /// Optional: call this if you want to close the http client manually.
  void dispose() {
    _client.close();
  }
}