
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart' hide Trans;

import '../../../../config/asset_paths.dart';
import 'stat_column.dart';

class QuizStatsRow extends StatelessWidget {
  final String timeLeft;
  final String questionsCount;
  final String attempts;

  const QuizStatsRow({
    super.key,
    required this.timeLeft,
    required this.questionsCount,
    required this.attempts,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
      decoration: BoxDecoration(
        color:  Get.theme.cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          StatColumn(
            iconpath: AssetPaths.quiztime,
            mainText: timeLeft,
            subText: 'TimeRemaining'.tr(),
          ),
          StatColumn(
            iconpath: AssetPaths.quizquestion,
            mainText: questionsCount,
            subText: 'Questions'.tr(),
          ),
          StatColumn(
            iconpath: AssetPaths.target,
            mainText: attempts,
            subText: 'Attempts'.tr(),
          ),
        ],
      ),
    );
  }
}