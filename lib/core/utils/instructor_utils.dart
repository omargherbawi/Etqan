import 'dart:ui';

import 'package:etqan_edu_app/core/enums/text_style_enum.dart';
import 'package:etqan_edu_app/core/widgets/custom_button.dart';
import 'package:etqan_edu_app/core/widgets/custom_text_widget.dart';
import 'package:etqan_edu_app/features/auth/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../widgets/custom_cached_image.dart';

class InstructorUtils {
  static Future<void> showInstructorDialog(
    BuildContext context,
    UserModel instructor,
  ) {
    return showGeneralDialog(
      context: context,
      barrierLabel: "Instructor Detail",
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) {
        return const SizedBox.shrink();
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 5 * animation.value,
            sigmaY: 5 * animation.value,
          ),
          child: FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutBack,
              ),
              child: Center(
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: 300.w,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: Get.theme.colorScheme.primary,
                        width: 0.4,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Add CustomCachedImage on top
                        if (instructor.avatar != null &&
                            instructor.avatar!.isNotEmpty)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(60.r),
                            child: CustomCachedImage(
                              image: instructor.avatar!,
                              width: 80.w,
                              height: 80.w,
                              fit: BoxFit.cover,
                            ),
                          ),
                        if (instructor.avatar != null &&
                            instructor.avatar!.isNotEmpty)
                          Gap(16.h),
                        CustomTextWidget(
                          text: instructor.fullName ?? '',
                          textThemeStyle: TextThemeStyleEnum.titleLarge,
                        ),
                        Gap(12.h),
                        CustomTextWidget(
                          text: instructor.bio ?? '',
                          textThemeStyle: TextThemeStyleEnum.bodyMedium,
                          maxLines: 10,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Gap(16.h),
                        CustomButton(
                          width: double.infinity,
                          onPressed: () => Navigator.of(context).pop(),
                          child: const CustomTextWidget(
                            text: "إغلاق",
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
