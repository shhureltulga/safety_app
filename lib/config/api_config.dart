class ApiConfig {
  static const bool isProd = true;

  static const String devUrl = 'http://43.201.146.103:3000';
  static const String prodUrl = 'http://43.201.146.103:3000';

  static String get baseUrl => isProd ? prodUrl : devUrl;
}
