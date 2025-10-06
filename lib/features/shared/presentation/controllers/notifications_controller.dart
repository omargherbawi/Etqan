import 'dart:developer';

import 'package:get/get.dart';
import 'package:etqan_edu_app/features/shared/data/models/notification_model.dart';
import '../../../../core/core.dart';
import '../../../../core/utils/console_log_functions.dart';

import '../../data/datasources/shared_remote_datasources.dart';

class NotificationsController extends GetxController {
  final _notificationDataSource = Get.find<SharedRemoteDatasources>();
  final isLoadingNotifications = false.obs;
  final notifications = <NotificationModel>[].obs;

  @override
  onInit() async {
    await fetchNotifications();
    super.onInit();
  }

  Future<void> fetchNotifications() async {
    logInfo("inside fetchNotifications");

    isLoadingNotifications(true);
    final res = await _notificationDataSource.fetchNotifications();
    res.fold(
      (l) {
        ToastUtils.showError(l.message);
      },
      (r) {
        notifications.assignAll(
          r..sort((a, b) {
            if (a.status == 'unread' && b.status == 'read') {
              return -1;
            } else if (a.status == 'read' && b.status == 'unread') {
              return 1;
            } else {
              return 0;
            }
          }),
        );
        log(r.map((e) => e.id.toString()).toString());
      },
    );
    isLoadingNotifications(false);
  }

  Future<void> readNotification(int id) async {
    final notificationIndex = notifications.indexWhere((n) => n.id == id);

    if (notificationIndex == -1) {
      ToastUtils.showError("Notification not found");
      return;
    }

    final notification = notifications[notificationIndex];
    final updatedNotification = notification.copyWith(status: 'read');
    notifications[notificationIndex] = updatedNotification;

    final res = await _notificationDataSource.readNotification(id);

    if (!res) {
      final revertedNotification = notification.copyWith(status: 'unread');
      notifications[notificationIndex] = revertedNotification;
      ToastUtils.showError("Failed to mark notification as read");
    }
  }

  @override
  void onClose() {
    isLoadingNotifications.close();
    notifications.clear();
    super.onClose();
  }
}
