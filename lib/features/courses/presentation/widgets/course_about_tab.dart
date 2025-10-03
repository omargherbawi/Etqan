import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:tedreeb_edu_app/features/courses/presentation/widgets/mentor_tile_widget.dart'
    show MentorTileWidget;
import '../../../../core/core.dart';
import '../../../../core/utils/console_log_functions.dart';
import '../../../../core/utils/date_utils.dart';
import '../controllers/course_detail_controller.dart';
import 'first_heading_widget.dart';

class CourseAboutTab extends StatelessWidget {
  const CourseAboutTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final courseDetails =
          Get.find<CourseDetailController>().singleCourseData.value;
      logJSON(object: courseDetails.teacher?.toJson());
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: UIConstants.horizontalPaddingValue,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const FirstHeadingWidget(heading: "courseDetails"),

              Gap(12.h),
              HtmlWidget(courseDetails.description ?? ''),

              Gap(15.h),
              const FirstHeadingWidget(heading: 'instructor'),
              Gap(12.h),
              if (courseDetails.teacher != null)
                MentorTileWidget(mentor: courseDetails.teacher!),

              //
              //   **** info
              Gap(15.h),
              const FirstHeadingWidget(heading: 'info'),
              Gap(12.h),

              Row(
                children: [
                  // Expanded(
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       const CustomTextWidget(
                  //         text: "students",
                  //         maxLines: 1,
                  //         textThemeStyle: TextThemeStyleEnum.titleSmall,
                  //       ),
                  //       CustomTextWidget(
                  //         text: courseDetails.studentsCount?.toString() ?? "",
                  //         maxLines: 1,
                  //         textThemeStyle: TextThemeStyleEnum.titleSmall,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomTextWidget(
                          text: "dateCreated",
                          maxLines: 1,
                          textThemeStyle: TextThemeStyleEnum.titleSmall,
                        ),
                        CustomTextWidget(
                          text: timeStampToDate(courseDetails.createdAt ?? 0),
                          maxLines: 1,
                          textThemeStyle: TextThemeStyleEnum.titleSmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
