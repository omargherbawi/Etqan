import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class RawVideoPlayerWidget extends StatefulWidget {
  final String url;
  final String referer;

  const RawVideoPlayerWidget({
    super.key,
    required this.url,
    required this.referer,
  });

  @override
  State<RawVideoPlayerWidget> createState() => _RawVideoPlayerWidgetState();
}

class _RawVideoPlayerWidgetState extends State<RawVideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.url),
        httpHeaders: {"Referer": widget.referer},

      )
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        )
        : const Center(child: CircularProgressIndicator());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
