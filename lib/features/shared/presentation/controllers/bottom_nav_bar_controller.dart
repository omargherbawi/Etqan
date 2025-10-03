import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../account/presentation/screens/account_screen.dart';
import '../../../courses/presentation/controllers/user_course_controller.dart';
import '../../../courses/presentation/screens/user_course_screen.dart';
import '../../../home/presentation/screens/home_screen.dart';

class BottomNavController extends GetxController {
  var currentIndex = 0.obs;

  Future<void> setIndex(int index) async {
    currentIndex.value = index;
    update();
    if (index == 1) {
      if (Get.find<UserCourseController>().allCourses.isEmpty) {
        await Get.find<UserCourseController>().fetchPurchasedCourses();
      }
      // if (Get.find<UserCourseController>().allFreeCourses.isEmpty) {
      //   await Get.find<UserCourseController>().fetchPopularCourses();
      // }
    }
  }

  List<Widget> get screens {
    return [
      const HomeScreen(),
      const UserCurrentCourseScreen(),
      const AccountScreen(),
    ];
  }
}
