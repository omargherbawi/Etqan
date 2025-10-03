import '../../../../config/app_colors.dart';
import '../../../../core/enums/text_style_enum.dart';
import '../../../../core/widgets/custom_text_widget.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/models/quiz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../screens/user_results_screen.dart';

class QuizItem extends StatelessWidget {
  final Quiz quiz;
  final VoidCallback? onTap;
  const QuizItem({super.key, required this.quiz, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Get.theme.cardColor,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: CustomImage(
                image: quiz.image ?? "",
                width: 90.w,
                height: 80.w,
                fit: BoxFit.cover,
              ),
            ),
            Gap(12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextWidget(
                    text: quiz.title ?? "Quiz",
                    textThemeStyle: TextThemeStyleEnum.titleMedium,
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    maxLines: 2,
                  ),
                  Gap(6.h),
                  Row(
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        size: 16.sp,
                        color: Get.theme.primaryColor,
                      ),
                      Gap(4.w),

                      Row(
                        children: [
                          CustomTextWidget(
                            text: quiz.time.toString(),
                            textThemeStyle: TextThemeStyleEnum.bodySmall,
                          ),
                          Gap(4.w),
                          const CustomTextWidget(
                            text: "min",
                            textThemeStyle: TextThemeStyleEnum.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Gap(6.h),
                  Wrap(
                    spacing: 12.w,
                    runSpacing: 6.h,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.help_outline,
                            size: 16.sp,
                            color: Get.theme.primaryColor,
                          ),
                          Gap(4.w),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomTextWidget(
                                text: quiz.questionCount.toString(),
                                textThemeStyle: TextThemeStyleEnum.bodySmall,
                              ),
                              Gap(4.w),
                              const CustomTextWidget(
                                text: "Questions",
                                textThemeStyle: TextThemeStyleEnum.bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.category,
                            size: 16.sp,
                            color: Get.theme.primaryColor,
                          ),
                          Gap(4.w),
                          Flexible(
                            child: CustomTextWidget(
                              text: quiz.questionTypes ?? "",
                              textThemeStyle: TextThemeStyleEnum.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            FittedBox(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppLightColors.primaryColorLight,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Get.to(() => UserResultsScreen(
                    quizId: quiz.id ?? 0,
                    quizTitle: quiz.title,
                  ));
                },
                child: CustomTextWidget(
                  text: 'ShowResult',
                  color: AppLightColors.primaryColor,
                  fontSize: 12.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
