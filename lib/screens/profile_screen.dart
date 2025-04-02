import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'login_screen.dart';
import '../widgets/custom_snackbar.dart'; // Snackbar-д зориулсан import

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void handleLogout() async {
    final box = GetStorage();
    await box.remove('token');

  
  CustomSnackbar.show(
        title: 'Гарлаа',
        message: 'Амжилттай гарлаа',
        isError: true,
        fromTop: false,
      );
    Get.offAll(() => LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профайл'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Гарах',
            onPressed: handleLogout,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Хэрэглэгчийн мэдээлэл энд гарна.',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: handleLogout,
              icon: const Icon(Icons.logout),
              label: const Text('Гарах'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
