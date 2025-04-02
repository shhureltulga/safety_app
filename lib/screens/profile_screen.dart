import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Профайл')),
      body: const Center(
        child: Text(
          'Хэрэглэгчийн мэдээлэл энд гарна.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
