import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart'; // baseUrl-г эндээс дуудна

/// Тухайн model-ийн fromJson функц-ийг өгч generic байдлаар ашиглана
class CrudService<T> {
  final String endpoint; // Жишээ: "users", "companies"
  final T Function(Map<String, dynamic>) fromJson;

  CrudService({required this.endpoint, required this.fromJson});

  String get fullUrl => '${ApiConfig.baseUrl}/$endpoint';

  /// GET бүх өгөгдөл татах
  Future<List<T>> getAll() async {
    final response = await http.get(Uri.parse(fullUrl));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((item) => fromJson(item)).toList();
    } else {
      throw Exception('Өгөгдөл татаж чадсангүй');
    }
  }

  /// POST шинээр бүртгэх
  Future<T> create(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse(fullUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Бүртгэхэд алдаа гарлаа');
    }
  }

  /// PUT шинэчлэх
  Future<T> update(String id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$fullUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      return fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Шинэчлэхэд алдаа гарлаа');
    }
  }

  /// DELETE устгах
  Future<void> delete(String id) async {
    final response = await http.delete(Uri.parse('$fullUrl/$id'));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Устгах үед алдаа гарлаа');
    }
  }
}
