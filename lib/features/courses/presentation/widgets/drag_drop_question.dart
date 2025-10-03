import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/core.dart';
import '../../data/models/quiz_detail_model.dart';
import '../controllers/course_detail_controller.dart';
import 'available_words.dart';
import 'sentence_row.dart';

class DragDropQuestionWidget extends StatefulWidget {
  final Question question;

  const DragDropQuestionWidget({super.key, required this.question});

  @override
  State<DragDropQuestionWidget> createState() => DragDropQuestionWidgetState();
}

class DragDropQuestionWidgetState extends State<DragDropQuestionWidget> {
  late final CourseDetailController controller;

  late List<String> availableWords;

  final Map<String, List<String?>> chosenBySentence = {};

  bool initialized = false;

  @override
  void initState() {
    super.initState();
    controller = Get.find<CourseDetailController>();
    availableWords = widget.question.answers.map((a) => a.title).toList();
    bootstrapFromQuestionAndSavedAnswer();
  }

  void bootstrapFromQuestionAndSavedAnswer() {
    final sentences = widget.question.sentences?.sentenceMap ?? {};
    final orderedKeys = sentences.keys.toList()
      ..sort((a, b) => int.tryParse(a)?.compareTo(int.tryParse(b) ?? 0) ?? 0);

    for (final key in orderedKeys) {
      final details = sentences[key]!;
      final blanksCount = details.displaySentence.where((e) => e == null).length;
      chosenBySentence[key] = List<String?>.filled(blanksCount, null, growable: false);
    }

    final saved = controller.getSelectedAnswer(widget.question.id);
    if (saved is Map) {
      for (final entry in saved.entries) {
        final sentKey = entry.key.toString();
        final composed = entry.value?.toString() ?? '';
        if (chosenBySentence.containsKey(sentKey)) {
          final words = extractBracketedWords(composed);
          final list = chosenBySentence[sentKey]!;
          for (int i = 0; i < list.length && i < words.length; i++) {
            list[i] = words[i];
            final idx = availableWords.indexOf(words[i]);
            if (idx != -1) availableWords.removeAt(idx);
          }
        }
      }
    }

    initialized = true;
    notifyController();
  }

  List<String> extractBracketedWords(String text) {
    final regex = RegExp(r"\[(.*?)\]");
    return regex
        .allMatches(text)
        .map((m) => m.group(1) ?? '')
        .where((w) => w.isNotEmpty)
        .toList();
  }

  void onDrop(String sentenceKey, int blankIndex, String word) {
    final current = chosenBySentence[sentenceKey]![blankIndex];
    setState(() {
      if (current != null) {
        availableWords.add(current);
      }
      chosenBySentence[sentenceKey]![blankIndex] = word;
      final idx = availableWords.indexOf(word);
      if (idx != -1) availableWords.removeAt(idx);
    });
    notifyController();
  }

  void clearSlot(String sentenceKey, int blankIndex) {
    final current = chosenBySentence[sentenceKey]![blankIndex];
    if (current == null) return;
    setState(() {
      availableWords.add(current);
      chosenBySentence[sentenceKey]![blankIndex] = null;
    });
    notifyController();
  }

  Map<String, String> composeUserAnswer() {
    final sentences = widget.question.sentences?.sentenceMap ?? {};
    final result = <String, String>{};
    for (final entry in sentences.entries) {
      final key = entry.key;
      final detail = entry.value;
      int blankCursor = 0;
      final buffer = StringBuffer();
      for (final piece in detail.displaySentence) {
        if (piece == null) {
          final chosen = chosenBySentence[key]?[blankCursor];
          if (chosen != null && chosen.isNotEmpty) {
            buffer.write(' [');
            buffer.write(chosen);
            buffer.write(']');
          }
          blankCursor += 1;
        } else {
          if (buffer.isNotEmpty) buffer.write(' ');
          buffer.write(piece);
        }
      }
      result[key] = buffer.toString().trim();
    }
    return result;
  }

  void notifyController() {
    if (!initialized) return;
    controller.selectAnswer(widget.question.id, composeUserAnswer());
  }

  @override
  Widget build(BuildContext context) {
    final sentences = widget.question.sentences?.sentenceMap ?? {};
    final orderedKeys = sentences.keys.toList()
      ..sort((a, b) => int.tryParse(a)?.compareTo(int.tryParse(b) ?? 0) ?? 0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CustomTextWidget(
                  text: "PutTheAppropriateWordInTheBlank",
                ),
                const SizedBox(height: 16),
                for (final key in orderedKeys) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Get.theme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE0E0E0)),
                    ),
                    child: SentenceRow(
                      sentenceKey: key,
                      detail: sentences[key]!,
                      chosen: chosenBySentence[key]!,
                      onDrop: (blankIndex, word) => onDrop(key, blankIndex, word),
                      onClear: (blankIndex) => clearSlot(key, blankIndex),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                const SizedBox(height: 8),
                const Divider(color: Color.fromARGB(255, 198, 198, 198)),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Get.theme.cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE6F4EA)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomTextWidget(
                        text: 'AvailableWords',
                      ),
                      const SizedBox(height: 8),
                      AvailableWords(
                        borderColor: Colors.grey,
                        backgroundColor: Get.theme.cardColor,
                        words: availableWords,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

