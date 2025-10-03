import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../../config/config.dart';
import '../../../../core/core.dart';
import '../../../../core/routes/route_paths.dart';
import '../controllers/last_opened_course_controller.dart';

class CourseInLearningBuild extends StatelessWidget {
  const CourseInLearningBuild({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LastOpenedCourseController>();

    return Obx(() {
      final course = controller.lastOpenedCourse.value;

      if (course == null) {
        return const SizedBox.shrink();
      }

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: GestureDetector(
          onTap: () {
            Get.toNamed(
              RoutePaths.courseDetailScreen,
              arguments: {
                "isBundle": course.type == "bundle",
                "id": course.id,
                "isPrivate": course.isPrivate == 1 ? true : false,
              },
            );
          },
          child: Container(
            width: Responsive.isTablet ? 380.w : 320.w,
            height: Responsive.isTablet ? 450.h : 300.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(UIConstants.radius12),
            ),
            child: Stack(
              children: [
                // Course Image (full background)
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(UIConstants.radius12),
                    image: DecorationImage(
                      image: NetworkImage(course.image ?? ""),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Gradient overlay for better text readability
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(UIConstants.radius12),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.3),
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
                // Saved icon (top right)
                Positioned(
                  top: 12.h,
                  right: 12.w,
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Icon(
                      Icons.bookmark,
                      color: AppLightColors.primaryColor,
                      size: 20.sp,
                    ),
                  ),
                ),
                // Play icon (center)
                Center(
                  child: Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppLightColors.primaryColor.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 32.sp,
                    ),
                  ),
                ),
                // Course name and continue learning text (bottom left)
                Positioned(
                  bottom: 16.h,
                  left: 16.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextWidget(
                        text: course.title ?? "",
                        maxLines: 2,
                        textAlign: TextAlign.start,
                        textThemeStyle: TextThemeStyleEnum.titleMedium,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      Gap(4.h),
                      CustomTextWidget(
                        text: "continueLearning",
                        textThemeStyle: TextThemeStyleEnum.bodySmall,
                        maxLines: 1,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
