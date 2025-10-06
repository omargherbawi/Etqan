import 'package:etqan_edu_app/features/courses/data/models/single_course_model.dart';

import '../../../../core/core.dart';
import '../controllers/course_detail_controller.dart';
import '../screens/quiz_screen.dart';
import 'quiz_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class CourseQuizTab extends StatelessWidget {
  final SingleCourseModel course;
  const CourseQuizTab({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final courseController = Get.find<CourseDetailController>();
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: UIConstants.horizontalPaddingValue,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CustomTextWidget(
                text: "quizzes",
                maxLines: 1,
                textAlign: TextAlign.start,
                textThemeStyle: TextThemeStyleEnum.bodyMedium,
                fontWeight: FontWeight.w500,
              ),
              Gap(2.w),
              CustomTextWidget(
                text: course.quizzes.length.toString(),
                maxLines: 1,
                textAlign: TextAlign.start,
                textThemeStyle: TextThemeStyleEnum.bodyMedium,
                fontWeight: FontWeight.w500,
                color: Get.theme.primaryColor,
              ),
            ],
          ),
          if (course.quizzes.isNotEmpty) ...{
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(vertical: 16.h),

                itemCount: course.quizzes.length,
                separatorBuilder: (context, index) => SizedBox(height: 16.h),
                itemBuilder: (context, index) {
                  final quiz = course.quizzes[index];
                  return QuizItem(
                    quiz: quiz,
                    onTap: () {
                      showStartQuizConfirmation(
                        context,
                        courseController,
                        quiz.id!,
                      );
                    },
                  );
                },
              ),
            ),
          } else ...{
            const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CustomTextWidget(text: "NoQuizzesAvailable"),
              ),
            ),
          },
        ],
      ),
    );
  }

  void showStartQuizConfirmation(
    BuildContext context,
    CourseDetailController courseController,
    int quizId,
  ) {
    HelperFunctions.showCustomModalBottomSheet(
      context: context,
      child: CustomModalBottomSheet(
        title: "StartQuiz",
        description: "AreYouReadyToStartQuiz",
        confirmButtonText: "yes",
        cancelButtonText: "cancel",
        onConfirm: () async {
          Get.back(); // Close the modal first

          await courseController.startQuiz(quizId);
          if (courseController.quizDetailData.value != null) {
            Get.to(() => const QuizScreen());
          }
        },
        onCancel: () {
          Get.back();
        },
      ),
    );
  }
}
