import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BetterPlayerWidget extends StatefulWidget {
  final String url;
  final String referer;

  const BetterPlayerWidget({
    super.key,
    required this.url,
    required this.referer,
  });

  @override
  State<BetterPlayerWidget> createState() => _BetterPlayerWidgetState();
}

class _BetterPlayerWidgetState extends State<BetterPlayerWidget> {
  BetterPlayerController? _betterPlayerController;

  @override
  void initState() {
    super.initState();
    initBetter();
  }

  Future<void> initBetter() async {
    BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      widget.url,
      headers: {"Referer": widget.referer},
      videoFormat: BetterPlayerVideoFormat.hls,
      cacheConfiguration: const BetterPlayerCacheConfiguration(useCache: false),
      bufferingConfiguration: const BetterPlayerBufferingConfiguration(
        minBufferMs: 5000,
        maxBufferMs: 10000,
        bufferForPlaybackMs: 1000,
        bufferForPlaybackAfterRebufferMs: 2000,
      ),
    );
    _betterPlayerController = BetterPlayerController(
      BetterPlayerConfiguration(
        autoPlay: true,
        allowedScreenSleep: false,
        autoDispose: true,
        aspectRatio: 16 / 9,
        deviceOrientationsAfterFullScreen: const [DeviceOrientation.portraitUp],
        playerVisibilityChangedBehavior: (visibleFraction) {
          if (visibleFraction == 0) {
            // betterPlayerController.pause();
          }
        },
      ),

      betterPlayerDataSource: betterPlayerDataSource,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: BetterPlayer(controller: _betterPlayerController!),
    );
  }

  @override
  void dispose() {
    _betterPlayerController?.dispose();
    super.dispose();
  }
}
