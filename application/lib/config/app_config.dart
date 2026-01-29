class AppConfig {
  // Local backend (Flask) for dev
  static const String apiBaseUrl = 'http://localhost:5000/api';

  // Later (AWS) you can switch to:
  // static const String apiBaseUrl = 'https://<your-eb-url>/api';
}