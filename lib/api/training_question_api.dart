import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import '../models/training_question_model.dart';
import '../config/api_config.dart'; // ✅ config

class TrainingQuestionApi {
  final Dio _dio = Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));
  final storage = GetStorage();

  Future<List<TrainingQuestion>> getByInstructionId(int instructionId) async {
    final token = storage.read('token');
    final response = await _dio.get(
      '/training-questions/instruction/$instructionId',
      options: Options(headers: {
        'Authorization': 'Bearer $token',
      }),
    );

    return (response.data as List)
        .map((e) => TrainingQuestion.fromJson(e))
        .toList();
  }
}
