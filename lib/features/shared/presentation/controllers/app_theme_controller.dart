import 'dart:developer';
import '../../../../core/services/hive_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  var themeMode = ThemeMode.light.obs;
  final _hiveService = Get.find<HiveServices>();

  @override
  void onInit() {
    _loadThemeMode();
    super.onInit();
  }

  bool get isDarkMode {
    final bool? isDarkMode = _hiveService.getThemeMode();
    if (isDarkMode != null) {
      themeMode.value = isDarkMode ? ThemeMode.dark : ThemeMode.light;
      return isDarkMode;
    }
    return false;
  }

  void toggleThemeToDark(bool isOn) {
    themeMode.value = isOn ? ThemeMode.dark : ThemeMode.light;
    log(themeMode.value.toString());
    _hiveService.setThemeMode(isOn);
  }

  void setDefaultFromSystem(BuildContext context) async {
    if (View.of(context).platformDispatcher.platformBrightness ==
        Brightness.dark) {
      toggleThemeToDark(true);
    } else {
      toggleThemeToDark(false);
    }
  }

  void _loadThemeMode() {
    bool? isDarkMode = _hiveService.getThemeMode();
    if (isDarkMode != null) {
      themeMode.value = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    }
  }
}
