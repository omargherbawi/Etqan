import 'dart:developer';

import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../../config/constants.dart';

class OneSignalNotificationService {
  Future<void> init() async {
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

    OneSignal.initialize(AppConstants.oneSignalNotificationID);

    final hasPermission = await OneSignal.Notifications.requestPermission(true);
    log(
      hasPermission == true
          ? "Accepted notifications"
          : "Declined notifications",
    );

    // Optional: add permission observer
    OneSignal.Notifications.addPermissionObserver((state) {
      log("Has permission $state");
    });
  }

  void enableNotification() {
    OneSignal.User.pushSubscription.optIn();
  }

  void disableNotification() {
    OneSignal.User.pushSubscription.optOut();
  }

  Future<String?> getOneSignalUserId() async {
    return OneSignal.User.pushSubscription.id;
  }
}
