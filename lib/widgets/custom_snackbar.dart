import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSnackbar {
  static void show({
    required String title,
    required String message,
    bool isError = true,
    bool fromTop = false,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: fromTop ? SnackPosition.TOP : SnackPosition.BOTTOM,
     backgroundColor: isError
    ? Colors.red.withOpacity(0.15)
    : Colors.green.withOpacity(0.15),

      colorText: Colors.white,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
      icon: Icon(
        isError ? Icons.error_outline : Icons.check_circle_outline,
        color: Colors.white,
      ),
    );
  }
}
