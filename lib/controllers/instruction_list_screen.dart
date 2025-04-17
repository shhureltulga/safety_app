import 'package:flutter/material.dart';
import '../api/instruction_api.dart';
import '../models/instruction_model.dart';
import 'video_player_screen.dart'; // Видео тоглуулагч байх ёстой

class InstructionListScreen extends StatefulWidget {
  @override
  _InstructionListScreenState createState() => _InstructionListScreenState();
}

class _InstructionListScreenState extends State<InstructionListScreen> {
  final InstructionApi _api = InstructionApi();
  List<Instruction> _instructions = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final data = await _api.getForUser();
    setState(() {
      _instructions = data;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('📹 Заавар жагсаалт')),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _instructions.length,
              itemBuilder: (context, index) {
                final instruction = _instructions[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(instruction.title),
                    subtitle: Text("Видео байна"),
                    trailing: Icon(Icons.play_circle_fill),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => VideoPlayerScreen(videoUrl: instruction.videoUrl),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
