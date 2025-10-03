import '../../../../core/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerScreen extends StatefulWidget {
  final String title;
  final String pdfUrl;

  const PdfViewerScreen({super.key, required this.title, required this.pdfUrl});

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  @override
  Widget build(BuildContext context) {
    final encodedUrl = Uri.encodeFull(widget.pdfUrl);

    return Scaffold(
      appBar: CustomAppBar(title: widget.title),

      body: SfPdfViewer.network(encodedUrl),
    );
  }
}
