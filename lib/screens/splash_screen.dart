import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'login_screen.dart';
import 'home_navigation.dart';

class SplashScreen extends StatelessWidget {
  final box = GetStorage();

  SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(const Duration(seconds: 2), () {
        final token = box.read('token');
        return token != null ? const HomeNavigation() : LoginScreen();
      }),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return snapshot.data as Widget;
        }
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
