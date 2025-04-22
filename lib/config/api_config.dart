class ApiConfig {
  static const bool isProd = true;

  static const String devUrl = 'http://192.168.1.24:3000';
  static const String prodUrl = 'http://192.168.1.24:3000';

  static String get baseUrl => isProd ? prodUrl : devUrl;
}
