import 'package:get/get.dart';
import '../../blogs/presentation/controllers/blogs_controller.dart';
import '../../categories/data/data_sources/category_remote_data_source.dart';
import '../../categories/presentation/controllers/category_controller.dart';
import '../../courses/data/data_sources/course_remote_datasourse.dart';
import '../../courses/presentation/controllers/popular_course_controller.dart';
import '../../courses/presentation/controllers/user_course_controller.dart';
import '../data/datasources/home_remote_datasource.dart';
import '../presentation/controllers/refresh_home_data_controller.dart';

// import 'package:tedreeb_edu_app/features/shared/presentation/controllers/notifications_controller.dart';

class HomeBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CategoryRemoteDataSource>(() => CategoryRemoteDataSource());
    Get.lazyPut<CategoryController>(() => CategoryController());
    Get.lazyPut<HomeRemoteDatasource>(() => HomeRemoteDatasource());
    Get.lazyPut<HomeDataController>(() => HomeDataController());
    Get.lazyPut<CourseRemoteDataSource>(() => CourseRemoteDataSource());
    Get.lazyPut<UserCourseController>(() => UserCourseController());
    Get.lazyPut<BestRatedCourseController>(() => BestRatedCourseController());

    // Get.put<NotificationsController>(NotificationsController());

    Get.lazyPut<BlogsController>(() => BlogsController());
  }
}
