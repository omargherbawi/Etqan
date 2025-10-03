import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/core.dart';
import '../controllers/course_detail_controller.dart';
import '../../data/models/quiz_results_list_model.dart';

class UserResultsScreen extends StatefulWidget {
  final int quizId;
  final String? quizTitle;

  const UserResultsScreen({super.key, required this.quizId, this.quizTitle});

  @override
  State<UserResultsScreen> createState() => _UserResultsScreenState();
}

class _UserResultsScreenState extends State<UserResultsScreen> {
  late final CourseDetailController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<CourseDetailController>();
    // Fetch quiz results when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchAllQuizResults(widget.quizId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.quizTitle ?? 'ShowResult'),
      body: Obx(() {
        if (controller.isQuizResultsLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!controller.hasQuizResults || controller.quizResultsList.isEmpty) {
          return const Center(
            child: CustomTextWidget(
              text: 'لا يوجد نتائج في الوقت الحالي',
              textAlign: TextAlign.center,
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchAllQuizResults(widget.quizId),
          child: ListView.separated(
            padding: EdgeInsets.all(16.w),
            itemCount: controller.quizResultsCount,
            separatorBuilder: (context, index) => Gap(12.h),
            itemBuilder: (context, index) {
              final result = controller.quizResultsList[index];
              return _buildResultCard(result, index + 1);
            },
          ),
        );
      }),
    );
  }

  Widget _buildResultCard(QuizResultItem result, int attemptNumber) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Get.theme.cardColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with attempt number and status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTextWidget(
                text: 'المحاولة #$attemptNumber',
                textThemeStyle: TextThemeStyleEnum.titleMedium,
                fontWeight: FontWeight.bold,
              ),
              _buildStatusChip(result.status),
            ],
          ),
          Gap(12.h),

          // Score section
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Get.theme.scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomTextWidget(
                      text: 'النتيجة',
                      textThemeStyle: TextThemeStyleEnum.bodySmall,
                      color: Colors.grey,
                    ),
                    Gap(4.h),
                    CustomTextWidget(
                      text: '${result.userGrade}/${result.quizMark}',
                      textThemeStyle: TextThemeStyleEnum.titleLarge,
                      fontWeight: FontWeight.bold,
                      color: _getScoreColor(result.gradePercentage),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const CustomTextWidget(
                      text: 'النسبة المئوية',
                      textThemeStyle: TextThemeStyleEnum.bodySmall,
                      color: Colors.grey,
                    ),
                    Gap(4.h),
                    CustomTextWidget(
                      text: '${result.gradePercentage.toStringAsFixed(1)}%',
                      textThemeStyle: TextThemeStyleEnum.titleMedium,
                      fontWeight: FontWeight.bold,
                      color: _getScoreColor(result.gradePercentage),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Gap(12.h),

          // Date
          Row(
            children: [
              Icon(Icons.access_time, size: 16.sp, color: Colors.grey),
              Gap(6.w),
              CustomTextWidget(
                text: _formatDate(result.createdAtDateTime),
                textThemeStyle: TextThemeStyleEnum.bodySmall,
                color: Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color backgroundColor;
    Color textColor;
    String displayText;

    switch (status.toLowerCase()) {
      case 'passed':
        backgroundColor = Colors.green.withOpacity(0.1);
        textColor = Colors.green;
        displayText = 'نجح';
        break;
      case 'failed':
        backgroundColor = Colors.red.withOpacity(0.1);
        textColor = Colors.red;
        displayText = 'راسب';
        break;
      case 'waiting':
        backgroundColor = Colors.orange.withOpacity(0.1);
        textColor = Colors.orange;
        displayText = 'في الانتظار';
        break;
      default:
        backgroundColor = Colors.grey.withOpacity(0.1);
        textColor = Colors.grey;
        displayText = status;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: CustomTextWidget(
        text: displayText,
        textThemeStyle: TextThemeStyleEnum.bodySmall,
        color: textColor,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Color _getScoreColor(double percentage) {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 60) return Colors.orange;
    return Colors.red;
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} - ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
