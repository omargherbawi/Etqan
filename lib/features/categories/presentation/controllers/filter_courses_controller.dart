import 'package:get/get.dart';
import '../../../../core/utils/toast_utils.dart';
import '../../data/models/category_model.dart';
import '../../data/models/filter_model.dart';
import '../../../courses/data/models/course_model.dart';
import '../../../shared/data/datasources/shared_remote_datasources.dart';

class FilterCoursesController extends GetxController {
  final SharedRemoteDatasources _datasource =
      Get.find<SharedRemoteDatasources>();

  // Reactive state.
  var courses = <CourseModel>[].obs;
  var featuredCourses = <CourseModel>[].obs;
  var filters = <FilterModel>[].obs;

  var isLoading = false.obs;
  var isFetchingMoreData = false.obs;

  // Filter parameters.
  var filtersSelected = <int>[].obs;
  var upcoming = false.obs;
  var free = false.obs;
  var discount = false.obs;
  var downloadable = false.obs;
  var sort = ''.obs;
  var bundleCourse = false.obs;
  var rewardCourse = false.obs;

  // Pagination & Category.
  int offset = 0;
  final int limit = 20; // Adjust as needed.
  CategoryModel? category;

  /// Initialize data using the given category.
  void initData({CategoryModel? cat}) {
    category = cat;
    refreshData();
    fetchFilters();
    fetchFeatured();
  }

  /// Clears current courses and reloads from offset 0.
  Future<void> refreshData() async {
    offset = 0;
    courses.clear();
    await fetchData();
  }

  /// Fetch courses with pagination.
  Future<void> fetchData() async {
    // if (category == null) return;

    // Set proper loading flags.
    if (offset == 0) {
      isLoading.value = true;
    } else {
      isFetchingMoreData.value = true;
    }
    List<CourseModel> newData = [];

    try {
      // Make sure to pass a plain list rather than an RxList.
      final res = await _datasource.fetchClasses(
        offset: offset,
        cat: category?.id.toString(),
        filterOption: filtersSelected,
        upcoming: upcoming.value,
        free: free.value,
        discount: discount.value,
        downloadable: downloadable.value,
        sort: sort.value,
        bundle: bundleCourse.value,
        reward: rewardCourse.value,
      );

      res.fold((l) {}, (r) {
        newData.assignAll(r);
      });

      courses.addAll(newData);
      offset += newData.length;
    } catch (e) {
      ToastUtils.showError(e.toString());
    } finally {
      isLoading.value = false;
      isFetchingMoreData.value = false;
    }
  }

  /// Fetch filters for the current category.
  Future<void> fetchFilters() async {
    if (category == null) return;
    try {
      final res = await _datasource.fetchFilters(category!.id!);
      res.fold(
        (l) {
          ToastUtils.showError(l.message);
        },
        (r) {
          filters.assignAll(r);
        },
      );
    } catch (e) {
      ToastUtils.showError(e.toString());
    }
  }

  /// Fetch featured courses for the current category.
  Future<void> fetchFeatured() async {
    if (category == null) return;
    try {
      final res = await _datasource.fetchFeaturedCourses(
        cat: category!.id.toString(),
      );
      res.fold(
        (l) {
          ToastUtils.showError(l.message);
        },
        (r) {
          featuredCourses.assignAll(r);
        },
      );
    } catch (e) {
      ToastUtils.showError(e.toString());
    }
  }

  /// Applies the filters provided from the UI.
  void applyFilters({required List<int> filterSelected}) {
    filtersSelected.value = filterSelected;
    // Optionally, you can refresh data immediately.
    refreshData();
  }

  @override
  void onClose() {
    courses.clear();
    featuredCourses.clear();
    filters.clear();
    filtersSelected.clear();
    upcoming.close();
    free.close();
    discount.close();
    downloadable.close();
    sort.close();
    bundleCourse.close();
    rewardCourse.close();
    isLoading.close();
    isFetchingMoreData.close();
    super.onClose();
  }
}
