import 'package:flutter/material.dart';

import '../../../../core/core.dart';

class AvailableWords extends StatelessWidget {
  final List<String> words;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;

  const AvailableWords({
    super.key,
    required this.words,
    this.backgroundColor = const Color(0xFFE8F5E9),
    this.textColor = Colors.black,
    this.borderColor = const Color(0xFF2E7D32),
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final word in words)
          Draggable<String>(
            data: word,
            feedback: Material(
              color: Colors.transparent,
              child: Chip(
                backgroundColor: backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: borderColor),
                ),
                label: CustomTextWidget(text: word, color: textColor),
                elevation: 4,
              ),
            ),
            childWhenDragging: Opacity(
              opacity: 0.4,
              child: Chip(
                backgroundColor: backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: borderColor),
                ),
                label: Text(
                  word,
                  style: TextStyle(color: textColor, fontSize: 13),
                ),
              ),
            ),
            child: Chip(
              backgroundColor: backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: borderColor),
              ),
              label: Text(
                word,
                style: TextStyle(color: textColor, fontSize: 13),
              ),
            ),
          ),
      ],
    );
  }
}

