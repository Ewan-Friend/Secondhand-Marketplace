/// Single source of truth for the API base URL.
/// Use relative "/api" so the same origin (e.g. CloudFront) can route /api/* to the backend.
/// Override at build time: --dart-define=API_BASE_URL=https://other.example/api
const String apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: '/api',
);
