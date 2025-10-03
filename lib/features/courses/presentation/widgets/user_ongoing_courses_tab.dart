import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../config/asset_paths.dart';
import '../../../../core/core.dart';
import '../../../../core/routes/route_paths.dart';
import '../../data/models/course_model.dart';
import 'custom_course_container.dart';

import '../controllers/user_course_controller.dart';

class UserOngoingCourseTab extends StatelessWidget {
  const UserOngoingCourseTab({super.key});

  @override
  Widget build(BuildContext context) {
    final userCoursesController = Get.find<UserCourseController>();
    // return Obx(() {
    //
    //   return userCoursesController.isLoading.value
    //       ? LoadingAnimation(color: Get.theme.primaryColor)
    //       : RefreshIndicator(
    //         onRefresh:
    //             () async => await userCoursesController.fetchPurchasedCourses(),
    //         child:
    //             userCoursesController.allCourses.isEmpty
    //                 ? ListView(
    //                   physics:
    //                       const AlwaysScrollableScrollPhysics(), // 👈 important
    //                   children: [
    //                     SizedBox(height: Get.height * 0.2),
    //                     Center(
    //                       child: emptyState(
    //                         AssetPaths.courseEmptyStateSvg,
    //                         "لا يوجد دورات خاصة بك",
    //                         "",
    //                       ),
    //                     ),
    //                   ],
    //                 )
    //                 : NotificationListener<ScrollNotification>(
    //                   onNotification: (scrollInfo) {
    //                     if (!userCoursesController.isFetchingPurchases.value &&
    //                         userCoursesController.hasMorePurchases.value &&
    //                         scrollInfo.metrics.pixels >=
    //                             scrollInfo.metrics.maxScrollExtent - 200) {
    //                       userCoursesController.fetchPurchasedCourses(
    //                         loadMore: true,
    //                       );
    //                     }
    //                     return false;
    //                   },
    //                   child: ListView.separated(
    //                     separatorBuilder:
    //                         (context, index) => SizedBox(height: 8.h),
    //
    //                     itemCount:
    //                         userCoursesController.allCourses.length +
    //                         (userCoursesController.hasMorePurchases.value
    //                             ? 1
    //                             : 0),
    //                     itemBuilder: (context, index) {
    //                       if (index < userCoursesController.allCourses.length) {
    //                         final purchasedCourse =
    //                             userCoursesController.allCourses[index];
    //
    //                         final course = CourseModel(
    //                           id: purchasedCourse.id,
    //                           studentsCount: purchasedCourse.studentsCount,
    //                           image: purchasedCourse.image ?? "",
    //                           teacher: purchasedCourse.teacher,
    //                           title: purchasedCourse.title,
    //                           label: purchasedCourse.label,
    //                           classSemester: purchasedCourse.classSemester,
    //                           type: purchasedCourse.type,
    //                           rate: purchasedCourse.rate,
    //                         );
    //
    //                         return CourseContainerDesign(
    //                           child: CustomCourseContainer(
    //                             course: course,
    //                             isOngoing: true,
    //                             showRating: false,
    //                             onCourseTap: () {
    //                               Get.toNamed(
    //                                 RoutePaths.courseDetailScreen,
    //                                 arguments: {
    //                                   "isBundle": course.type == "bundle",
    //                                   "id": course.id,
    //                                   "isPrivate":
    //                                       course.isPrivate == 1 ? true : false,
    //                                 },
    //                               );
    //                             },
    //                           ),
    //                         );
    //                       } else {
    //                         return Padding(
    //                           padding: const EdgeInsets.all(16),
    //                           child: LoadingAnimation(
    //                             color: Get.theme.primaryColor,
    //                           ),
    //                         );
    //                       }
    //                     },
    //                   ),
    //                 ),
    //       );
    // });
    return Obx(() {
      return RefreshIndicator(
        onRefresh: () async {
          await userCoursesController.refrehData();
        },
        child: NotificationListener<ScrollNotification>(
          onNotification: (scrollInfo) {
            if (!userCoursesController.isFetchingPurchases.value &&
                userCoursesController.hasMorePurchases.value &&
                scrollInfo.metrics.pixels >=
                    scrollInfo.metrics.maxScrollExtent - 200) {
              userCoursesController.fetchPurchasedCourses(loadMore: true);
            }
            return false;
          },

          child:
              userCoursesController.allCourses.isEmpty
                  ? Center(
                    child: emptyState(
                      AssetPaths.courseEmptyStateSvg,
                      "لا يوجد دورات خاصة بك",
                      "",
                    ),
                  )
                  : ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(height: 8.h),
                    itemCount:
                        userCoursesController.allCourses.length +
                        (userCoursesController.hasMorePurchases.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < userCoursesController.allCourses.length) {
                        final purchasedCourse =
                            userCoursesController.allCourses[index];
                        final webinar = purchasedCourse;
                        final CourseModel course;

                        course = CourseModel(
                          id: webinar.id,
                          studentsCount: webinar.studentsCount,
                          image: webinar.image ?? "",
                          // progress: webinar?.progress,
                          teacher: webinar.teacher,
                          title: webinar.title,
                          // badges: webinar?.badges,
                          // category: webinar?.category,
                          label: webinar.label,
                          // lessons: webinar?.lessons,
                          classSemester: webinar.classSemester,
                          // thumbnail: webinar?.thumbnail,
                          type: webinar.type,
                          rate: webinar.rate,
                        );

                        return CourseContainerDesign(
                          child: CustomCourseContainer(
                            course: course,
                            isOngoing: true,
                            showRating: false,
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
      );
    });
  }
}
