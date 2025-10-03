import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class ChewiePlayerWidget extends StatefulWidget {
  final String url;
  final String referer;

  const ChewiePlayerWidget({
    super.key,
    required this.url,
    required this.referer,
  });

  @override
  State<ChewiePlayerWidget> createState() => _ChewiePlayerWidgetState();
}

class _ChewiePlayerWidgetState extends State<ChewiePlayerWidget> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    initChewie();
  }

  Future<void> initChewie() async {
    await _videoController?.dispose();
    _chewieController?.dispose();
    _videoController = VideoPlayerController.networkUrl(
        Uri.parse(widget.url),
        httpHeaders: {"Referer": widget.referer},
      )
      ..initialize().then((_) {
        setState(() {
          _chewieController = ChewieController(
            videoPlayerController: _videoController!,
            autoPlay: true,
            looping: false,
            allowedScreenSleep: false,
            deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],

          );
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return _chewieController != null
        ? Chewie(controller: _chewieController!)
        : const Center(child: CircularProgressIndicator());
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }
}
