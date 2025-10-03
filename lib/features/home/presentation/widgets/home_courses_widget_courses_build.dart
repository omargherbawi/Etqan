// import 'dart:developer';
// import 'package:tedreeb_edu_app/config/app_colors.dart';
import '../../../../config/asset_paths.dart';
import '../../../../core/core.dart';
// import 'package:tedreeb_edu_app/core/enums/course_type_enum.dart';
import '../../../../core/routes/route_paths.dart';
// import 'package:tedreeb_edu_app/core/widgets/badges.dart';
import '../../../../main.dart';
import '../../../courses/data/models/course_model.dart';
import '../../../courses/presentation/widgets/icon_and_value_row_build.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart' hide Trans;
// import 'package:tedreeb_edu_app/features/saved/presentation/controllers/saved_courses_controller.dart';
// import 'package:tedreeb_edu_app/features/shared/data/datasources/shared_remote_datasources.dart';

class HomeCoursesBuild extends StatelessWidget {
  final List<CourseModel> courses;

  const HomeCoursesBuild({super.key, required this.courses});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Responsive.isTablet ? 430.h : 280.h,
      child: ListView.separated(
        separatorBuilder: (context, index) => SizedBox(width: 16.w),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        scrollDirection: Axis.horizontal,
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          logger.i(course.toJson());
          return SizedBox(
            width: 240.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
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
                  child: Stack(
                    children: [
                      Container(
                        height: Responsive.isTablet ? 270.h : 180.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            UIConstants.radius12,
                          ),
                          color: Get.theme.colorScheme.inversePrimary,
                          image: DecorationImage(
                            image: NetworkImage(course.image ?? ""),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(8.h),
                CustomTextWidget(
                  text: course.title ?? "",
                  maxLines: 2,
                  textAlign: TextAlign.start,
                  textThemeStyle: TextThemeStyleEnum.titleSmall,
                  fontWeight: FontWeight.w500,
                  color: Get.theme.colorScheme.inverseSurface,
                ),
                Gap(8.h),

                CustomTextWidget(
                  text: course.classSemester ?? "",
                  textThemeStyle: TextThemeStyleEnum.bodyMedium,
                  maxLines: 1,
                ),

                IconAndValueRowBuild(
                  svg: AssetPaths.personGrey,
                  value: course.teacher?.fullName ?? "",
                  textStyle: TextThemeStyleEnum.bodyMedium,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
