import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

import 'vedio_player/better_player_widget.dart';
import 'vedio_player/chewi_player_widget.dart';
import 'vedio_player/raw_vedio_player.dart';
import 'vedio_player/webview_video_player.dart';

enum PlayerType { chewie, betterPlayer, videoPlayer, webview }

class HlsVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final String videoIframe;
  final String referer;

  const HlsVideoPlayer({
    super.key,
    required this.videoUrl,
    required this.videoIframe,
    this.referer = "https://etqan.com",
  });

  @override
  State<HlsVideoPlayer> createState() => _HlsVideoPlayerState();
}

class _HlsVideoPlayerState extends State<HlsVideoPlayer> {
  PlayerType _selectedPlayer = PlayerType.chewie;

  bool _isHuawei = false;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    _isHuawei = androidInfo.manufacturer.toLowerCase().contains('huawei');

    if (_isHuawei) {
      setState(() {
        _selectedPlayer = PlayerType.betterPlayer;
      });
    } else {
      setState(() {
        _selectedPlayer = PlayerType.betterPlayer;
      });
    }
  }

  @override
  void didUpdateWidget(covariant HlsVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      _initPlayer();
    }
  }

  @override
  void dispose() {
    try {} catch (e) {
      debugPrint("Dispose error: $e");
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!Platform.isAndroid) {
      return Theme(
        data: ThemeData.dark(),
        child: ChewiePlayerWidget(
          url: widget.videoUrl,
          referer: widget.referer,
        ),
      );
    } else {
      return Theme(
        data: ThemeData.dark(),
        child: Stack(
          children: [
            _buildPlayer(_selectedPlayer),
            Positioned(
              top: 0,
              left: 5,

              child: PopupMenuButton<PlayerType>(
                iconColor: Colors.green,
                color: Colors.white,
                initialValue: _selectedPlayer,
                onSelected: (value) {
                  setState(() => _selectedPlayer = value);
                },
                itemBuilder:
                    (context) => [
                      PopupMenuItem(
                        value: PlayerType.chewie,
                        child: Text(
                          "Player 1",
                          style: TextStyle(
                            color:
                                _selectedPlayer == PlayerType.chewie
                                    ? Colors.green
                                    : Colors.black,
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        value: PlayerType.betterPlayer,
                        child: Text(
                          "Player 2",
                          style: TextStyle(
                            color:
                                _selectedPlayer == PlayerType.betterPlayer
                                    ? Colors.green
                                    : Colors.black,
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        value: PlayerType.videoPlayer,
                        child: Text(
                          "Player 3",
                          style: TextStyle(
                            color:
                                _selectedPlayer == PlayerType.videoPlayer
                                    ? Colors.green
                                    : Colors.black,
                          ),
                        ),
                      ),
                      // PopupMenuItem(
                      //   value: PlayerType.mediaKit,
                      //   child: Text(
                      //     "Player 4",
                      //     style: TextStyle(
                      //       color:
                      //           _selectedPlayer == PlayerType.mediaKit
                      //               ? Colors.green
                      //               : Colors.black,
                      //     ),
                      //   ),
                      // ),

                      // PopupMenuItem(
                      //   value: PlayerType.webview,
                      //   child: Text("Web Player"),
                      // ),
                    ],
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildPlayer(PlayerType type) {
    switch (type) {
      case PlayerType.chewie:
        return ChewiePlayerWidget(
          url: widget.videoUrl,
          referer: widget.referer,
        );
      case PlayerType.videoPlayer:
        return RawVideoPlayerWidget(
          url: widget.videoUrl,
          referer: widget.referer,
        );
      // case PlayerType.mediaKit:
      //   return MediaKitPlayerWidget(
      //     url: widget.videoUrl,
      //     referer: widget.referer,
      //   );

      case PlayerType.webview:
        return HlsWebViewPlayer(videoUrl: widget.videoUrl);
      case PlayerType.betterPlayer:
        return BetterPlayerWidget(
          url: widget.videoUrl,
          referer: widget.referer,
        );
    }
  }
}
