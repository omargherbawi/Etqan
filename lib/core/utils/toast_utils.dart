import '../../main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;

class ToastUtils {
  // Show error snackbar
  static void showError(String error) {
    if (error.isEmpty) return;
    logger.w("Toast $error");
    if (error == "auth.unauthorized") {
      error = tr("Invalidcredentials,pleasecheckyourphoneNumberorpassword");
    } else if (error == "device_limit_reached_please_try_again") {
      error = tr("account_exist");
    } else if (error == "account_exist") {
      error = "";
    }

    // Safely close existing snackbars without causing initialization errors
    _safeCloseAllSnackbars();

    Get.rawSnackbar(
      message: error.tr(),
      backgroundColor: Colors.red.withValues(alpha: 0.9),
      snackPosition:
          GetPlatform.isDesktop ? SnackPosition.BOTTOM : SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(10),
      borderRadius: 8,
      duration: const Duration(seconds: 3),
      isDismissible: true,
    );
  }

  // Show success snackbar
  static void showSuccess(String message) {
    if (message.isEmpty) return;

    // Safely close existing snackbars without causing initialization errors
    _safeCloseAllSnackbars();

    Get.rawSnackbar(
      message: message.tr(),
      backgroundColor: Colors.green.withValues(alpha: 0.8),
      snackPosition:
          GetPlatform.isDesktop ? SnackPosition.BOTTOM : SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(10),
      borderRadius: 8,
      duration: const Duration(seconds: 3),
      isDismissible: true,
    );
  }

  // Safe method to close all snackbars without causing initialization errors
  static void _safeCloseAllSnackbars() {
    try {
      if (Get.isSnackbarOpen) {
        Get.closeAllSnackbars();
      }
    } catch (e) {
      // If there's an initialization error, just ignore it
      // The new snackbar will still be shown
      logger.w("Failed to close existing snackbars: $e");
    }
  }
}
