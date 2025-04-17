import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class NoForwardControls extends StatefulWidget {
  final VideoPlayerController controller;
  final int lastAllowedSeconds;

  const NoForwardControls({
    required this.controller,
    required this.lastAllowedSeconds,
  });

  @override
  State<NoForwardControls> createState() => _NoForwardControlsState();
}

class _NoForwardControlsState extends State<NoForwardControls> {
  late Duration maxAllowed;

  @override
  void initState() {
    super.initState();
    maxAllowed = Duration(seconds: widget.lastAllowedSeconds);
  }

  void _onSeekBarChanged(double value) {
    final newPosition = Duration(seconds: value.toInt());
    final current = widget.controller.value.position;

    if (newPosition > maxAllowed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('🚫 Урагш гүйлгэх боломжгүй')),
      );
    } else {
      widget.controller.seekTo(newPosition);
    }
  }

  @override
  Widget build(BuildContext context) {
    final position = widget.controller.value.position;
    final duration = widget.controller.value.duration;

    return Column(
      children: [
        Slider(
          value: position.inSeconds.toDouble(),
          min: 0,
          max: duration.inSeconds.toDouble(),
          onChanged: _onSeekBarChanged,
          activeColor: Colors.redAccent,
          inactiveColor: Colors.grey,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${position.inMinutes}:${(position.inSeconds % 60).toString().padLeft(2, '0')}'),
            Text('${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}'),
          ],
        ),
        IconButton(
          icon: Icon(
            widget.controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
            size: 36,
          ),
          onPressed: () {
            setState(() {
              widget.controller.value.isPlaying
                  ? widget.controller.pause()
                  : widget.controller.play();
            });
          },
        )
      ],
    );
  }
}
