class AppConfig {
  /// API base URL (no trailing slash). Defaults to local backend for dev.
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:5000/api',
  );
}