import '../../../../core/core.dart';
import '../controllers/course_detail_controller.dart';
import 'course_lessons_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class CourseLessonsTab extends StatefulWidget {
  const CourseLessonsTab({super.key});

  @override
  State<CourseLessonsTab> createState() => _CourseLessonsTabState();
}

class _CourseLessonsTabState extends State<CourseLessonsTab> {
  final courseController = Get.find<CourseDetailController>();

  @override
  void initState() {
    super.initState();
    courseController.scrollController.value.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (courseController.scrollController.value.position.userScrollDirection ==
        ScrollDirection.reverse) {
      // Scrolling Down
      courseController.isExpanded.value = false;
    } else if (courseController
            .scrollController
            .value
            .position
            .userScrollDirection ==
        ScrollDirection.forward) {
      // Scrolling Up
      courseController.isExpanded.value = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final courseContent = courseController.courseContent;
    final lessonsCount = courseController.lessonsCount;
    return Obx(() {
      return SingleChildScrollView(
        controller: courseController.scrollController.value,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: UIConstants.horizontalPaddingValue,
            // vertical: UIConstants.horizontalPaddingValue,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CustomTextWidget(
                    text: "lessons",
                    maxLines: 1,
                    textAlign: TextAlign.start,
                    textThemeStyle: TextThemeStyleEnum.bodyMedium,
                    fontWeight: FontWeight.w500,
                  ),
                  Gap(2.w),
                  CustomTextWidget(
                    text: "($lessonsCount)",
                    maxLines: 1,
                    textAlign: TextAlign.start,
                    textThemeStyle: TextThemeStyleEnum.bodyMedium,
                    fontWeight: FontWeight.w500,
                    color: Get.theme.primaryColor,
                  ),
                ],
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return CourseLessonsWidget(
                    content: courseContent[index],
                    courseId: courseController.singleCourseData.value.id!,
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(height: 16.h);
                },
                itemCount: courseContent.length,
              ),
            ],
          ),
        ),
      );
    });
  }
}
