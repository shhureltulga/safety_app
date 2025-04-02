import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_navigation.dart'; // 👈 нэмнэ

void main() {
  runApp(const SafetyApp());
}

class SafetyApp extends StatelessWidget {
  const SafetyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Safety App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Colors.white,
      ),
     home: LoginScreen()

    );
  }
}
