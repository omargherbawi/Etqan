import '../../../../core/core.dart';
import '../../../auth/data/models/province_model.dart';
import '../../data/datasources/home_remote_datasource.dart';
import '../../data/models/point_of_sale_model.dart';
import 'package:get/get.dart';

class PointsOfSaleController extends GetxController {
  final pointsOfSale = <PointOfSaleModel>[].obs;
  final provinces = <ProvinceModel>[].obs;
  final _homeRemoteDatasource = Get.find<HomeRemoteDatasource>();
  final isLoading = false.obs;
  final selectedProvince = Rxn<ProvinceModel>();
  int currentPage = 1;
  late String countryId;
  bool hasMore = true;
  bool isFetchingPOS = false;

  @override
  void onReady() {
    super.onReady();
    countryId = Get.arguments["id"] as String;
    fetchPointsOfSaleByCountryId(id: countryId, loadMore: false);
    fetchProvincesByCountryId();
  }

  void fetchProvincesByCountryId() async {
    isLoading(true);
    final res = await _homeRemoteDatasource.fetchProvincesByCountryId(
      countryId,
    );
    res.fold(
          (l) {
        ToastUtils.showError(l.message);
      },
          (r) {
        provinces.assignAll(r);
      },
    );
    isLoading(false);
  }

  void updateFetchingLoading(bool isLoading) {
    isFetchingPOS = isLoading;
    update();
  }

  Future<void> fetchPointsOfSaleByCountryId({
    bool loadMore = false,
    String? id,
  }) async {
    if (isFetchingPOS || !hasMore) return;
    updateFetchingLoading(true);
    if (!loadMore) {
      currentPage = 1;
      hasMore = true;
      pointsOfSale.clear();
    }
    final res = await _homeRemoteDatasource.fetchPointsOfSale(id, currentPage);
    res.fold(
          (l) {
        ToastUtils.showError(l.message);
      },
          (r) {
        if (loadMore) {
          final newItems =
          r.data
              .where(
                (u) => !pointsOfSale.any((existing) => existing.id == u.id),
          )
              .toList();
          pointsOfSale.addAll(newItems);
        } else {
          pointsOfSale.assignAll(r.data);
        }

        if (r.pagination.nextPageUrl != null) {
          currentPage++;
          hasMore = true;
        } else {
          hasMore = false;
        }
      },
    );
    updateFetchingLoading(false);
  }

  Future<void> refreshPointsOfSale() async {
    currentPage = 1;
    hasMore = true;
    await fetchPointsOfSaleByCountryId(loadMore: false);
  }

  void updateSelectedProvince(ProvinceModel? province) {
    if (province?.id == null) return;
    selectedProvince.value = province;
    fetchPointsOfSaleByCountryId(id: province!.id.toString(), loadMore: false);
  }
}
