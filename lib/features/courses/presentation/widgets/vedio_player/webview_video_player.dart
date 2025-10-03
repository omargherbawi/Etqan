import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HlsWebViewPlayer extends StatefulWidget {
  final String videoUrl;
  const HlsWebViewPlayer({super.key, required this.videoUrl});

  @override
  State<HlsWebViewPlayer> createState() => _HlsWebViewPlayerState();
}

class _HlsWebViewPlayerState extends State<HlsWebViewPlayer> {
  late final WebViewController _webViewController;

  @override
  void initState() {
    super.initState();

    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..loadHtmlString(_buildHlsHtml(widget.videoUrl));
  }

  String _buildHlsHtml(String videoUrl) {
    return '''
    <!DOCTYPE html>
    <html>
    <head>
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <style>
        html, body {
          margin: 0;
          padding: 0;
          background-color: black;
          height: 100%;
          overflow: hidden;
        }
        video {
          width: 100vw;
          height: 100vh;
          background-color: black;
          object-fit: contain;
        }
      </style>
      <script src="https://cdn.jsdelivr.net/npm/hls.js@latest"></script>
    </head>
    <body>
      <video id="video" controls autoplay muted playsinline></video>
      <script>
        const video = document.getElementById('video');
        const videoSrc = "$videoUrl";

        if (Hls.isSupported()) {
          const hls = new Hls();
          hls.loadSource(videoSrc);
          hls.attachMedia(video);
          hls.on(Hls.Events.MANIFEST_PARSED, function() {
            video.play();
          });
          hls.on(Hls.Events.ERROR, function(event, data) {
            console.error("HLS.js error:", data);
          });
        } else if (video.canPlayType('application/vnd.apple.mpegurl')) {
          video.src = videoSrc;
          video.addEventListener('loadedmetadata', function() {
            video.play();
          });
          video.addEventListener('error', function(e) {
            console.error("Native video element error:", e);
          });
        } else {
          console.error("HLS not supported in this environment.");
        }
      </script>
    </body>
    </html>
    ''';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(controller: _webViewController),
    );
  }
}
