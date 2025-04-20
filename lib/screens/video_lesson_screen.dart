import 'package:flutter/material.dart';
import '../api/instruction_api.dart';
import '../models/instruction_model.dart';
import 'video_player_screen.dart';
import 'pdf_viewer_screen.dart';

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
    final data = await _api.getForUser();
    setState(() {
      _instructions = data;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Сургалтын видео'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black87,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _instructions.length,
              itemBuilder: (context, index) {
                final instruction = _instructions[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 4),
                      )
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.play_circle_outline, color: Colors.blueAccent),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                instruction.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => VideoPlayerScreen(
                                          videoUrl: instruction.videoUrl,
                                          instructionId: instruction.id,
                                        ),
                                      ),
                                    );

                                    if (result == true) {
                                      loadInstructions(); // ✅ буцаж ирэхэд жагсаалтыг дахин ачаална
                                    }
                                  },

                              icon: const Icon(Icons.play_arrow),
                              label: const Text("Үзэх"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
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
                                label: const Text("Унших"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}