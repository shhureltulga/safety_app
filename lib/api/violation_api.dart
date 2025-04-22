// lib/api/violation_api.dart
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import '../config/api_config.dart';

class ViolationApi {
  final Dio _dio = Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));
  final storage = GetStorage();

  Future<List<Map<String, dynamic>>> getAll() async {
    final token = storage.read('token');

    final response = await _dio.get(
      '/violations',
      options: Options(headers: {
        'Authorization': 'Bearer $token',
      }),
    );

    return List<Map<String, dynamic>>.from(response.data);
  }
}
