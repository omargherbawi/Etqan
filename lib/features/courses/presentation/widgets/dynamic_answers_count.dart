import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class AnswersCountIndicator extends StatelessWidget {
  final int answersCount;

  const AnswersCountIndicator({
    super.key,
    required this.answersCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        'ChooseOneOfAnswers'.tr(namedArgs: {'count': answersCount.toString()}),
        style: TextStyle(
          color: Theme.of(context).textTheme.bodySmall?.color,
          fontSize: 14,
        ),
      ),
    );
  }
}
