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

  dynamic _decodeBody(String body) {
    if (body.trim().isEmpty) return <String, dynamic>{};
    return json.decode(body);
  }

  String _extractErrorMessage(dynamic decoded, int statusCode, String fallback) {
    if (decoded is Map<String, dynamic>) {
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
