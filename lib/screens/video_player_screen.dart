import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import '../api/training_api.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  final int instructionId;

  const VideoPlayerScreen({
    required this.videoUrl,
    required this.instructionId,
  });

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoPlayerController;
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

    // ⏮️ Resume from last position
    if (lastSeconds > 0) {
      _videoPlayerController.seekTo(Duration(seconds: lastSeconds));
    }

    // 🎛️ Set up chewie
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: false,
      allowPlaybackSpeedChanging: false,
      allowMuting: true,
    );

    // 🧠 Watch progress tracking
_videoPlayerController.addListener(() {
  final position = _videoPlayerController.value.position;
  final duration = _videoPlayerController.value.duration;
  final remaining = duration - position;

  // 1️⃣ Block forward seeking
  if (lastSeekPosition != null && !isSeekingBlocked) {
    final diff = position - lastSeekPosition!;
    if (diff.inSeconds > 3) {
      final maxAllowed = Duration(seconds: lastSeconds);
      if (position > maxAllowed) {
        isSeekingBlocked = true;
        _videoPlayerController.seekTo(lastSeekPosition!); // ⛔ Урагш гүйлгэхийг блоклоно
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

  lastSeekPosition = position;

  // 2️⃣ Үзсэн секундийг хадгалах (5 секунд тутамд нэг удаа)
  if (position.inSeconds % 5 == 0 && !_videoPlayerController.value.isBuffering) {
    TrainingApi().saveProgress(
      widget.instructionId,
      position.inSeconds,
      false, // 🎯 Бүрэн үзээгүй
    );
  }

  // 3️⃣ Хэрвээ бүрэн үзсэн бол watchedFully = true
  if (!watchedFully && position >= duration) {
    watchedFully = true;
    TrainingApi().saveProgress(
      widget.instructionId,
      position.inSeconds,
      true,
    );
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
      appBar: AppBar(title: Text('🎬 Видео үзэх')),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Chewie(controller: _chewieController!),
    );
  }
}
