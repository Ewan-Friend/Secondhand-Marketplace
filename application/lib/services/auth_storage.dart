import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AuthSession {
  final String accessToken;
  final String refreshToken;
  final DateTime? expiresAt;

  const AuthSession({
    required this.accessToken,
    required this.refreshToken,
    this.expiresAt,
  });

  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  Map<String, dynamic> toJson() => {
        'access_token': accessToken,
        'refresh_token': refreshToken,
        'expires_at': expiresAt?.toIso8601String(),
      };

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    return AuthSession(
      accessToken: (json['access_token'] ?? json['accessToken'] ?? '') as String,
      refreshToken:
          (json['refresh_token'] ?? json['refreshToken'] ?? '') as String,
      expiresAt: (() {
        final raw = json['expires_at'] ?? json['expiresAt'];
        if (raw is String && raw.isNotEmpty) {
          return DateTime.tryParse(raw);
        }
        return null;
      })(),
    );
  }
}

class AuthStorage {
  static const _sessionKey = 'auth_session';

  Future<void> saveSession(AuthSession session) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionKey, json.encode(session.toJson()));
  }

  Future<AuthSession?> readSession() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_sessionKey);
    if (raw == null || raw.isEmpty) return null;

    try {
      final decoded = json.decode(raw);
      if (decoded is Map<String, dynamic>) {
        final session = AuthSession.fromJson(decoded);
        if (session.accessToken.isEmpty) return null;
        return session;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }
}