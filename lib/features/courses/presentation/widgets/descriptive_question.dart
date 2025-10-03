import '../../data/models/quiz_detail_model.dart';
import '../controllers/course_detail_controller.dart';
import 'question_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/widgets/custom_form_field.dart';

class DescriptiveQuestionWidget extends StatelessWidget {
  final Question question;

  const DescriptiveQuestionWidget({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CourseDetailController>();
    final TextEditingController textController = TextEditingController(
      text: controller.getSelectedAnswer(question.id) ?? '',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        QuestionWidget(question: question),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.all(16),
          child: CustomFormField(
            controller: textController,
            hintText: 'اكتب إجابتك هنا…',
            maxLines: 6,
            radius: 12,
            contentPadding: 14,
            verticalPadding: 14,
            filled: true,
            filledColor: Theme.of(context).colorScheme.onSurface,
            hasBorderSide: true,
            textInputAction: TextInputAction.newline,
            onChanged: (value) {
              controller.selectAnswer(question.id, value);
            },
            
          ),
        ),
      ],
    );
  }
}
