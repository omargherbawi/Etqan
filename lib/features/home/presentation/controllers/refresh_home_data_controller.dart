import 'dart:developer';
import 'package:get/get.dart';
import '../../../../core/utils/console_log_functions.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../../core/core.dart';
import '../../data/datasources/home_remote_datasource.dart';

class HomeDataController extends GetxController {
  final _homeRemoteDatasource = Get.find<HomeRemoteDatasource>();

  final isLoading = false.obs;
  bool isFetchingInstructors = false;

  final instructors = <UserModel>[];

  int currentPage = 1;
  bool hasMore = true;

  @override
  void onReady() {
    fetchAllInstructors();
    super.onReady();
  }

  void updateFetchingInstructorsLoading(bool isLoading) {
    isFetchingInstructors = isLoading;
    update();
  }

  Future<void> fetchAllInstructors({bool loadMore = false}) async {
    if (isFetchingInstructors || !hasMore) return;

    updateFetchingInstructorsLoading(true);
    if (!loadMore) {
      currentPage = 1;
      hasMore = true;
      instructors.clear();
    }

    final res = await _homeRemoteDatasource.fetchAllInstructors(currentPage);
    res.fold(
      (l) {
        logError(l.message);
      },
      (r) {
        if (loadMore) {
          final newItems =
              r.data
                  .where(
                    (u) => !instructors.any((existing) => existing.id == u.id),
                  )
                  .toList();
          instructors.addAll(newItems);
        } else {
          instructors.assignAll(r.data);
        }

        if (r.pagination.nextPageUrl != null) {
          currentPage++;
          hasMore = true;
        } else {
          hasMore = false;
        }
      },
    );

    updateFetchingInstructorsLoading(false);
  }

  Future<void> refreshInstructors() async {
    currentPage = 1;
    hasMore = true;
    await fetchAllInstructors(loadMore: false);
  }

  Future<void> refreshHomeData() async {
    try {
      final results = await _homeRemoteDatasource.refreshAllData();

      final failures = results.where((result) => result.isLeft()).toList();

      if (failures.isNotEmpty) {
        final firstFailure = failures.first.getLeft();
        firstFailure.fold(() => ToastUtils.showError("Error"), (_) {});
        return;
      }

      for (final result in results) {
        result.fold((_) {}, (data) {
          log("Success: $data");
        });
      }
    } catch (e) {
      ToastUtils.showError("An unexpected error occurred.");
      log("Error while refreshing home data: $e");
    }
  }
}
