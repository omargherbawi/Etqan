import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart' hide Trans;
import 'package:etqan_edu_app/features/shared/data/models/notification_model.dart';
import '../../../../config/config.dart';
import '../../../../core/core.dart';
import '../../../../core/utils/date_utils.dart';
import '../controllers/notifications_controller.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<NotificationsController>();

    return Scaffold(
      appBar: const CustomAppBar(title: "notifications"),
      body: Obx(() {
        return homeController.isLoadingNotifications.value
            ? const Center(child: LoadingAnimation())
            : ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: homeController.notifications.length,
              itemBuilder: (context, index) {
                final notification = homeController.notifications[index];
                return NotificationItem(notification: notification);
              },
            );
      }),
    );
  }
}

class NotificationItem extends StatelessWidget {
  final NotificationModel notification;
  const NotificationItem({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // If unread, mark as read
        if (notification.status != 'read') {
          Get.find<NotificationsController>().readNotification(
            notification.id!,
          );
        }
        // Launch the custom animated dialog
        await showNotificationDialog(context, notification);
      },
      child: Container(
        padding: EdgeInsets.all(UIConstants.horizontalPaddingValue),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Get.theme.colorScheme.onSecondaryContainer,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNotificationIcon(notification),
            Gap(10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextWidget(
                          text: notification.title ?? '',
                          textThemeStyle: TextThemeStyleEnum.titleLarge,
                        ),
                      ),
                      Gap(3.w),
                      CustomTextWidget(
                        text: timeStampToDate(notification.createdAt ?? 0),
                        textThemeStyle: TextThemeStyleEnum.bodyMedium,
                        color: Get.theme.colorScheme.tertiaryContainer,
                      ),
                    ],
                  ),
                  Gap(4.h),
                  // Showing a truncated version or preview of the message
                  HtmlWidget(
                    notification.message ?? '',
                    textStyle: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationIcon(NotificationModel notification) {
    return Container(
      width: 56.w,
      height: 56.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Get.theme.colorScheme.onSecondaryContainer,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Center(
            child: SvgPicture.asset(
              AssetPaths.blueNotification,
              width: 24.w,
              height: 24.h,
            ),
          ),
          if (notification.status == 'unread')
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// This function shows a custom animated dialog that displays
/// the notification detail, with the background blurred.
Future<void> showNotificationDialog(
  BuildContext context,
  NotificationModel notification,
) {
  return showGeneralDialog(
    context: context,
    barrierLabel: "Notification Detail",
    barrierDismissible: true,
    // A transparent barrier, while the BackdropFilter will do the blurring.
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (context, animation, secondaryAnimation) {
      // The pageBuilder is not used directly in this case.
      return const SizedBox.shrink();
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      // Animate the background blur using the animation value
      return BackdropFilter(
        filter: ImageFilter.blur(
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
                        text: notification.title ?? '',
                        textThemeStyle: TextThemeStyleEnum.titleLarge,
                      ),
                      Gap(12.h),
                      HtmlWidget(
                        notification.message ?? '',
                        textStyle: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black87,
                        ),
                      ),
                      Gap(16.h),
                      CustomButton(
                        width: double.infinity,
                        onPressed: () => Navigator.of(context).pop(),
                        child: CustomTextWidget(
                          text: "close".tr(context: context),
                          color: Colors.white,
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
