import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_navigation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart'; // ⚠️ энэ заавал байх ёстой
import 'screens/splash_screen.dart';

void main() async {
  await GetStorage.init();
  runApp(const SafetyApp());
}

class SafetyApp extends StatelessWidget {
  const SafetyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp( // ✅ GetMaterialApp гэж өөрчлөнө
      title: 'Safety App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Colors.white,
      ),
      home: SplashScreen(),
    );
  }
}
