import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../models/item_model.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class APIService {
  final http.Client _client;

  static bool _firstRequestLogged = false;

  String? accessToken;
  String? refreshToken;
  DateTime? expiresAt;

  APIService({http.Client? client}) : _client = client ?? http.Client();

  Uri _uri(String path) {
    final base = AppConfig.apiBaseUrl.trim();
    final normalizedBase =
        base.endsWith('/') ? base.substring(0, base.length - 1) : base;
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    final url = '$normalizedBase$normalizedPath';

    if (kDebugMode && !_firstRequestLogged) {
      _firstRequestLogged = true;
      debugPrint('Requesting: $url');
    }

    return Uri.parse(url);
  }

  Map<String, String> _headers({bool jsonBody = false}) {
    final headers = <String, String>{
      'Accept': 'application/json',
    };

    if (jsonBody) {
      headers['Content-Type'] = 'application/json';
    }

    if (accessToken != null && accessToken!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $accessToken';
    }

    return headers;
  }

  Future<http.Response> _get(Uri url) {
    if (accessToken != null && accessToken!.isNotEmpty) {
      return _client.get(url, headers: _headers());
    }
    return _client.get(url);
  }

  dynamic _decodeBody(String body) {
    final trimmed = body.trim();
    if (trimmed.isEmpty) return <String, dynamic>{};

    try {
      return json.decode(trimmed);
    } on FormatException {
      final preview = trimmed.length > 120
          ? '${trimmed.substring(0, 120)}...'
          : trimmed;
      final looksLikeHtml =
          trimmed.startsWith('<!DOCTYPE') || trimmed.startsWith('<html');

      if (looksLikeHtml) {
        throw const ApiException(
          'Server returned HTML instead of JSON. Check API_BASE_URL or local proxy configuration.',
        );
      }

      throw ApiException('Invalid JSON response: $preview');
    }
  }

  String _extractErrorMessage(dynamic decoded, int statusCode, String fallback) {
    if (decoded is Map) {
      final message = decoded['message'] ??
          decoded['error'] ??
          decoded['detail'] ??
          decoded['msg'];

      if (message is String && message.trim().isNotEmpty) {
        return message;
      }
    }
    return '$fallback ($statusCode)';
  }

  DateTime? _parseExpiresAt(dynamic decoded) {
    if (decoded is! Map) return null;

    final direct = decoded['expires_at'] ?? decoded['expiresAt'];
    if (direct is String && direct.isNotEmpty) {
      return DateTime.tryParse(direct);
    }

    final expiresIn = decoded['expires_in'] ?? decoded['expiresIn'];
    if (expiresIn is int) {
      return DateTime.now().add(Duration(seconds: expiresIn));
    }
    if (expiresIn is String) {
      final seconds = int.tryParse(expiresIn);
      if (seconds != null) {
        return DateTime.now().add(Duration(seconds: seconds));
      }
    }

    return null;
  }

  void setSession({
    required String accessToken,
    String? refreshToken,
    DateTime? expiresAt,
  }) {
    this.accessToken = accessToken;
    this.refreshToken = refreshToken;
    this.expiresAt = expiresAt;
  }

  void clearSession() {
    accessToken = null;
    refreshToken = null;
    expiresAt = null;
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final url = _uri('/auth/login');

    try {
      final response = await _client.post(
        url,
        headers: _headers(jsonBody: true),
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      final decoded = _decodeBody(response.body);

      if (response.statusCode != 200) {
        throw ApiException(
          _extractErrorMessage(decoded, response.statusCode, 'Login failed'),
          statusCode: response.statusCode,
        );
      }

      if (decoded is! Map) {
        throw const ApiException('Invalid login response');
      }

      final payload = decoded['data'] is Map
          ? Map<String, dynamic>.from(decoded['data'] as Map)
          : Map<String, dynamic>.from(decoded);

      final token =
          payload['access_token'] ?? payload['accessToken'] ?? payload['token'];
      final refresh =
          payload['refresh_token'] ?? payload['refreshToken'] ?? '';
      final parsedExpiresAt = _parseExpiresAt(payload);

      if (token is! String || token.isEmpty) {
        throw const ApiException('Missing access token in login response');
      }

      setSession(
        accessToken: token,
        refreshToken: refresh is String ? refresh : null,
        expiresAt: parsedExpiresAt,
      );

      return payload;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Login failed: $e');
    }
  }

  Future<String> checkConnection() async {
    final url = _uri('/status');

    try {
      final response = await _client.get(url);

      if (response.statusCode == 200) {
        final decoded = _decodeBody(response.body);
        if (decoded is Map) {
          final msg = decoded['message'];
          return (msg is String && msg.isNotEmpty) ? msg : 'Backend reachable';
        }
        return 'Backend reachable';
      }

      throw ApiException(
        'Backend unreachable (${response.statusCode})',
        statusCode: response.statusCode,
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network/Server error: $e');
    }
  }

  Future<List<Item>> getItems() async {
    final url = _uri('/items');

    try {
      final response = await _get(url);

      if (response.statusCode != 200) {
        throw ApiException(
          'Failed to load items (${response.statusCode})',
          statusCode: response.statusCode,
        );
      }

      final decoded = _decodeBody(response.body);

      if (decoded is! Map) {
        return <Item>[];
      }

      final raw = decoded['table_data'];
      if (raw is! List) {
        return <Item>[];
      }

      return raw
          .where((e) => e is Map)
          .map((e) => Item.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Items fetch failed: $e');
    }
  }

  Future<Map<String, dynamic>> postNewItem(Map<String, dynamic> data) async {
    final url = _uri('/items');

    try {
      final response = await _client.post(
        url,
        headers: _headers(jsonBody: true),
        body: json.encode(data),
      );

      final decoded = _decodeBody(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        if (kDebugMode) {
          debugPrint('Item posted successfully: ${response.body}');
        }
        return decoded is Map
            ? Map<String, dynamic>.from(decoded)
            : {'status': 'success'};
      }

      throw ApiException(
        _extractErrorMessage(decoded, response.statusCode, 'Failed to post item'),
        statusCode: response.statusCode,
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Post item failed: $e');
    }
  }

  Future<Map<String, dynamic>> getCurrentUserProfile() async {
    final url = _uri('/me');

    try {
      final response = await _get(url);
      final decoded = _decodeBody(response.body);

      if (response.statusCode == 200) {
        return decoded is Map
            ? Map<String, dynamic>.from(decoded)
            : {'data': null, 'status_code': 200};
      }

      if (response.statusCode == 401) {
        return {'data': null, 'status_code': 401};
      }

      throw ApiException(
        _extractErrorMessage(
          decoded,
          response.statusCode,
          'Failed to load profile',
        ),
        statusCode: response.statusCode,
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('getCurrentUserProfile failed: $e');
    }
  }

  Future<Map<String, dynamic>> getUserById(String userId) async {
    final url = _uri('/profile/$userId');

    try {
      final response = await _get(url);
      final decoded = _decodeBody(response.body);

      if (response.statusCode == 200) {
        return decoded is Map
            ? Map<String, dynamic>.from(decoded)
            : {'table_data': null, 'status_code': 200};
      }

      if (response.statusCode == 404) {
        return {'table_data': null, 'status_code': 404};
      }

      throw ApiException(
        _extractErrorMessage(
          decoded,
          response.statusCode,
          'Failed to load profile',
        ),
        statusCode: response.statusCode,
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('getUserById failed: $e');
    }
  }

  Future<Map<String, dynamic>> getUserByID(String userId) async {
    return getUserById(userId);
  }

  Future<Map<String, dynamic>> getUserItems(dynamic userId) async {
    final url = _uri('/items?user_id=$userId');

    try {
      final response = await _get(url);
      final decoded = _decodeBody(response.body);

      if (response.statusCode == 200) {
        return decoded is Map
            ? Map<String, dynamic>.from(decoded)
            : {'table_data': [], 'status_code': 200};
      }

      throw ApiException(
        _extractErrorMessage(decoded, response.statusCode, 'Failed to load items'),
        statusCode: response.statusCode,
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('getUserItems failed: $e');
    }
  }

  Future<Map<String, dynamic>> getUserReviews(dynamic userId) async {
    final url = _uri('/reviews?user_id=$userId');

    try {
      final response = await _get(url);
      final decoded = _decodeBody(response.body);

      if (response.statusCode == 200) {
        return decoded is Map
            ? Map<String, dynamic>.from(decoded)
            : {'data': [], 'status_code': 200};
      }

      throw ApiException(
        _extractErrorMessage(
          decoded,
          response.statusCode,
          'Failed to load reviews',
        ),
        statusCode: response.statusCode,
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('getUserReviews failed: $e');
    }
  }

  Future<Map<String, dynamic>> updateUserProfile({
    String? displayName,
    String? location,
  }) async {
    final url = _uri('/profile');

    try {
      final response = await _client.put(
        url,
        headers: _headers(jsonBody: true),
        body: json.encode({
          if (displayName != null) 'display_name': displayName,
          if (location != null) 'location': location,
        }),
      );

      final decoded = _decodeBody(response.body);

      if (response.statusCode == 200) {
        return decoded is Map
            ? Map<String, dynamic>.from(decoded)
            : {'message': 'Profile updated', 'status_code': 200};
      }

      throw ApiException(
        _extractErrorMessage(
          decoded,
          response.statusCode,
          'Profile update failed',
        ),
        statusCode: response.statusCode,
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('updateUserProfile failed: $e');
    }
  }

  void dispose() {
    _client.close();
  }

  Future<Item> getItemFromID(String? itemId) async {
    if (itemId == null || itemId.isEmpty) {
      throw ArgumentError('itemId must be provided');
    }

    final url = _uri('/item/$itemId');

    try {
      final response = await _get(url);

      if (response.statusCode == 200) {
        final decoded = _decodeBody(response.body);

        if (decoded is Map) {
          final raw = decoded['table_data'];
          if (raw is Map) {
            return Item.fromJson(Map<String, dynamic>.from(raw));
          }
          throw const ApiException('Unexpected item format in response');
        }

        throw const ApiException('Invalid response from server');
      }

      if (response.statusCode == 404) {
        throw const ApiException('Item not found (404)', statusCode: 404);
      }

      throw ApiException(
        'Failed to load item (${response.statusCode})',
        statusCode: response.statusCode,
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('getItemFromID failed: $e');
    }
  }

  // API for fetching level configurations
  Future<List<Map<String, dynamic>>> getLevelConfiguration() async {
    final url = _uri('/levels');

  try {
    final response = await _get(url);

    if (response.statusCode != 200) {
      throw ApiException(
        'Failed to load level config (${response.statusCode})',
        statusCode: response.statusCode,
      );
    }

      final decoded = _decodeBody(response.body);
      final levels = decoded['data'];
      if (levels is! List) {
        return <Map<String, dynamic>>[];
      }
      return levels
          .where((e) => e is Map)
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Level config fetch failed: $e');
    }
  }
  
  /// Adds XP to the current user
  Future<Map<String, dynamic>> addXP(int xp, int level) async {
    final url = _uri('/me/xp'); // PATCH endpoint for current user
    try {
      final response = await _client.patch(
        url,
        headers: _headers(jsonBody: true),
        body: json.encode({'xp': xp, 'level': level}),
      );
      final decoded = _decodeBody(response.body);
      if (response.statusCode == 200) {
        return decoded is Map
            ? Map<String, dynamic>.from(decoded)
            : {'message': 'XP updated', 'status_code': 200};
      }
      throw ApiException(
        _extractErrorMessage(
          decoded,
          response.statusCode,
          'XP update failed',
        ),
        statusCode: response.statusCode,
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('addXP failed: $e');
    }
  }
}
