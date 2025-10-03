import '../../data/models/quiz_detail_model.dart';
import 'dynamic_answers_count.dart';
import 'multiple_choice_answer_card.dart';
import 'package:flutter/material.dart';

class AnswersList extends StatelessWidget {
  final Question question;

  const AnswersList({
    super.key,
    required this.question,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          AnswersCountIndicator(answersCount: question.answers.length),
          ...question.answers.asMap().entries.map<Widget>(
            (entry) => AnswerCard(
              question: question,
              answer: entry.value,
              index: entry.key,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}