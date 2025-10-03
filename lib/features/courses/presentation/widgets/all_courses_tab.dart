import '../../../../core/routes/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../../core/core.dart';
import 'custom_course_container.dart';

import '../controllers/user_course_controller.dart';

class AllCoursesTab extends StatelessWidget {
  const AllCoursesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final userCoursesController = Get.find<UserCourseController>();

    return Obx(() {
      return userCoursesController.isLoading.value
          ? LoadingAnimation(color: Get.theme.primaryColor)
          : Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Gap(10.h),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => userCoursesController.fetchFreeCourses(),
              child: NotificationListener<ScrollNotification>(
                onNotification: (scrollInfo) {
                  if (!userCoursesController.isFetchingFree.value &&
                      userCoursesController.hasMoreFree.value &&
                      scrollInfo.metrics.pixels >=
                          scrollInfo.metrics.maxScrollExtent - 200) {
                    userCoursesController.fetchFreeCourses(loadMore: true);
                  }
                  return false;
                },

                child: ListView.separated(
                  separatorBuilder:
                      (context, index) => SizedBox(height: 8.h),
                  itemCount:
                  userCoursesController.allFreeCourses.length +
                      (userCoursesController.hasMoreFree.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index <
                        userCoursesController.allFreeCourses.length) {
                      final course =
                      userCoursesController.allFreeCourses[index];
                      return CourseContainerDesign(
                        child: CustomCourseContainer(
                          showRating: false,
                          course: course,
                          isOngoing: true,
                          onCourseTap: () {
                            Get.toNamed(
                              RoutePaths.courseDetailScreen,
                              arguments: {
                                "isBundle": course.type == "bundle",
                                "id": course.id,
                                "isPrivate":
                                course.isPrivate == 1 ? true : false,
                              },
                            );
                          },
                        ),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: LoadingAnimation(
                          color: Get.theme.primaryColor,
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
