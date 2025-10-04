import '../../../../core/routes/route_paths.dart';
import '../../../courses/data/models/course_model.dart';
import '../../../courses/presentation/widgets/custom_course_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart' hide Trans;

class HomeCoursesBuild extends StatelessWidget {
  final List<CourseModel> courses;

  const HomeCoursesBuild({super.key, required this.courses});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int index = 0; index < courses.length; index++) ...[
            CustomCourseContainer(
              course: courses[index],
              isOngoing: false,
              showBorder: false,
              isFavorite: false,
              showRating: true,
              onCourseTap: () {
                final course = courses[index];
                Get.toNamed(
                  RoutePaths.courseDetailScreen,
                  arguments: {
                    "isBundle": course.type == "bundle",
                    "id": course.id,
                    "isPrivate": course.isPrivate == 1 ? true : false,
                  },
                );
              },
            ),
            if (index < courses.length - 1) Gap(16.h),
          ],
        ],
      ),
    );
  }
}
