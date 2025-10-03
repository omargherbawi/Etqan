import 'package:flutter/material.dart';
import '../../../../core/utils/toast_utils.dart';
import '../../../../core/widgets/custom_text_widget.dart';
import '../../data/models/quiz_detail_model.dart';
import '../controllers/course_detail_controller.dart';

class QuizActions extends StatelessWidget {
  const QuizActions({
    super.key,
    required this.idx,
    required this.questions,
    required this.controller,
    this.onSubmit,
  });

  final int idx;
  final List<Question> questions;
  final CourseDetailController controller;
  final VoidCallback? onSubmit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: 100,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                if (idx < questions.length - 1) {
                  controller.currentQuestionIndex.value++;
                } else {
                  ToastUtils.showError('لا يوجد سؤال تالي');
                }
              },
              child: const CustomTextWidget(text: 'Next', fontSize: 15),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 100,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                if (idx > 0) {
                  controller.currentQuestionIndex.value--;
                } else {
                  ToastUtils.showError('لا يوجد سؤال قبل هذا');
                }
              },
              child: const CustomTextWidget(text: 'Back', fontSize: 15),
            ),
          ),
          const Spacer(),
          if (idx == questions.length - 1)
            SizedBox(
              width: 120,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 186, 241, 188),
                ),
                onPressed: onSubmit,
                child: const CustomTextWidget(
                  text: 'Submit',
                  fontSize: 15,
                  color: Color.fromARGB(255, 51, 117, 53),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
