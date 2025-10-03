import 'dart:io';

import '../../../../core/utils/toast_utils.dart';
import '../../../courses/data/models/course_model.dart';
import '../../../courses/data/models/packages/datum.dart';
import '../../data/datasources/shared_remote_datasources.dart';
import 'package:get/get.dart';

class SharedCoursesController extends GetxController {
  final _sharedRemoteDatasources = Get.find<SharedRemoteDatasources>();
  final newestClasses = <CourseModel>[].obs;
  final packages = <Datum>[].obs;
  final bestRatedClasses = <CourseModel>[].obs;
  final bestSellersClasses = <CourseModel>[].obs;
  final featuredClasses = <CourseModel>[].obs;
  final freeCoursesClasses = <CourseModel>[].obs;
  final paidCoursesClasses = <CourseModel>[].obs;
  final isLoading = false.obs;

  @override
  onReady() async {
    super.onReady();

    isLoading(true);
    // if (!kDebugMode) {
    await Future.wait([
      fetchPackages(),
      // fetchFeaturedClasses(),
      fetchFreeCoursesClasses(),
      fetchPaidCoursesClasses(),
      // fetchNewestClasses(),
      // fetchBestRatedClasses(),
      // fetchBestSellersClasses(),
    ]);
    // }
    isLoading(false);
  }

  Future<void> fetchFeaturedClasses() async {
    final res = await _sharedRemoteDatasources.fetchFeaturedCourses();
    res.fold(
      (l) {
        ToastUtils.showError(l.message);
      },
      (r) {
        featuredClasses.assignAll(r);
      },
    );
  }

  Future<void> fetchNewestClasses() async {
    final res = await _sharedRemoteDatasources.fetchClasses(sort: 'newest');
    res.fold(
      (l) {
        ToastUtils.showError(l.message);
      },
      (r) {
        newestClasses.assignAll(r);
      },
    );
  }

  Future<void> fetchPackages() async {
    if (!Platform.isAndroid) {
      return;
    }
    final res = await _sharedRemoteDatasources.fetchPackages();
    res.fold(
      (l) {
        ToastUtils.showError(l.message);
      },
      (r) {
        packages.assignAll(r);
      },
    );
  }

  Future<void> fetchBestRatedClasses() async {
    final res = await _sharedRemoteDatasources.fetchClasses(sort: 'best_rates');
    res.fold(
      (l) {
        ToastUtils.showError(l.message);
      },
      (r) {
        bestRatedClasses.assignAll(r);
      },
    );
  }

  Future<void> fetchBestSellersClasses() async {
    final res = await _sharedRemoteDatasources.fetchClasses(
      sort: 'bestsellers',
    );
    res.fold(
      (l) {
        ToastUtils.showError(l.message);
      },
      (r) {
        bestSellersClasses.assignAll(r);
      },
    );
  }

  Future<void> fetchFreeCoursesClasses() async {
    final res = await _sharedRemoteDatasources.fetchClasses(free: true);
    res.fold(
      (l) {
        ToastUtils.showError(l.message);
      },
      (r) {
        freeCoursesClasses.assignAll(r);
      },
    );
  }

  Future<void> fetchPaidCoursesClasses() async {
    final res = await _sharedRemoteDatasources.fetchClasses(free: false);
    res.fold(
      (l) {
        ToastUtils.showError(l.message);
      },
      (r) {
        paidCoursesClasses.assignAll(r);
      },
    );
  }

  List<CourseModel> get newestPaidCourses {
    return newestClasses
        .where((course) => course.price != null && course.price! > 0)
        .toList();
  }

  List<CourseModel> get paidCourses {
    final allCourses = [
      ...newestClasses,
      ...bestRatedClasses,
      ...bestSellersClasses,
      ...featuredClasses,
    ];
    return allCourses
        .where((course) => course.price != null && course.price! > 0)
        .toList();
  }

  // Future<void> addToFavorite({
  //   required bool isBundle,
  //   required String itemId,
  // }) async {
  //   final status = await _sharedRemoteDatasources.toggleSavedCourse(
  //     isBundle: isBundle,
  //     itemId: itemId,
  //   );

  //   if (status != null) {
  //     final isFavorited = status == "favored";

  //     _updateFavoriteStateInList(newestClasses, itemId, isFavorited);
  //     _updateFavoriteStateInList(bestRatedClasses, itemId, isFavorited);
  //     _updateFavoriteStateInList(bestSellersClasses, itemId, isFavorited);
  //     _updateFavoriteStateInList(featuredClasses, itemId, isFavorited);
  //   }
  // }

  // void _updateFavoriteStateInList(
  //   RxList<CourseModel> list,
  //   String courseId,
  //   bool isFavorited,
  // ) {
  //   final index = list.indexWhere((course) => course.id.toString() == courseId);
  //   if (index != -1) {
  //     final updatedList = [...list];
  //     updatedList[index] = list[index].copyWith(isFavorite: isFavorited);
  //     list.assignAll(updatedList);
  //   }
  // }
}
