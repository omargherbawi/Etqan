import '../data/data_sources/course_remote_datasourse.dart';
import '../presentation/controllers/current_video_controller.dart';
import 'package:get/get.dart';

import '../presentation/controllers/course_detail_controller.dart';

class CourseBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CourseDetailController>(
      () => CourseDetailController(),
      fenix: true,
    );
    Get.lazyPut<CurrentVideoController>(
      () => CurrentVideoController(),
      fenix: true,
    );
    Get.lazyPut<CourseRemoteDataSource>(
      () => CourseRemoteDataSource(),
      fenix: true,
    );
  }
}
