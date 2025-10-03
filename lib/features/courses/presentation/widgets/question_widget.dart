
import '../../data/models/quiz_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class QuestionWidget extends StatefulWidget {
  const QuestionWidget({
    super.key,
    required this.question,
  });

  final Question question;

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  late final WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  @override
  void didUpdateWidget(QuestionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if the question has changed
    if (oldWidget.question.title != widget.question.title) {
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
    if (widget.question.title.contains('<html') || widget.question.title.contains('<!DOCTYPE html')) {
      // If it's already a complete HTML document, enhance it with our styling
      htmlContent = _enhanceExistingHtml(widget.question.title);
    } else {
      // If it's just text, wrap it with our styling
      htmlContent = _createStyledHtml(widget.question.title);
    }

    _webViewController.loadHtmlString(htmlContent);
  }

  String _enhanceExistingHtml(String existingHtml) {
    // Add our styling to existing HTML by inserting CSS into the head
    if (existingHtml.contains('<head>')) {
      return existingHtml.replaceFirst(
        '<head>',
        '<head>\n    <meta name="viewport" content="width=device-width, initial-scale=1.0">\n    <style>\n      body {\n        margin: 0;\n        padding: 20px;\n        display: flex;\n        justify-content: center;\n        align-items: center;\n        min-height: fit-content;\n        height: auto;\n        text-align: center;\n        font-size: 24px;\n        font-weight: 600;\n        line-height: 1.4;\n        overflow: hidden;\n      }\n      html {\n        height: auto;\n        overflow: hidden;\n      }\n      math-field {\n        font-size: 24px !important;\n        font-weight: 600 !important;\n      }\n    </style>'
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
              padding: 0px;
              display: flex;
              justify-content: center;
              align-items: center;
              min-height: fit-content;
              height: auto;
              text-align: center;
              font-size: 24px;
              font-weight: 600;
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
        minHeight: 60, // Minimum height for small content
        maxHeight: 100, // Reasonable height for most questions
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: WebViewWidget(controller: _webViewController),
      ),
    );
  }
}
