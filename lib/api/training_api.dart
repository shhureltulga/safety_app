import 'package:dio/dio.dart';
import '../config/api_config.dart'; // BASE_URL here
import 'package:get_storage/get_storage.dart';

class TrainingApi {
  final Dio _dio = Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));
  final storage = GetStorage();

  // 🟢 Прогресс хадгалах
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

  // 🟡 Прогресс авах (viewedDate ашиглана)
  Future<Map<String, dynamic>?> getProgress(int instructionId) async {
    final token = storage.read('token');

    // 🔸 viewDate-г ISO хэлбэрээр бэлдэнэ (жишээ: 2025-04-21)
    final now = DateTime.now();
    final viewedDate = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    try {
      final res = await _dio.get(
        '/training-progress/$instructionId',
        queryParameters: {
          'viewedDate': viewedDate, // ✅ Query параметр болгож илгээнэ
        },
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
