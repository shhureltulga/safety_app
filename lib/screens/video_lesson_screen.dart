import 'package:flutter/material.dart';

class VideoLessonScreen extends StatelessWidget {
  const VideoLessonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Сургалтын видео')),
      body: const Center(
        child: Text(
          'Сургалтын видео жагсаалт энд гарна.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
