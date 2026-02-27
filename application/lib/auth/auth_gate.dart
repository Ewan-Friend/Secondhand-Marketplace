import 'package:flutter/material.dart';

import '../pages/login_page.dart';
import '../pages/profile_page.dart';
import '../services/api_service.dart';
import '../services/auth_storage.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final APIService _api = APIService();
  final AuthStorage _storage = AuthStorage();

  late final Future<bool> _boot;

  @override
  void initState() {
    super.initState();
    _boot = _bootstrap();
  }

  Future<bool> _bootstrap() async {
    final session = await _storage.readSession();
    if (session == null) return false;

    if (session.isExpired) {
      await _storage.clear();
      _api.clearSession();
      return false;
    }

    _api.setSession(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
      expiresAt: session.expiresAt,
    );

    try {
      final me = await _api.getCurrentUserProfile();
      if (me['status_code'] == 401) {
        await _storage.clear();
        _api.clearSession();
        return false;
      }
    } catch (_) {
      await _storage.clear();
      _api.clearSession();
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
   