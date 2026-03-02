/// Source for API base url, adds fallback as just /api
const String apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: '/api',
);
