import 'package:get/get.dart';
import '../../../../core/core.dart';
import '../../data/data_sources/category_remote_data_source.dart';
import '../../data/models/category_model.dart';

class CategoryController extends GetxController {
  final _categoryRemoteDataSource = Get.find<CategoryRemoteDataSource>();

  final List<CategoryModel> allCategories = [];

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  void fetchCategories() async {
    isLoading(true);
    final res = await _categoryRemoteDataSource.getCategories();
    res.fold((l) => ToastUtils.showError(l.message), (r) {
      allCategories.assignAll(r);
    });
    isLoading(false);
  }

  @override
  void onClose() {
    allCategories.clear();
    super.onClose();
  }
}
