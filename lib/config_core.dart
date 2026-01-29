class ConfigCore {
  static String _appName = 'App Common';
  static String _apiBaseUrl = 'https://api.example.com';
  static int _requestTimeout = 30; // in milliseconds
  static int _receiveTimeout = 30; // in milliseconds
  static String _xClientID = 'X-Client-ID';

  // Add other core configuration settings here
  static void init({String? appName, String? apiBaseUrl, int? requestTimeout, int? receiveTimeout, String? xClientID}) {
    ConfigCore._appName = appName ?? ConfigCore._appName;
    ConfigCore._apiBaseUrl = apiBaseUrl ?? ConfigCore._apiBaseUrl;
    ConfigCore._requestTimeout = requestTimeout ?? ConfigCore._requestTimeout;
    ConfigCore._receiveTimeout = receiveTimeout ?? ConfigCore._receiveTimeout;
    ConfigCore._xClientID = xClientID ?? ConfigCore._xClientID;
  }

  static String get appName => _appName;
  static String get apiBaseUrl => _apiBaseUrl;
  static int get requestTimeout => _requestTimeout;
  static int get receiveTimeout => _receiveTimeout;
  static String get xClientID => _xClientID;
}
