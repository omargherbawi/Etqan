import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/models/quiz_result_model.dart';

class QuizResultScreen extends StatelessWidget {
  final QuizResultResponse quizResult;

  const QuizResultScreen({super.key, required this.quizResult});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'quizResult'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),

            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: _getStatusColor().withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(_getStatusIcon(), size: 60, color: _getStatusColor()),
            ),

            const SizedBox(height: 24),

            const CustomTextWidget(
              text: 'YourQuizSubmitted',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            if (quizResult.data.isWaiting) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.hourglass_empty,
                      size: 48,
                      color: Colors.orange.shade600,
                    ),
                    const SizedBox(height: 16),
                    const CustomTextWidget(
                      text: 'waiting',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const CustomTextWidget(
                      text: 'The exam is reviewed',
                      fontSize: 14,
                      textAlign: TextAlign.center,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ] else if (quizResult.data.hasResult ||
                quizResult.data.userGrade != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Get.theme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                    const CustomTextWidget(
                      text: 'result',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 12),
                    buildResultWidget(),
                  ],
                ),
              ),
            ] else ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const CustomTextWidget(
                  text: 'noResultAvailable',
                  textAlign: TextAlign.center,
                  color: Colors.grey,
                ),
              ),
            ],

            const Spacer(),

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade200,
                        foregroundColor: Colors.grey.shade700,
                      ),
                      child: const CustomTextWidget(
                        text: 'close',
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget buildResultWidget() {
    // Priority: userGrade > result (for backward compatibility)
    if (quizResult.data.userGrade != null) {
      return _buildGradeResult();
    } else if (quizResult.data.isNumber) {
      final score = quizResult.data.resultAsNumber!;
      return Column(
        children: [
          Text(
            score.toString(),
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          if (score >= 0 && score <= 100) ...[
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: score / 100,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(
                getScoreColor(score.toDouble()),
              ),
            ),
            const SizedBox(height: 4),
            const Text('%', style: TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ],
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: CustomTextWidget(
          text: quizResult.data.resultAsString,
          textAlign: TextAlign.center,
          fontSize: 16,
          isLocalize: false, // Don't localize the actual result data
        ),
      );
    }
  }

  Widget _buildGradeResult() {
    final userGrade = quizResult.data.userGrade ?? 0;
    final passMark = quizResult.data.passMark ?? 0;
    final totalMark =
        passMark > 0
            ? passMark
            : userGrade; // Fallback to userGrade if no passMark

    return Column(
      children: [
        // Grade display
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              userGrade.toString(),
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: _getStatusColor(),
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '/ $totalMark',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Progress bar
        LinearProgressIndicator(
          value: totalMark > 0 ? userGrade / totalMark : 0,
          backgroundColor: Colors.grey.shade300,
          valueColor: AlwaysStoppedAnimation<Color>(_getStatusColor()),
        ),

        const SizedBox(height: 8),

        // Status text
        CustomTextWidget(
          text: quizResult.data.isFailed ? 'failed' : 'passed',
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: _getStatusColor(),
        ),

        // Pass mark info
        if (passMark > 0) ...[
          const SizedBox(height: 4),
          CustomTextWidget(
            text: 'passMark: $passMark',
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ],
      ],
    );
  }

  Color getScoreColor(double score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  Color _getStatusColor() {
    if (quizResult.data.isWaiting) {
      return Colors.orange;
    } else if (quizResult.data.isFailed) {
      return Colors.red;
    } else if (quizResult.data.isPassed) {
      return Colors.green;
    }
    // Default to success/failure based on overall success
    return quizResult.success ? Colors.green : Colors.red;
  }

  IconData _getStatusIcon() {
    if (quizResult.data.isWaiting) {
      return Icons.hourglass_empty;
    } else if (quizResult.data.isFailed) {
      return Icons.close;
    } else if (quizResult.data.isPassed) {
      return Icons.check_circle;
    }
    // Default to success/failure based on overall success
    return quizResult.success ? Icons.check_circle : Icons.close;
  }
}
