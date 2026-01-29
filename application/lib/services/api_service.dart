import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';

class APIService {
  final http.Client _client;

  APIService({http.Client? client}) : _client = client ?? http.Client();

  /// Returns backend status message if reachable, throws otherwise.
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
}