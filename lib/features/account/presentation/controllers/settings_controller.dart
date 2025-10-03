import 'package:get/get.dart';
import '../../../../config/notification.dart';
import '../../../../core/core.dart';
import '../../../../core/services/analytics.service.dart';
import '../../../../core/services/hive_services.dart';

class SettingsController extends GetxController {
  final _hiveService = Get.find<HiveServices>();
  final RxBool dailyCoinsCollectionReminder = false.obs;
  final RxBool newQuizReminder = false.obs;
  final RxBool hideMeInLeaderboard = false.obs;
  final RxBool vibrateOnWrongAnswer = false.obs;
  final notificationEnabled = true.obs;
  final changingNotificationStatus = false.obs;

  @override
  void onReady() {
    notificationEnabled.value = _hiveService.getAllowNotificationToApp();

    super.onReady();
  }

  // Toggle daily coins collection reminder
  void toggleDailyCoinsCollectionReminder(bool value) {
    dailyCoinsCollectionReminder.value = value;
  }

  // Toggle new quiz reminder
  void toggleNewQuizReminder(bool value) {
    newQuizReminder.value = value;
  }

  // Toggle hide me in leaderboard
  void toggleHideMeInLeaderboard(bool value) {
    hideMeInLeaderboard.value = value;
  }

  // Toggle vibrate on wrong answer
  void toggleVibrateOnWrongAnswer(bool value) {
    vibrateOnWrongAnswer.value = value;
  }

  Future<void> changeNotificationStatus(bool value) async {
    changingNotificationStatus(true);
    try {
      bool status;
      if (value) {
        status = await NotificationService().initializeFirebaseToken();
        notificationEnabled.value = value;
        _hiveService.setAllowNotificationToApp(value);
      } else {
        status = await NotificationService().saveToken('');
        notificationEnabled.value = value;
        _hiveService.setAllowNotificationToApp(value);
      }

      if (status) {
        ToastUtils.showSuccess('success');
      } else {
        ToastUtils.showError('error');
      }
    } catch (e) {
      Get.find<AnalyticsService>().logEvent(
        functionName: 'changeNotificationStatus',
        className: 'setting_controller',
        parameters: {"error": e.toString()},
      );
      ToastUtils.showError('error');
    } finally {
      changingNotificationStatus(false);
    }
  }
}
