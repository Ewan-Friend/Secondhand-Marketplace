import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../models/item_model.dart';

class APIService {
  final http.Client _client;

  APIService({http.Client? client}) : _client = client ?? http.Client();

  Future<String> checkConnection() async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}/status');

    try {
      final response = await _client.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return (data['message'] as String?) ?? 'Backend reachable';
      }

      throw Exception('Backend unreachable (${response.statusCode})');
    } catch (e) {
      throw Exception('Network/Server error: $e');
    }
  }

  Future<List<Item>> getItems() async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}/items');

    try {
      final response = await _client.get(url);

      if (response.statusCode != 200) {
        throw Exception('Failed to load items (${response.statusCode})');
      }

      final decoded = json.decode(response.body) as Map<String, dynamic>;
      final list = (decoded['table_data'] as List<dynamic>? ) ?? [];

      return list
          .map((e) => Item.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Items fetch failed: $e');
    }
  }

    // ---------------------------------------------------------------------------
  // TEMP / STUB METHODS
  // These exist to unblock UI compilation until backend endpoints + auth exist.
  // Replace with real implementations later.
  // ---------------------------------------------------------------------------

  Future<List<Item>> getUserItems(String userId) async {
    // TODO: call GET /api/items?user_id=<userId> or a dedicated endpoint later
    return <Item>[];
  }

  Future<List<dynamic>> getUserReviews(String userId) async {
    // TODO: call GET /api/reviews?user_id=<userId> or a dedicated endpoint later
    return <dynamic>[];
  }
}