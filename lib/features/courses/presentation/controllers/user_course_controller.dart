import '../../data/models/course_model.dart';
import 'package:get/get.dart';
import '../../../../core/core.dart';
import '../../data/data_sources/course_remote_datasourse.dart';
import '../../data/models/purchase_course_model.dart';

class UserCourseController extends GetxController {
  final _courseDatasource = Get.put(CourseRemoteDataSource());

  final allCourses = <PurchaseCourseModel>[].obs;
  final allFreeCourses = <CourseModel>[].obs;
  final allPaidCourses = <CourseModel>[].obs;

  final isLoading = false.obs;
  final isLoadingPurchase = false.obs;

  int currentPurchasesPage = 1;
  RxBool hasMorePurchases = true.obs;
  RxBool isFetchingPurchases = false.obs;

  int currentFreePage = 1;
  RxBool hasMoreFree = true.obs;
  RxBool isFetchingFree = false.obs;

  int currentPaidPage = 1;
  RxBool hasMorePaid = true.obs;
  RxBool isFetchingPaid = false.obs;

  void updateFetchingPurchasesLoading(bool isLoad) {
    isFetchingPurchases.value = isLoad;
    update();
  }

  void updateFetchingFreeLoading(bool isLoad) {
    isFetchingFree.value = isLoad;
    update();
  }

  void updateFetchingPaidLoading(bool isLoad) {
    isFetchingPaid.value = isLoad;
    update();
  }

  Future<void> fetchPurchasedCourses({bool loadMore = false}) async {
    if (isFetchingPurchases.value || !hasMorePurchases.value) return;
    updateFetchingPurchasesLoading(true);
    if (currentPurchasesPage == 1) {
      isLoading.value = true;
    }
    if (!loadMore) {
      currentPurchasesPage = 1;
      hasMorePurchases.value = true;
      allCourses.clear();
    }
    final res = await _courseDatasource.fetchPurchasedCourses(
      currentPurchasesPage,
    );
    res.fold((l) => ToastUtils.showError(l.message), (r) {
      if (loadMore) {
        final newItems =
            r.data
                .where(
                  (u) => !allCourses.any((existing) => existing.id == u.id),
                )
                .toList();
        allCourses.addAll(newItems);
      } else {
        allCourses.assignAll(r.data);
      }

      if (r.pagination.nextPageUrl != null) {
        currentPurchasesPage++;
        hasMorePurchases.value = true;
      } else {
        hasMorePurchases.value = false;
      }
    });
    updateFetchingPurchasesLoading(false);
    isLoading.value = false;
    update();
  }

  Future<void> refrehData() async {
    currentPurchasesPage = 1;
    hasMorePurchases.value = true;
    isFetchingPurchases.value = false;
    allCourses.clear();
    await fetchPurchasedCourses();
  }

  Future<void> fetchFreeCourses({bool loadMore = false}) async {
    if (isFetchingFree.value || !hasMoreFree.value) return;

    updateFetchingFreeLoading(true);
    if (!loadMore) {
      currentFreePage = 1;
      hasMoreFree.value = true;
      allFreeCourses.clear();
    }
    final res = await _courseDatasource.fetchFreeCourses(page: currentFreePage);
    res.fold((l) => ToastUtils.showError(l.message), (r) {
      // allCourses.assignAll(r);
      if (loadMore) {
        final newItems =
            r.data
                .where(
                  (u) => !allFreeCourses.any((existing) => existing.id == u.id),
                )
                .toList();
        allFreeCourses.addAll(newItems);
      } else {
        allFreeCourses.assignAll(r.data);
      }

      if (r.pagination.nextPageUrl != null) {
        currentFreePage++;
        hasMoreFree.value = true;
      } else {
        hasMoreFree.value = false;
      }
    });
    updateFetchingFreeLoading(false);
  }

  Future<void> fetchPaidCourses({bool loadMore = false}) async {
    if (isFetchingPaid.value || !hasMorePaid.value) return;

    updateFetchingPaidLoading(true);
    if (!loadMore) {
      currentPaidPage = 1;
      hasMorePaid.value = true;
      allPaidCourses.clear();
    }
    final res = await _courseDatasource.fetchPaidCourses(page: currentPaidPage);
    res.fold((l) => ToastUtils.showError(l.message), (r) {
      if (loadMore) {
        final newItems =
            r.data
                .where(
                  (u) => !allPaidCourses.any((existing) => existing.id == u.id),
                )
                .toList();
        allPaidCourses.addAll(newItems);
      } else {
        allPaidCourses.assignAll(r.data);
      }

      if (r.pagination.nextPageUrl != null) {
        currentPaidPage++;
        hasMorePaid.value = true;
      } else {
        hasMorePaid.value = false;
      }
    });
    updateFetchingPaidLoading(false);
  }

  // Future<void> fetchPopularCourses() async {
  //   isLoading(true);
  //
  //   final res = await _appRemoteDatasource.fetchClasses(free: true);
  //   res.fold((l) => ToastUtils.showError(l.message), (r) {
  //     allFreeCourses.assignAll(r);
  //   });
  //   isLoading(false);
  // }
}
