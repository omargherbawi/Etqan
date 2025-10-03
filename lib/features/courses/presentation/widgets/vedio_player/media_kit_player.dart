// import 'package:flutter/material.dart';
// import 'package:media_kit/media_kit.dart';
// import 'package:media_kit_video/media_kit_video.dart';
//
// class MediaKitPlayerWidget extends StatefulWidget {
//   final String url;
//   final String referer;
//
//   const MediaKitPlayerWidget({
//     super.key,
//     required this.url,
//     required this.referer,
//   });
//
//   @override
//   State<MediaKitPlayerWidget> createState() => _MediaKitPlayerWidgetState();
// }
//
// class _MediaKitPlayerWidgetState extends State<MediaKitPlayerWidget> {
//   late final Player _player;
//   late final VideoController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//     _initMediaKitPlayer();
//   }
//
//   Future<void> _initMediaKitPlayer() async {
//     // await _player.stop();
//     _player = Player(
//       configuration: const PlayerConfiguration(
//         logLevel: MPVLogLevel.error,
//         // bufferSize: 32 * 1024 * 1024,
//         bufferSize: 8 * 1024 * 1024,
//         protocolWhitelist: ['http', 'https', 'tcp', 'tls'],
//       ),
//
//     );
//     _controller = VideoController(_player);
//     await _player.open(
//       Media(widget.url, httpHeaders: {"Referer": widget.referer}),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Video(controller: _controller);
//   }
//
//   @override
//   void dispose() {
//     _player.dispose();
//     super.dispose();
//   }
// }
