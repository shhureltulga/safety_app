import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';
import '../models/training_question_model.dart';
import '../api/training_question_api.dart';
import '../config/api_config.dart'; 

class TrainingTestModal extends StatefulWidget {
  final int instructionId;
  final VoidCallback? onSuccess;

  const TrainingTestModal({
    super.key,
    required this.instructionId,
    this.onSuccess,
  });

  @override
  State<TrainingTestModal> createState() => _TrainingTestModalState();
}


class _TrainingTestModalState extends State<TrainingTestModal> {
  List<TrainingQuestion> _questions = [];
  Map<int, String> _answers = {};
  bool _loading = true;
  bool _agreed = false;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  Future<void> loadQuestions() async {
    final all = await TrainingQuestionApi().getByInstructionId(widget.instructionId);
    all.shuffle();
    setState(() {
      _questions = all.take(3).toList();
      _loading = false;
    });
  }

  bool get allAnswered => _answers.length == _questions.length;

  bool get allCorrect {
    for (var q in _questions) {
      if (_answers[q.id] != q.answer) return false;
    }
    return true;
  }

  Future<void> acknowledge(BuildContext context) async {
    final token = GetStorage().read('token');
    final url = '${ApiConfig.baseUrl}/instruction-acknowledge';

    setState(() => _submitting = true);

    try {
      final res = await Dio().post(
        url,
        data: {'instructionId': widget.instructionId},
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );


      if (res.statusCode == 201) {
        widget.onSuccess?.call(); 
        Navigator.pop(context, true); // ✅ signal to reload parent
        
        Get.snackbar('✅ Амжилттай', 'Та баталгаажууллаа');
      } else {
        Get.snackbar('⛔ Алдаа', res.data['message'] ?? 'Тайлбаргүй алдаа');
      }
    } catch (e) {
      Get.snackbar('⛔ Алдаа', 'Сервертэй холбогдож чадсангүй');
    } finally {
      setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '🧪 Тест бөглөнө үү',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    for (var q in _questions) ...[
                      Text(q.question, style: const TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 6),
                      for (var i = 0; i < q.choices.length; i++)
                        RadioListTile<String>(
                          title: Text("${String.fromCharCode(65 + i)}. ${q.choices[i]}"),
                          value: q.choices[i],
                          groupValue: _answers[q.id],
                          onChanged: (val) {
                            setState(() {
                              _answers[q.id] = val!;
                            });
                          },
                        ),
                      const Divider(),
                    ],
                    const SizedBox(height: 12),
                    if (allAnswered && allCorrect) ...[
                      CheckboxListTile(
                        title: const Text('Би зааварчилгааг ойлгож зөвшөөрсөн'),
                        value: _agreed,
                        onChanged: (val) => setState(() => _agreed = val ?? false),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _agreed && !_submitting ? () => acknowledge(context) : null,
                        child: _submitting
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Баталгаажуулах'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ] else if (allAnswered && !allCorrect) ...[
                      const Text(
                        '❌ Зарим хариулт буруу байна. Дахин оролдоно уу.',
                        style: TextStyle(color: Colors.red),
                      )
                    ]
                  ],
                ),
              ),
      ),
    );
  }
}

void showTrainingTestModal(
  BuildContext context,
  int instructionId, {
  VoidCallback? onSuccess,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.4),
    builder: (_) => TrainingTestModal(
      instructionId: instructionId,
      onSuccess: onSuccess, // ✅ амжилттай бол энэ дуудагдана
    ),
  );
}
