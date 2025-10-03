import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../../core/core.dart';

import '../controllers/user_course_controller.dart';

class ContinueLearningScreen extends StatelessWidget {
  const ContinueLearningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userCourseController = Get.find<UserCourseController>();

    return Scaffold(
      appBar: CustomAppBar(title: "continueLearning", onBack: () => Get.back()),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: UIConstants.horizontalPadding,
          child: Obx(() {
            return userCourseController.isLoading.value
                ? LoadingAnimation(color: Get.theme.primaryColor)
                : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Gap(10.h),
                    // Expanded(
                    //   child: ListView.separated(
                    //     separatorBuilder: (context, index) {
                    //       return SizedBox(height: 8.h);
                    //     },
                    //     shrinkWrap: true,
                    //     itemCount: userCourseController.allCourses.length,
                    //     itemBuilder: (BuildContext context, int index) {
                    //       CourseModel course = userCourseController.allCourses[index];

                    //       return CourseContainerDesign(
                    //         child: CustomCourseContainer(
                    //           course: course,
                    //           isOngoing: true,
                    //         ),
                    //       );
                    //     },
                    //   ),
                    // ),
                  ],
                );
          }),
        ),
      ),
    );
  }
}
