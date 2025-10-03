import 'dart:async';

import '../../../../core/core.dart';
import '../../../../main.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'course_detail_controller.dart';

class InAppPurchasesController extends GetxController {
  StreamSubscription<List<PurchaseDetails>>? _purchaseUpdatesSubscription;
  final courseDetailsController = Get.find<CourseDetailController>();

  final InAppPurchase _iap = InAppPurchase.instance;
  RxBool isPurchased = false.obs;
  RxBool isPurchasing = false.obs;
  RxBool isLoading = false.obs;
  RxString purchaseError = "".obs;
  late String _courseProductId;
  late int courseId;

  void updateCourseId(String id) {
    _courseProductId = id;
    update();
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    final arguments = Get.arguments as Map<String, dynamic>;
    logger.d("arguments: $arguments");
    courseId = arguments["id"] as int;
    const Set<String> kIds = <String>{'course_1', 'com.tedreeb.app.Lifetime'};
    final ProductDetailsResponse response = await InAppPurchase.instance
        .queryProductDetails(kIds);
    // if (response.notFoundIDs.isNotEmpty) {
    //   // Handle the error.
    // }
    List<ProductDetails> products = response.productDetails;
    await initialize();

    logger.d("products: $products");
  }

  @override
  void onClose() {
    _purchaseUpdatesSubscription?.cancel();
    super.onClose();
  }

  Future<void> initialize() async {
    isLoading.value = true;
    if (!await _iap.isAvailable()) {
      isLoading.value = false;

      return;
    }

    _purchaseUpdatesSubscription = _iap.purchaseStream.listen(
      (List<PurchaseDetails> purchaseDetailsList) async {
        logger.d("purchaseDetailsList: $purchaseDetailsList");
        await _handlePurchaseUpdates(purchaseDetailsList);
      },
      onDone: () {
        logger.d("purchase done");
        _purchaseUpdatesSubscription?.cancel();
      },
      onError: (error) {
        _purchaseUpdatesSubscription?.cancel();
        logger.e("error purchases: $error");
      },
    );
    isLoading.value = false;

    update();
  }

  Future<void> _handlePurchaseUpdates(
    List<PurchaseDetails> purchaseDetailsList,
  ) async {
    for (final purchaseDetails in purchaseDetailsList) {
      // var purchaseStatus = purchaseDetailsList[index].status;
      // switch (purchaseDetailsList[index].status) {
      //   case PurchaseStatus.pending:
      //     logger.d(' purchase is in pending ');
      //     continue;
      //   case PurchaseStatus.error:
      //     logger.d(' purchase error ');
      //     break;
      //   case PurchaseStatus.canceled:
      //     logger.d(' purchase cancel ');
      //     break;
      //   case PurchaseStatus.purchased:
      //     logger.d(' purchased ');
      //     break;
      //   case PurchaseStatus.restored:
      //     logger.d(' purchase restore ');
      //     break;
      // }
      // update();
      //
      // if (purchaseDetailsList[index].pendingCompletePurchase) {
      //   await _iap.completePurchase(purchaseDetailsList[index]).then((value) {
      //     if (purchaseStatus == PurchaseStatus.purchased) {}
      //   });
      // }
      // update();
      if (purchaseDetails.productID == _courseProductId) {
        logger.d("product id $_courseProductId");
        switch (purchaseDetails.status) {
          case PurchaseStatus.pending:
            isPurchasing.value = true;
            isLoading.value = true;
            logger.d("purchase pending");
            break;
          case PurchaseStatus.purchased:
            isPurchasing.value = false;
            isLoading.value = false;
            logger.d("purchase purchased");
            await courseDetailsController.purchaseCourseUsingIAP(courseId).then(
              (_) {
                courseDetailsController.singleCourseData.update((val) {
                  if (val != null) val.authHasBought = true;
                });

                isPurchasing.value = false;
                isPurchased.value = true;
                update();
              },
            );
            if (!purchaseDetails.pendingCompletePurchase) {
              await _iap.completePurchase(purchaseDetails);
            }
            break;
          case PurchaseStatus.error:
            isPurchasing.value = false;
            isLoading.value = false;
            isPurchased.value = false;
            purchaseError.value =
                purchaseDetails.error?.message ?? 'حدث خطأ أثناء الشراء';
            logger.d("purchase error: $purchaseError");
            break;
          case PurchaseStatus.restored:
            isPurchasing.value = false;
            isLoading.value = false;
            logger.d("purchase restored");
            break;
          case PurchaseStatus.canceled:
            isPurchasing.value = false;
            isLoading.value = false;
            logger.d("purchase canceled");
            ToastUtils.showError("purchase canceled");
            break;
        }
        update();
      }
      update();
    }
  }

  Future<PurchaseParam?> _buildPurchaseParam(String productId) async {
    final response = await _iap.queryProductDetails({productId});
    if (response.notFoundIDs.isNotEmpty || response.productDetails.isEmpty) {
      logger.e("Product $productId not found.");
      isPurchasing.value = false;
      purchaseError.value = "Product not found.";
      return null;
    }
    return PurchaseParam(productDetails: response.productDetails.first);
  }

  Future<void> buyNonConsumableProduct(String productId) async {
    _courseProductId = productId;
    try {
      final param = await _buildPurchaseParam(productId);
      if (param == null) return;
      await _iap.buyNonConsumable(purchaseParam: param);
      update();
    } catch (e) {
      logger.e("Error buying non-consumable product: $e");
    }
  }

  Future<void> buyConsumableProduct(String productId) async {
    try {
      final param = await _buildPurchaseParam(productId);
      if (param == null) return;
      await _iap.buyConsumable(purchaseParam: param);
    } catch (e) {
      logger.e("Error buying consumable product: $e");
      purchaseError.value = "Error buying consumable product";
    }
    update();
  }

  Future<void> restorePurchases() async {
    await _iap.restorePurchases();
  }
}
