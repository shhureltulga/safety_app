import 'package:flutter/material.dart';
import '../api/instruction_api.dart';
import '../models/instruction_model.dart';
import 'video_player_screen.dart';
import 'pdf_viewer_screen.dart'; // ← дараа үүсгэнэ

class VideoLessonScreen extends StatefulWidget {
  const VideoLessonScreen({super.key});

  @override
  State<VideoLessonScreen> createState() => _VideoLessonScreenState();
}

class _VideoLessonScreenState extends State<VideoLessonScreen> {
  final InstructionApi _api = InstructionApi();
  List<Instruction> _instructions = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    loadInstructions();
  }

Future<void> loadInstructions() async {
  print("📡 Fetching instructions...");
  final data = await _api.getForUser();
  print("📥 Instructions received: ${data.length} items");

  setState(() {
    _instructions = data;
    _loading = false;
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Сургалтын видео')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _instructions.length,
              itemBuilder: (context, index) {
                final instruction = _instructions[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(instruction.title,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Row(
  mainAxisAlignment: MainAxisAlignment.end,
  children: [
    ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VideoPlayerScreen(
  videoUrl: instruction.videoUrl,
  instructionId: instruction.id, // ← заавал өгнө
),

          ),
        );
      },
      icon: const Icon(Icons.play_circle_fill),
      label: const Text("Видео үзэх"),
    ),
    const SizedBox(width: 8),
    if (instruction.pdfUrl != null)
      ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PdfViewerScreen(pdfUrl: instruction.pdfUrl!),
            ),
          );
        },
        icon: const Icon(Icons.picture_as_pdf),
        label: const Text("PDF үзэх"),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
      ),
  ],
),

                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
