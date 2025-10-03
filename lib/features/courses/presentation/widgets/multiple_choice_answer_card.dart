import '../../data/models/quiz_detail_model.dart';
import '../controllers/course_detail_controller.dart';
import 'answer_webview_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnswerCard extends StatelessWidget {
  final Question question;
  final Answer answer;
  final int index;

  const AnswerCard({
    super.key,
    required this.question,
    required this.answer,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CourseDetailController>();

    return Obx(
      () => Card(
        color: Get.theme.cardColor,

        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color:
                controller.getSelectedAnswer(question.id) == answer.id
                    ? Theme.of(context).primaryColor
                    : Colors.transparent,
            width: 2,
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0,
          ),
          leading: Radio<int>(
            value: answer.id,
            groupValue: controller.getSelectedAnswer(question.id),
            onChanged: (value) => controller.selectAnswer(question.id, value),
          ),
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${index + 1}. ',
                style: const TextStyle(fontSize: 18, color: Colors.black),
              ),
              Expanded(
                child: AnswerWebViewWidget(
                  answerText: answer.title,
                  index: index,
                ),
              ),
            ],
          ),
          onTap: () => controller.selectAnswer(question.id, answer.id),
        ),
      ),
    );
  }
}
