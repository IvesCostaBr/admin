class AppConfig {
  final String apiBaseUrl;
  final String authUrl;
  final String? websocketBaseUrl;

  AppConfig({
    required this.apiBaseUrl,
    required this.authUrl,
    this.websocketBaseUrl
  });

  static AppConfig? _instance;

  static AppConfig get instance {
    if (_instance == null) {
      throw Exception("AppConfig is not initialized");
    }
    return _instance!;
  }

  static void initialize(AppConfig config) {
    if (_instance == null) {
      _instance = config;
    } else {
      throw Exception("AppConfig is already initialized");
    }
  }
}