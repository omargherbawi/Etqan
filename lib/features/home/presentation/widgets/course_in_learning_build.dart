import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../../config/asset_paths.dart';
import '../../../../core/core.dart';
import '../../../../core/routes/route_paths.dart';
import '../../../courses/presentation/widgets/icon_and_value_row_build.dart';
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
            width: double.infinity,
            height: Responsive.isTablet ? 200.h : 120.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(UIConstants.radius12),
              color: Get.theme.colorScheme.inversePrimary,
            ),
            child: Row(
              children: [
                // Course Image
                Container(
                  width: Responsive.isTablet ? 200.w : 120.w,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(UIConstants.radius12),
                      bottomLeft: Radius.circular(UIConstants.radius12),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(course.image ?? ""),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Gap(12.w),
                // Course Details
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomTextWidget(
                          text: course.title ?? "",
                          maxLines: 2,
                          textAlign: TextAlign.start,
                          textThemeStyle: TextThemeStyleEnum.titleMedium,
                          fontWeight: FontWeight.w600,
                          color: Get.theme.colorScheme.inverseSurface,
                        ),
                        Gap(4.h),
                        if (course.classSemester != null) ...{
                          CustomTextWidget(
                            text: course.classSemester ?? "",
                            textThemeStyle: TextThemeStyleEnum.bodySmall,
                            maxLines: 1,
                          ),
                          Gap(4.h),
                        },
                        IconAndValueRowBuild(
                          svg: AssetPaths.personGrey,
                          value: course.teacher?.fullName ?? "",
                          textStyle: TextThemeStyleEnum.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
                Gap(8.w),
              ],
            ),
          ),
        ),
      );
    });
  }
}

