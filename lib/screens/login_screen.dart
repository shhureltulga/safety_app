import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:http/http.dart' as http;

import 'home_navigation.dart';
import '../config/api_config.dart';
import '../widgets/custom_snackbar.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final box = GetStorage();

  Future<void> handleLogin(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      CustomSnackbar.show(
        title: 'Анхааруулга',
        message: 'Имэйл болон нууц үгээ бөглөнө үү',
        isError: true,
        fromTop: false,
      );
      return;
    }

    final url = Uri.parse('${ApiConfig.baseUrl}/auth/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        print('Token: $token');
        print('Response data: $data');

        await box.write('token', token);
        Get.offAll(() => const HomeNavigation());
      } else {
        CustomSnackbar.show(
          title: 'Алдаа',
          message: 'Имэйл эсвэл нууц үг буруу байна',
          isError: true,
          fromTop: false,
        );
      }
    } catch (e) {
      CustomSnackbar.show(
        title: 'Сүлжээний алдаа',
        message: e.toString(),
        isError: true,
        fromTop: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade100, Colors.blue.shade400],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
              child: FadeInUp(
                duration: const Duration(milliseconds: 800),
                child: Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 30,
                        offset: Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.security, size: 56, color: Colors.blueAccent),
                      const SizedBox(height: 16),
                      Text(
                        "Нэвтрэх",
                        style: GoogleFonts.notoSans(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Аюулгүй байдлын системд тавтай морил",
                        style: GoogleFonts.notoSans(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 28),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: "Имэйл",
                          prefixIcon: const Icon(Icons.email_outlined),
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Нууц үг",
                          prefixIcon: const Icon(Icons.lock_outline),
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      GFButton(
                        onPressed: () => handleLogin(context),
                        text: "Нэвтрэх",
                        size: GFSize.LARGE,
                        shape: GFButtonShape.pills,
                        fullWidthButton: true,
                        color: GFColors.PRIMARY,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
