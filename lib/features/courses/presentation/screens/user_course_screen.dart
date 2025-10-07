import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/core.dart';

import '../controllers/user_course_controller.dart';
import '../widgets/user_ongoing_courses_tab.dart';

class UserCurrentCourseScreen extends StatelessWidget {
  const UserCurrentCourseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userCoursesController = Get.find<UserCourseController>();

    return Scaffold(
      appBar:  const CustomAppBar(
        title: "myCourses",
        leading: SizedBox.shrink(),
        // leading: Obx(() {
        //   return userCoursesController.isLoading.value
        //       ? const LoadingAnimation()
        //       : IconButton(
        //         iconSize: 30,
        //         onPressed: () {
        //           userCoursesController.refrehData();
        //         },
        //         icon: Icon(Icons.refresh, color: AppLightColors.primaryColor),
        //       );
        // }),
      ),
      body: Center(
        child: Padding(
          padding: UIConstants.horizontalPadding,
          child: Obx(() {
            if (userCoursesController.isLoading.value) {
              return LoadingAnimation(color: Get.theme.primaryColor);
            }
            return const UserOngoingCourseTab();
          }),
        ),
      ),
    );
  }
}
