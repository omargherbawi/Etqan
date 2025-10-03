import '../../../../core/utils/helper_functions.dart';
import '../../../../core/widgets/widgets.dart';
import '../controllers/course_detail_controller.dart';
import '../widgets/descriptive_question.dart';
import '../widgets/drag_drop_question.dart';
import '../widgets/multiple_choice_question_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import '../widgets/quiz_actions.dart';
import '../widgets/stats_row.dart';
import 'quiz_result_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late final CourseDetailController controller;
  Timer? timer;
  Timer? shakeTimer;
  bool timerStarted = false;
  bool timeHandled = false;
  int remainingSeconds = 0;

  @override
  void initState() {
    super.initState();
    controller = Get.find<CourseDetailController>();
    // Reset quiz state when entering the quiz screen
    controller.resetQuizState();
  }

  @override
  void dispose() {
    timer?.cancel();
    stopShake();
    super.dispose();
  }

  void startTimerIfNeeded(int totalSeconds) {
    if (timerStarted) return;
    timerStarted = true;
    remainingSeconds = totalSeconds;
    if (remainingSeconds <= 0) {
      onTimeUp();
      return;
    }
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() {
        remainingSeconds = remainingSeconds - 1;
      });
      if (remainingSeconds <= 0) {
        t.cancel();
        onTimeUp();
      }
    });
  }

  void onTimeUp() {
    if (timeHandled) return;
    timeHandled = true;
    timer?.cancel();
    startShake();
    HelperFunctions.showBlurredDialog(
      context: context,
      message: 'TimeIsUp',
      confirmText: 'Exit',
      barrierDismissible: false,
      onConfirm: () async {
        stopShake();
        final result = await controller.submitQuiz();
        if (mounted) {
          if (result != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => QuizResultScreen(quizResult: result),
              ),
            );
          } else {
            Navigator.pop(context);
          }
        }
      },
    );
  }

  void startShake() {
    shakeTimer?.cancel();
    shakeTimer = Timer.periodic(const Duration(milliseconds: 300), (_) async {
      try {
        // Multiple haptic feedback patterns for stronger alarm effect
        await HapticFeedback.heavyImpact();
        await Future.delayed(const Duration(milliseconds: 50));
        await HapticFeedback.mediumImpact();
        await Future.delayed(const Duration(milliseconds: 50));
        await HapticFeedback.heavyImpact();
        await Future.delayed(const Duration(milliseconds: 50));
        await HapticFeedback.selectionClick();
      } catch (_) {
        // Fallback to multiple vibrate patterns
        await HapticFeedback.vibrate();
        await Future.delayed(const Duration(milliseconds: 100));
        await HapticFeedback.vibrate();
      }
    });
  }

  void stopShake() {
    shakeTimer?.cancel();
    shakeTimer = null;
  }

  String formatTime(int totalSeconds) {
    if (totalSeconds < 0) totalSeconds = 0;
    final d = Duration(seconds: totalSeconds);
    String two(int n) => n.toString().padLeft(2, '0');
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);
    if (hours > 0) {
      return '${two(hours)}:${two(minutes)}:${two(seconds)}';
    } else {
      return '${two(minutes)}:${two(seconds)}';
    }
  }

  void endQuiz() {
    HelperFunctions.showCustomModalBottomSheet(
      context: context,
      child: CustomModalBottomSheet(
        title: "EndQuiz",
        description: "areYouSureEndQuiz",
        confirmButtonText: "yes",
        cancelButtonText: "cancel",
        onConfirm: () async {
          Get.back();

          final result = await controller.submitQuiz();

          if (result != null && mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => QuizResultScreen(quizResult: result),
              ),
            );
          } else {
            // If submission failed, just close the quiz
            Navigator.pop(context);
          }
        },
        onCancel: () {
          Get.back();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onBack: endQuiz,
        title: controller.quizDetailData.value?.quiz.title ?? '',
      ),

      body: Obx(() {
        final quizDetailData = controller.quizDetailData.value;
        if (quizDetailData == null) {
          return const Center(child: CircularProgressIndicator());
        }
        final questions = quizDetailData.quiz.questions;
        if (questions.isEmpty) {
          return const Center(child: Text('No questions available'));
        }
        final totalSeconds = (quizDetailData.quiz.time) * 60;
        startTimerIfNeeded(totalSeconds);
        final idx = controller.currentQuestionIndex.value;
        final question = questions[idx];
        return Column(
          children: [
            QuizStatsRow(
              timeLeft: formatTime(remainingSeconds),
              questionsCount: '${idx + 1}/${questions.length}',
              attempts: quizDetailData.quiz.attemptState ?? "",
            ),
            Expanded(
              child: SingleChildScrollView(
                child: buildQuestionWidget(question),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: QuizActions(
                idx: idx,
                questions: questions,
                controller: controller,
                onSubmit: endQuiz,
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget buildQuestionWidget(question) {
    switch (question.type) {
      case 'multiple':
        return MultipleChoiceQuestionWidget(question: question);
      case 'drag_drop':
        return DragDropQuestionWidget(question: question);
      case 'descriptive':
        return DescriptiveQuestionWidget(question: question);
      case 'true_false':
        return MultipleChoiceQuestionWidget(question: question);
      default:
        return const Text('Unknown question type');
    }
  }
}
