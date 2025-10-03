import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

import '../../main.dart';
import '../routes/route_paths.dart';

class WindowsScreenPrivacy extends GetxController {
  static WindowsScreenPrivacy get to => Get.find();
  static const MethodChannel _channel = MethodChannel('screen_privacy');
  final RxBool shouldHide = false.obs;

  void startListening() {
    if (!Platform.isWindows) return;
    _channel.setMethodCallHandler((call) async {
      logger.e('method called ${call.method}');
      if (call.method == 'security_alert') {
        shouldHide.value = true;
      } else if (call.method == 'hideApp') {
        shouldHide.value = true;
      } else if (call.method == 'showApp') {
        shouldHide.value = false;
      }
      if (shouldHide.value) {
        Get.offAllNamed(RoutePaths.blankPage);
      }
    });
  }
}
