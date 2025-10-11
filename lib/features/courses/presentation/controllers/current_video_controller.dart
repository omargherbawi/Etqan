import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/services/hive_services.dart';
import '../../../home/presentation/controllers/last_opened_course_controller.dart';

class CurrentVideoController extends GetxController {
  final currentVideoUrl = Rxn<String>();

  final currentVideoId = RxnInt();

  // Store course data for saving last opened course
  Map<String, dynamic>? _courseData;
  
  void setCourseData(Map<String, dynamic> courseData) {
    _courseData = courseData;
  }

  void changeCurrentVideoUrl({required String video, int? id}) {
    if (video == currentVideoUrl.value) {
      return;
    }

    if (video.contains("store") && !video.startsWith("http")) {
      currentVideoUrl(video);
      currentVideoId(id);
    } else {
      currentVideoUrl(video);
      currentVideoId(id);
    }

    // Save last opened course when video is played
    _saveLastOpenedCourse();
  }

  void _saveLastOpenedCourse() {
    if (_courseData != null) {
      try {
        final hiveServices = Get.find<HiveServices>();
        hiveServices.setLastOpenedCourse(_courseData!);

        // Refresh the controller if it exists
        if (Get.isRegistered<LastOpenedCourseController>()) {
          Get.find<LastOpenedCourseController>().refresh();
        }
      } catch (e) {
        debugPrint('Error saving last opened course: $e');
      }
    }
  }

  void toggleVideoWatchedStatus(bool value) {}

  @override
  void onClose() {
    currentVideoUrl.close();
    currentVideoId.close();

    super.onClose();
  }
}
