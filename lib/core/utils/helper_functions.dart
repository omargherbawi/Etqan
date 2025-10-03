import '../enums/text_style_enum.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_modal_bottom_sheet.dart';
import '../../features/courses/presentation/helpers/in_app_purchase_helper.dart';
import '../../features/shared/presentation/controllers/current_user_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../features/shared/presentation/controllers/bottom_nav_bar_controller.dart';
import '../services/api_services.dart';
import '../widgets/custom_text_widget.dart';

class HelperFunctions {
  static String truncateText(String text, int maxLength) {
    return text.length > maxLength
        ? '${text.substring(0, maxLength)}...'
        : text;
  }

  static Future<void> showCustomModalBottomSheet({
    required BuildContext context,
    required Widget child,
    bool showDragHandler = false,
    bool isScrollControlled = false,
  }) async {
    showModalBottomSheet(
      constraints: const BoxConstraints(minWidth: double.infinity),
      showDragHandle: showDragHandler,
      context: context,
      isScrollControlled: isScrollControlled,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.only(
            top: 10,
            bottom: 40,
            left: 20,
            right: 20,
          ),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: child,
        );
      },
    );
  }

  static void showLogoutDialog(BuildContext context) async {
    return HelperFunctions.showCustomModalBottomSheet(
      context: context,
      showDragHandler: true,
      child: CustomModalBottomSheet(
        title: "logout",
        description: "areYouSureLogout",
        confirmButtonText: "yes",
        onConfirm: () {
          Navigator.pop(context);
          Get.find<CurrentUserController>().logUserOut();
          Get.find<BottomNavController>().setIndex(0);
        },
        onCancel: () {
          Navigator.pop(context);
        },
        cancelButtonText: "cancel",
      ),
    );
  }

  static void showRestoreDialog(BuildContext context) async {
    return HelperFunctions.showCustomModalBottomSheet(
      context: context,
      showDragHandler: true,
      child: CustomModalBottomSheet(
        title: "restorePurchases",
        description: "areYouSureRestorePurchases",
        confirmButtonText: "yes",
        onConfirm: () async {
          Navigator.pop(context);
          try {
            await InAppPurchaseHelper().restorePurchases();
            Get.snackbar(tr("success"), tr("purchasesRestored"));
          } catch (e) {
            Get.snackbar(tr("Failed"), tr("purchasesRestoredFailed"));
          }
        },
        onCancel: () {
          Navigator.pop(context);
        },
        cancelButtonText: "cancel",
      ),
    );
  }

  static void showDeleteDialog(BuildContext context) async {
    return HelperFunctions.showCustomModalBottomSheet(
      context: context,
      showDragHandler: true,
      child: CustomModalBottomSheet(
        title: "deleteAccount",
        description: "areYouSureDelete",
        confirmButtonText: "yes",
        onConfirm: () {
          Navigator.pop(context);
          RestApiService.post("development/delete-my-account");
          Get.find<BottomNavController>().setIndex(0);
          Get.find<CurrentUserController>().logUserOut();
        },
        onCancel: () {
          Navigator.pop(context);
        },
        cancelButtonText: "cancel",
      ),
    );
  }

  static Future<Future<Object?>> showBlurredDialog({
    required BuildContext context,
    required String message,
    required String confirmText,
    VoidCallback? onConfirm,
    bool barrierDismissible = true,
  }) async {
    return showGeneralDialog(
      context: context,
      barrierLabel: 'BlurredDialog',
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) {
        return const SizedBox.shrink();
      },
      transitionBuilder: (dialogContext, animation, secondaryAnimation, child) {
        return BackdropFilter(
          filter: ui.ImageFilter.blur(
            sigmaX: 5 * animation.value,
            sigmaY: 5 * animation.value,
          ),
          child: FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutBack,
              ),
              child: Center(
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: 300.w,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: Get.theme.colorScheme.primary,
                        width: 0.4,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomTextWidget(
                          text: message,
                          textThemeStyle: TextThemeStyleEnum.titleMedium,
                          textAlign: TextAlign.center,
                          maxLines: 6,
                          // default isLocalize = true
                        ),
                        SizedBox(height: 16.h),
                        CustomButton(
                          width: double.infinity,
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                            if (onConfirm != null) {
                              onConfirm();
                            }
                          },
                          child: CustomTextWidget(
                            text: confirmText,
                            color: Colors.white,
                            // default isLocalize = true
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
