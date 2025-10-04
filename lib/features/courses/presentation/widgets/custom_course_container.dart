import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../../config/config.dart';
import '../../../../core/core.dart';
import '../../../shared/presentation/controllers/current_user_controller.dart';
import '../../data/models/course_model.dart';
import 'icon_and_value_row_build.dart';

class CustomCourseContainer extends StatelessWidget {
  final CourseModel course;
  final bool isOngoing;
  final bool showBorder;
  final bool isFavorite;
  final bool showRating;
  final Function()? onFavoriteBtnTap;
  final Function()? onCourseTap;

  const CustomCourseContainer({
    super.key,
    required this.course,
    this.isOngoing = true,
    this.showBorder = false,
    this.isFavorite = false,
    this.showRating = true,
    this.onFavoriteBtnTap,
    this.onCourseTap,
  });

  @override
  Widget build(BuildContext context) {
    final currentUserController = Get.find<CurrentUserController>();

    return GestureDetector(
      onTap: onCourseTap,
      child: Container(
        padding: EdgeInsets.all(5.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(UIConstants.radius12),
          border:
              showBorder
                  ? Border.all(color: Get.theme.colorScheme.surface)
                  : null,
        ),
        child: Row(
          children: [
            SizedBox(
              height: 90.h,
              width: 90.h,

              child: CustomCachedImage(
                borderRadius: BorderRadius.circular(14),
                image: course.image ?? "",
                fit: BoxFit.fill,
              ),

              // ),
            ),
            Gap(10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // if (onFavoriteBtnTap == null)
                  //   showRating
                  //       ? Row(
                  //         children: [
                  //           Icon(
                  //             Icons.star,
                  //             size: 14.sp,
                  //             color: AppLightColors.orangeColor,
                  //           ),
                  //           Gap(5.w),
                  //           CustomTextWidget(
                  //             text: course.rate ?? "",
                  //             maxLines: 1,
                  //             textAlign: TextAlign.center,
                  //             textThemeStyle: TextThemeStyleEnum.titleSmall,
                  //             fontWeight: FontWeight.w500,
                  //             color:
                  //                 Get.theme.colorScheme.tertiaryContainer,
                  //           ),
                  //         ],
                  //       )
                  //       : const SizedBox.shrink(),
                  // Gap(5.h),
                  CustomTextWidget(
                    text: "${course.title}",
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    textThemeStyle: TextThemeStyleEnum.titleSmall,
                    fontWeight: FontWeight.w500,
                    color: Get.theme.colorScheme.inverseSurface,
                  ),

                  CustomTextWidget(
                    text: course.classSemester ?? '',
                    textThemeStyle: TextThemeStyleEnum.bodyMedium,
                    maxLines: 1,
                  ),
                  Gap(3.h),
                  Row(
                    children: [
                      IconAndValueRowBuild(
                        svg: AssetPaths.personGrey,
                        value: course.teacher?.fullName ?? "",
                      ),
                      Gap(30.w),
                      if (currentUserController.user?.roleName ==
                          "teacher") ...{
                        IconAndValueRowBuild(
                          icon: Icons.diversity_3,
                          value: course.studentsCount?.toString() ?? "",
                        ),
                      },

                      // Icon(
                      //   Icons.person,
                      //   size: 14.sp,
                      //   color: Get.theme.colorScheme.tertiaryContainer,
                      // ),
                      // Gap(5.w),
                      // CustomTextWidget(
                      //     text: "${teacher?.fullName}",
                      //     maxLines: 1,
                      //     textAlign: TextAlign.center,
                      //     textThemeStyle: TextThemeStyleEnum.labelLarge,
                      //     color: Get.theme.colorScheme.tertiaryContainer),
                    ],
                  ),
                  // Gap(5.h),
                  // isOngoing
                  //     ? ProgressSlider(
                  //         totalMinutes: (course.progressPercent ?? 0).toDouble(),
                  //         completedMinutes:
                  //             (course.duration ?? 0).toDouble(),
                  //       )
                  //     : Row(
                  //         children: [
                  //           CustomTextWidget(
                  //             text: course.price == 0
                  //                 ? "free"
                  //                 : course.priceString ?? "",
                  //             maxLines: 1,
                  //             textAlign: TextAlign.start,
                  //             textThemeStyle: TextThemeStyleEnum.titleSmall,
                  //             fontWeight: FontWeight.w500,
                  //             color: Get.theme.primaryColor,
                  //           ),
                  //           const Spacer(),
                  //           getBadge(course),
                  //         ],
                  //       ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
