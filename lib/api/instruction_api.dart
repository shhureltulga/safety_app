import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import '../models/instruction_model.dart';
import '../config/api_config.dart'; // ✅ зөв config

class InstructionApi {
  final Dio _dio = Dio(BaseOptions(baseUrl: ApiConfig.baseUrl)); // ✅ config ашиглаж байна
  final storage = GetStorage();

  Future<List<Instruction>> getForUser() async {
    final token = storage.read('token');

    final response = await _dio.get(
      '/instructions/for-user',
      options: Options(headers: {
        'Authorization': 'Bearer $token',
      }),
    );

    return (response.data as List)
        .map((json) => Instruction.fromJson(json))
        .toList();
  }
}
