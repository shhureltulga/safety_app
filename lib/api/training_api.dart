import 'package:dio/dio.dart';
import '../config/api_config.dart'; // BASE_URL here
import 'package:get_storage/get_storage.dart';

class TrainingApi {
  final Dio _dio = Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));
  final storage = GetStorage();

  Future<void> saveProgress(int instructionId, int seconds, bool watchedFully) async {
    final token = storage.read('token');
    try {
      await _dio.patch(
        '/training-progress/$instructionId',
        data: {
          'seconds': seconds,
          'watchedFully': watchedFully,
        },
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
    } catch (e) {
      print('❌ Error saving progress: $e');
    }
  }

  Future<Map<String, dynamic>?> getProgress(int instructionId) async {
    final token = storage.read('token');
    try {
      final res = await _dio.get(
        '/training-progress/$instructionId',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
      return res.data;
    } catch (e) {
      print('⚠️ No previous progress: $e');
      return null;
    }
  }
}
