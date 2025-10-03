import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:tedreeb_edu_app/config/hive_box_constants.dart';

class HiveServices {
  final Box _box = Hive.box("App");
  Box getInstance() {
    return _box;
  }

  void setLanguageCode(Locale lang) {
    _box.put(AppSettingsBoxConstants.languageKey, lang.languageCode);
  }

  String get getLanguage {
    return Get.locale?.languageCode ?? "ar";
  }

  // Token management
  void setToken(String? token) {
    if (token != null) {
      log("Setting token: $token");
      _box.put(AppSettingsBoxConstants.tokenKey, token);
    }
  }

  String? get getToken {
    return _box.get(AppSettingsBoxConstants.tokenKey) as String?;
  }

  // Theme management
  void setThemeMode(bool isDarkMode) {
    _box.put(AppSettingsBoxConstants.themeModeKey, isDarkMode);
  }

  bool? getThemeMode() {
    return _box.get(AppSettingsBoxConstants.themeModeKey) as bool?;
  }

  // Onboarding management
  void setIsOnBoardingShown(bool isShown) {
    _box.put(AppSettingsBoxConstants.isOnBoardingShown, isShown);
  }

  bool getIsOnBoardingShown() {
    return (_box.get(AppSettingsBoxConstants.isOnBoardingShown) as bool?) ??
        false;
  }

  // Notifications
  void setAllowNotificationToApp(bool enabled) {
    _box.put(AppSettingsBoxConstants.allowNotificationToApp, enabled);
  }

  bool getAllowNotificationToApp() {
    return (_box.get(AppSettingsBoxConstants.allowNotificationToApp)
            as bool?) ??
        true;
  }

  // App rating management

  void setAppRated() {
    _box.put(AppSettingsBoxConstants.isAppRatedKey, true);
  }

  bool? getIsAppRated() {
    return _box.get(AppSettingsBoxConstants.isAppRatedKey) as bool?;
  }

  void setTotalTimeSpent(int seconds) {
    _box.put(AppSettingsBoxConstants.totalTimeSpentKey, seconds);
  }

  int getTotalTimeSpent() {
    return _box.get(AppSettingsBoxConstants.totalTimeSpentKey, defaultValue: 0)
        as int;
  }

  Future<void> clearPreferences() async {
    bool onBoardingStatus = getIsOnBoardingShown();
    bool notificationStatus = getAllowNotificationToApp();
    _box.clear();

    // Resetting the onboarding value if it is true, because we don't want to show onboarding again after logout
    if (onBoardingStatus) {
      setIsOnBoardingShown(onBoardingStatus);
    }

    setAllowNotificationToApp(notificationStatus);
  }
}
