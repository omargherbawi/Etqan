import 'package:flutter/material.dart';

import '../../data/models/quiz_detail_model.dart';
import 'blank_slot.dart';

class SentenceRow extends StatelessWidget {
  final String sentenceKey;
  final SentenceDetail detail;
  final List<String?> chosen;
  final void Function(int blankIndex, String word) onDrop;
  final void Function(int blankIndex) onClear;

  const SentenceRow({
    super.key,
    required this.sentenceKey,
    required this.detail,
    required this.chosen,
    required this.onDrop,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    int blankCursor = 0;
    final List<Widget> children = [];
    for (final piece in detail.displaySentence) {
      if (piece == null) {
        final int currentIndex = blankCursor;
        children.add(
          BlankSlot(
            text: chosen[currentIndex],
            onAccept: (word) => onDrop(currentIndex, word),
            onClear: () => onClear(currentIndex),
          ),
        );
        blankCursor += 1;
      } else {
        children.add(
          Text(
            piece,
            style: const TextStyle(fontSize: 16),
          ),
        );
      }
    }

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      runSpacing: 6,
      children: children,
    );
  }
}

