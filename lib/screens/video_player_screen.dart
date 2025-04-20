import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import '../api/training_api.dart';
import '../widgets/acknowledgement_section.dart'; // showAcknowledgeModal
import '../widgets/training_test_modal.dart'; // showTrainingTestModal


class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  final int instructionId;



  const VideoPlayerScreen({
    super.key,
    required this.videoUrl,
    required this.instructionId,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoPlayerController;


bool modalShown = false;

  ChewieController? _chewieController;
  bool _loading = true;
  bool watchedFully = false;
  int lastSeconds = 0;
  Duration? lastSeekPosition;
  bool isSeekingBlocked = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    final progress = await TrainingApi().getProgress(widget.instructionId);
    lastSeconds = progress?['lastWatchedSeconds'] ?? 0;

    _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    await _videoPlayerController.initialize();

    if (lastSeconds > 0) {
     await _videoPlayerController.seekTo(Duration(seconds: lastSeconds));
    }

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: false,
      allowPlaybackSpeedChanging: false,
      allowMuting: true,
    );

  _videoPlayerController.addListener(() {
  final position = _videoPlayerController.value.position;
  final duration = _videoPlayerController.value.duration;

  if (duration == null || position == null) return;

  final remaining = duration - position;

  // ⛔ Гүйлгэхээс хамгаална
  if (lastSeekPosition != null && !isSeekingBlocked) {
    final diff = position - lastSeekPosition!;
    if (diff.inSeconds > 3) {
      final maxAllowed = Duration(seconds: position.inSeconds - 2);
      if (position > maxAllowed) {
        isSeekingBlocked = true;
        _videoPlayerController.seekTo(lastSeekPosition!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("⛔ Урагш гүйлгэх боломжгүй")),
          );
        }
        isSeekingBlocked = false;
        return;
      }
    }
  }

  // 🕓 Сүүлийн байрлалыг хадгална
  lastSeekPosition = position;

  // 📡 5 секунд тутам progress хадгалах
  if (position.inSeconds % 5 == 0 &&
      !_videoPlayerController.value.isBuffering) {
    TrainingApi().saveProgress(
      widget.instructionId,
      position.inSeconds,
      false,
    );
  }

  // ✅ Видео бүрэн үзсэн үед хадгалж, modal харуулна
if (!watchedFully && position >= duration) {
  watchedFully = true;

  TrainingApi().saveProgress(
    widget.instructionId,
    position.inSeconds,
    true,
  );

  if (!modalShown) {
    modalShown = true;
    // 🔁 ЭНЭ ХЭСГИЙГ СОЛЬ:
    // showAcknowledgeModal(context, widget.instructionId);
   // showTrainingTestModal(context, widget.instructionId); // ✅
    showTrainingTestModal(
  context,
  widget.instructionId,
  onSuccess: () {
    Navigator.pop(context, true);
  },
);

  }
}

});


    setState(() {
      _loading = false;
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('🎬 Видео үзэх'),
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black87,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: AspectRatio(
                        aspectRatio: _videoPlayerController.value.aspectRatio,
                        child: Chewie(controller: _chewieController!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "🎓 Сургалтын видеог үзэж дуусгана уу.",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
    );
  }
}
