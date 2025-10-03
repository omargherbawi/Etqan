import '../../data/models/quiz_detail_model.dart';
import 'answers_list.dart';
import 'question_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MultipleChoiceQuestionWidget extends StatelessWidget {
  final Question question;
  const MultipleChoiceQuestionWidget({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        QuestionWidget(question: question),
        SizedBox(height: 16.h),
        AnswersList(question: question),
      ],
    );
  }
}
