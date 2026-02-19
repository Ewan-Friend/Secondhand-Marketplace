import 'api_config.dart' as api_cfg;

/// App config. API base URL is defined in api_config.dart (single source of truth).
class AppConfig {
  /// API base URL (no trailing slash). Defaults to relative "/api" for CloudFront.
  static const String apiBaseUrl = api_cfg.apiBaseUrl;
}
