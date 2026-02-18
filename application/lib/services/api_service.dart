import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

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

          return list
              .whereType<Map<String, dynamic>>()
              .map(Item.fromJson)
              .toList();
        }
        return <Item>[];
      }

      throw Exception('Failed to load items (${response.statusCode})');
    } catch (e) {
      throw Exception('Items fetch failed: $e');
    }
  }

  Future<Map<String, dynamic>> postNewItem(Map<String, dynamic> data) async {
  final url = _uri('/items');

  try {
    final response = await _client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (kDebugMode) {
        debugPrint('Item posted successfully: ${response.body}');
      }
      return decoded is Map<String, dynamic> ? decoded : {'status': 'success'};
    }

    throw Exception('Failed to post item (${response.statusCode})');
  } catch (e) {
    throw Exception('Post item failed: $e');
  }
}

  // ---- TEMP STUBS (to keep app compiling) ----
  Future<Map<String, dynamic>> getCurrentUserProfile() async {
    final url = _uri('/me');
    
    try {
      final response = await _client.get(url);
      
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        return decoded is Map<String, dynamic>
            ? decoded
            : {'data': null, 'status_code': 200};
      }
      
      throw Exception('Failed to load profile (${response.statusCode})');
    } catch (e) {
      throw Exception('getCurrentUserProfile failed: $e');
    }
  }

  /// Get a user's profile by their UUID from backend
  Future<Map<String, dynamic>> getUserById(String userId) async {
    final url = _uri('/profile/$userId');

    try {
      final response = await _client.get(url);

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        return decoded is Map<String, dynamic>
            ? decoded
            : {'table_data': null, 'status_code': response.statusCode};
      } else if (response.statusCode == 404) {
        return {'table_data': null, 'status_code': 404};
      }

      throw Exception('Failed to load profile (${response.statusCode})');
    } catch (e) {
      throw Exception('getUserById failed: $e');
    }
  }
  /// Get user profile by ID from backend
  Future<Map<String, dynamic>> getUserByID(String userId) async {
    final url = _uri('/user/$userId');
    
    try {
      final response = await _client.get(url);
      
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        return decoded is Map<String, dynamic>
            ? decoded
            : {'data': null, 'status_code': 200};
      }
      
      throw Exception('Failed to load profile (${response.statusCode})');
    } catch (e) {
      throw Exception('getUserByID failed: $e');
    }
  }

  /// Get user listings by ID from backend
  Future<Map<String, dynamic>> getUserItems(dynamic userId) async {
    final url = _uri('/items?user_id=$userId');
    
    try {
      final response = await _client.get(url);
      
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        return decoded is Map<String, dynamic>
            ? decoded
            : {'table_data': [], 'status_code': 200};
      }
      
      throw Exception('Failed to load items (${response.statusCode})');
    } catch (e) {
      throw Exception('getUserItems failed: $e');
    }
  }

  /// Get reviews for a user by ID from backend
  Future<Map<String, dynamic>> getUserReviews(dynamic userId) async {
    final url = _uri('/reviews?user_id=$userId');
    
    try {
      final response = await _client.get(url);
      
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        return decoded is Map<String, dynamic>
            ? decoded
            : {'data': [], 'status_code': 200};
      }
      
      throw Exception('Failed to load reviews (${response.statusCode})');
    } catch (e) {
      throw Exception('getUserReviews failed: $e');
    }
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

  /// Fetch a single item by its ID from the backend and convert to `Item`.
  ///
  /// Accepts a nullable `itemId` because callers may pass null; throws if
  /// `itemId` is null or if the request/response is invalid.
  Future<Item> getItemFromID(String? itemId) async {
    if (itemId == null || itemId.isEmpty) {
      throw ArgumentError('itemId must be provided');
    }

    final url = _uri('/item/$itemId');

    try {
      final response = await _client.get(url);

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        if (decoded is Map<String, dynamic>) {
          final raw = decoded['table_data'];
          if (raw is Map<String, dynamic>) {
            return Item.fromJson(raw);
          }
          throw Exception('Unexpected item format in response');
        }

        throw Exception('Invalid response from server');
      } else if (response.statusCode == 404) {
        throw Exception('Item not found (404)');
      }

      throw Exception('Failed to load item (${response.statusCode})');
    } catch (e) {
      throw Exception('getItemFromID failed: $e');
    }
  }
}