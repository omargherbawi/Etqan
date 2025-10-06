import 'dart:async';
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart' hide Trans;
import 'package:etqan_edu_app/core/utils/toast_utils.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void onInit() {
    super.onInit();
    initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
    );
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    super.onClose();
  }

  Future<void> initConnectivity() async {
    List<ConnectivityResult> result;
    try {
      result = await _connectivity.checkConnectivity();
    } on Exception catch (e) {
      log("Couldn't check connectivity status: $e");
      return;
    }
    _updateConnectionStatus(result);
  }

  void _updateConnectionStatus(List<ConnectivityResult> connectivityResult) {
    log("Connectivity Status: $connectivityResult");
    _connectivityDialog(connectivityResult);
  }

  void _connectivityDialog(List<ConnectivityResult> connectivityResult) {
    log(connectivityResult.map((e) => e.toString()).toList().toString());
    if (connectivityResult.contains(ConnectivityResult.none)) {
      log("No internet connection");

      if (Get.currentRoute.isNotEmpty) {
        ToastUtils.showError("noInternet".tr());
      }
    }
  }
}
