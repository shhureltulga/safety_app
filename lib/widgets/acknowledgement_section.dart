import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

// 🧩 Баталгаажуулалтын UI
class AcknowledgementSection extends StatefulWidget {
  final int instructionId;
  final bool testPassed;

  const AcknowledgementSection({
    super.key,
    required this.instructionId,
    required this.testPassed,
  });

  @override
  State<AcknowledgementSection> createState() => _AcknowledgementSectionState();
}

class _AcknowledgementSectionState extends State<AcknowledgementSection> {
  bool agreed = false;
  bool loading = false;

  Future<void> acknowledge() async {
    final token = GetStorage().read('token');
    if (token == null) {
      Get.snackbar('⚠️ Алдаа', 'Нэвтрэх мэдээлэл олдсонгүй');
      return;
    }

    setState(() => loading = true);

    final url = Uri.parse('http://43.201.146.103:3000/instruction-acknowledge');
    final res = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'instructionId': widget.instructionId}),
    );

    setState(() => loading = false);

    if (res.statusCode == 201) {
      Get.back(); // Modal хаах
      Get.snackbar('✅ Амжилттай', 'Та баталгаажууллаа');
    } else {
      final err = jsonDecode(res.body);
      Get.snackbar('⛔ Алдаа', err['message'] ?? 'Алдаа гарлаа');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.testPassed) return const SizedBox(); // тэнцээгүй бол харуулахгүй

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          '✅ Та зааварчилгааг ойлгож зөвшөөрч байна уу?',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        CheckboxListTile(
          title: const Text('Би ойлгож зөвшөөрсөн.'),
          value: agreed,
          onChanged: (val) => setState(() => agreed = val ?? false),
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: agreed && !loading ? acknowledge : null,
          icon: const Icon(Icons.check_circle),
          label: loading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : const Text('Баталгаажуулах'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
            backgroundColor: Colors.blueAccent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }
}

// 🪟 Modal-ийг дуудах функц
void showAcknowledgeModal(BuildContext context, int instructionId) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.3), // 🟡 Бүдэг арын фон
    builder: (_) {
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 15,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: AcknowledgementSection(
              instructionId: instructionId,
              testPassed: true, // ← Та тестийн үр дүнгээс энэ утгыг өгөөрэй
            ),
          ),
        ),
      );
    },
  );
}
