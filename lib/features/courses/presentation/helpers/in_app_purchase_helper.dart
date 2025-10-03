import 'dart:async';
import 'dart:developer';
import 'dart:io';
import '../../../../core/utils/console_log_functions.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class InAppPurchaseHelper {
  static const String courseProductId = 'course_1';
  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  void listenToPurchaseUpdates({
    required void Function() onSuccess,
    required void Function(String error) onError,
    required void Function() onPending,
  }) {
    _subscription?.cancel();
    _subscription = _iap.purchaseStream.listen(
      (purchases) async {
        for (final purchase in purchases) {
          if (purchase.productID == courseProductId) {
            switch (purchase.status) {
              case PurchaseStatus.purchased:
                // Here you should verify the purchase with your backend if needed
                onSuccess();
                if (!purchase.pendingCompletePurchase) {
                  await _iap.completePurchase(purchase);
                }
                break;
              case PurchaseStatus.pending:
                onPending();
                break;
              case PurchaseStatus.error:
                onError(purchase.error?.message ?? 'حدث خطأ أثناء الشراء');
                break;
              case PurchaseStatus.canceled:
                onError('تم إلغاء الشراء');
                break;
              default:
                break;
            }
          }
        }
      },
      onError: (e) {
        logError(e.toString());
        onError(e.toString());
      },
    );
  }

  Future<void> buyCourse() async {
    if(isSimulator){
      throw Exception('In-App Purchases is not support in Simulator.');
    }
    final bool available = await _iap.isAvailable();
    if (!available) {
      throw Exception('متجر التطبيقات غير متوفر');
    }
    log("Is available: $available");

    final ProductDetailsResponse response = await _iap.queryProductDetails({
      'course_1',
    });

    log("ERROR:${response.error?.message}");
    log("ERROR:${response.error?.details}");
    log("ERROR:${response.productDetails}");
    if (response.notFoundIDs.isNotEmpty) {
      throw Exception('لم يتم العثور على المنتج');
    }
    final ProductDetails productDetails = response.productDetails.first;
    final PurchaseParam purchaseParam = PurchaseParam(
      productDetails: productDetails,
    );
    await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  Future<void> restorePurchases() async {
    await _iap.restorePurchases();
  }

  void dispose() {
    _subscription?.cancel();
  }

  bool get isSimulator{
    if(!Platform.isIOS) return false;
    return Platform.environment.containsKey('SIMULATOR_DEVICE_NAME');
  }
}
