import 'package:get/get.dart';
import '../data/data_sources/course_remote_datasourse.dart';
import '../presentation/controllers/post_details_controller.dart';

class PostDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CourseRemoteDataSource>(() => CourseRemoteDataSource());
    Get.lazyPut<PostDetailsController>(() => PostDetailsController(post: Get.arguments));
  }
}
