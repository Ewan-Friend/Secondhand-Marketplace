import 'api_config.dart' as api_cfg;
import 'package:flutter/foundation.dart';

/// App config. API base URL is defined in api_config.dart (single source of truth).
class AppConfig {
  /// API base URL (no trailing slash).
  ///
  /// Priority:
  /// 1) `--dart-define=API_BASE_URL=...`
  /// 2) On localhost web dev: `http://localhost:5000/api`
  /// 3) On non-web platforms: `http://localhost:5000/api`
  /// 4) Default relative `/api` for reverse-proxy/deployed web environments
  static final String apiBaseUrl = _resolveApiBaseUrl();

  static String _resolveApiBaseUrl() {
    final configured = api_cfg.apiBaseUrl.trim();
    if (configured.isNotEmpty) {
      return configured;
    }

    if (kIsWeb) {
      final host = Uri.base.host;
      if (host == 'localhost' || host == '127.0.0.1') {
        return 'http://localhost:5000/api';
      }

      return '/api';
    }

    return 'http://localhost:5000/api';
  }
}
