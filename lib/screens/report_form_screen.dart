import 'package:flutter/material.dart';

class ReportFormScreen extends StatelessWidget {
  const ReportFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Зөрчлийн тайлан илгээх')),
      body: const Center(
        child: Text(
          'Зөрчлийн мэдээг энд илгээнэ.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
