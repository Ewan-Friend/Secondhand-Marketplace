/// Single source of truth for the API base URL.
/// For web development, use absolute URL to reach backend on different port.
/// For production, use relative "/api" with a reverse proxy (e.g. CloudFront).
/// Override at build time: --dart-define=API_BASE_URL=https://other.example/api
const String apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://localhost:5000/api',
);
