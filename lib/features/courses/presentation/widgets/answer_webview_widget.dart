import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AnswerWebViewWidget extends StatefulWidget {
  final String answerText;
  final int index;

  const AnswerWebViewWidget({
    super.key,
    required this.answerText,
    required this.index,
  });

  @override
  State<AnswerWebViewWidget> createState() => _AnswerWebViewWidgetState();
}

class _AnswerWebViewWidgetState extends State<AnswerWebViewWidget> {
  late final WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  @override
  void didUpdateWidget(AnswerWebViewWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if the answer text has changed
    if (oldWidget.answerText != widget.answerText) {
      _updateWebViewContent();
    }
  }

  void _initializeWebView() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
    _updateWebViewContent();
  }

  void _updateWebViewContent() {
    // Check if the content already contains HTML structure
    String htmlContent;
    if (widget.answerText.contains('<html') || widget.answerText.contains('<!DOCTYPE html')) {
      // If it's already a complete HTML document, enhance it with our styling
      htmlContent = _enhanceExistingHtml(widget.answerText);
    } else {
      // If it's just text, wrap it with our styling
      htmlContent = _createStyledHtml(widget.answerText);
    }

    _webViewController.loadHtmlString(htmlContent);
  }

  String _enhanceExistingHtml(String existingHtml) {
    // Add our styling to existing HTML by inserting CSS into the head
    if (existingHtml.contains('<head>')) {
      return existingHtml.replaceFirst(
        '<head>',
        '<head>\n    <meta name="viewport" content="width=device-width, initial-scale=1.0">\n    <style>\n      body {\n        margin: 0;\n        padding: 16px;\n        display: flex;\n        justify-content: flex-start;\n        align-items: center;\n        min-height: fit-content;\n        height: auto;\n        text-align: left;\n        font-size: 18px;\n        font-weight: normal;\n        line-height: 1.4;\n        overflow: hidden;\n      }\n      html {\n        height: auto;\n        overflow: hidden;\n      }\n      math-field {\n        font-size: 18px !important;\n        font-weight: normal !important;\n      }\n    </style>'
      );
    }
    return existingHtml;
  }

  String _createStyledHtml(String textContent) {
    return '''
      <html>
        <head>
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <style>
            body {
              margin: 0;
              padding: 16px;
              display: flex;
              justify-content: flex-start;
              align-items: center;
              min-height: fit-content;
              height: auto;
              text-align: left;
              font-size: 18px;
              font-weight: normal;
              line-height: 1.4;
              overflow: hidden;
            }
            html {
              height: auto;
              overflow: hidden;
            }
          </style>
        </head>
        <body>
          $textContent
        </body>
      </html>
    ''';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 40, // Minimum height for small content
        maxHeight: 80, // Reasonable height for most answers
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: WebViewWidget(controller: _webViewController),
      ),
    );
  }
}
