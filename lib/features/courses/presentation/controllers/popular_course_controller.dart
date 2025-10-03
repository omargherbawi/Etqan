import '../../../categories/presentation/controllers/filter_courses_controller.dart';

class BestRatedCourseController extends FilterCoursesController {}

// class PopularCourseController extends GetxController {
//   final _courseRemoteDataSource = Get.find<CourseRemoteDataSource>();
//
//   final allCourses = <PurchaseCourseModel>[].obs;
//
//   final isLoading = false.obs;
//   final tabIndex = 0.obs;
//
//   @override
//   void onReady() {
//     super.onReady();
//     fetchPopularCourses();
//   }
//
//   Future<void> fetchPopularCourses() async {
//     isLoading(true);
//
//     final res = await _courseRemoteDataSource.fetchPopularCourses();
//     res.fold(
//       (l) => ToastUtils.showError(l.message),
//       (r) {
//         allCourses.assignAll(r);
//       },
//     );
//     isLoading(false);
//   }
// }
