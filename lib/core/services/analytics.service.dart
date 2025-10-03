import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../features/shared/presentation/controllers/current_user_controller.dart';
import '../../main.dart';

class AnalyticsService extends GetxService {
  final FirebaseAnalytics? _analytics;
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  static final AnalyticsService _instance = AnalyticsService._internal();

  factory AnalyticsService() => _instance;

  AnalyticsService._internal()
      : _analytics =
  (Platform.isAndroid || Platform.isIOS || kIsWeb)
      ? FirebaseAnalytics.instance
      : null;

  FirebaseAnalyticsObserver? get routeObserver =>
      _analytics != null
          ? FirebaseAnalyticsObserver(analytics: _analytics)
          : null;

  bool containsArabic(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }

  String formatDateTime(DateTime date) {
    return DateFormat("yyyy-MM-dd HH:mm").format(date);
  }

  String formatDate(DateTime date) {
    return DateFormat("yyyy-MM-dd").format(date);
  }

  Future<Map<String, Object>> _getUserParameters() async {
    if (_analytics == null) return {};
    final Map<String, Object> userParameters = {};
    final CurrentUserController userController =
    Get.find<CurrentUserController>();
    final String userName = userController.user?.fullName ?? "noName";
    final String sanitizedUserName =
    containsArabic(userName) ? "noName" : userName;

    _analytics
      ..setUserId(id: userController.user?.id.toString())
      ..setUserProperty(name: "user_name", value: sanitizedUserName);
    String model = "unknown";
    String brand = "unknown";
    String osVersion = "unknown";
    String company = "unknown";

    try {
      if (GetPlatform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        model = androidInfo.model.toString();
        brand = androidInfo.brand.toString();
        osVersion = "Android ${androidInfo.version.release}";
        company = "$brand $model";
      } else if (GetPlatform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        model = iosInfo.utsname.machine.toString();
        brand = "Apple";
        osVersion = "iOS ${iosInfo.systemVersion}";
        company = "$brand $model";
      }
    } catch (e) {
      logger.w("Device info fetch error: $e");
    }

    userParameters.addAll({
      'event_user_id': userController.user?.id.toString() ?? "null",
      'event_user_name': sanitizedUserName,
      'event_user_mobile': userController.user?.mobile.toString() ?? "null",
      'event_user_model': model,
      'event_user_brand': brand,
      'event_user_os': osVersion,
      'event_user_company': company,
    });

    return userParameters;
  }

  Future<void> logEvent({
    required String functionName,
    required String className,
    Map<String, Object>? parameters,
    Object? error,
    StackTrace? stack,
  }) async {
    if (_analytics == null) return;
    try {
      final String name = "${functionName}_$className";
      final String trimmedName =
      name.length > 40 ? name.substring(0, 39) : name;
      final Map<String, Object> updatedParameters = parameters ?? {};
      final userParameters = await _getUserParameters();
      updatedParameters.addAll(userParameters);
      updatedParameters['timestamp'] = formatDateTime(DateTime.now());

      updatedParameters['exception'] = error.toString();
      updatedParameters['stackTrace'] = stack?.toString() ?? "no-stack";
      logger.e(updatedParameters);
      await _analytics.logEvent(
        name: trimmedName,
        parameters: updatedParameters,
      );
    } catch (e) {
      logger.e('Analytics error: $e');
    }
  }

  Future<void> logScreenView({required String screenName}) async {
    if (_analytics == null) return;
    try {
      final Map<String, Object> updatedParameters = await _getUserParameters();
      updatedParameters['timestamp'] = formatDateTime(DateTime.now());

      await _analytics.logScreenView(
        screenName: screenName,
        parameters: updatedParameters,
      );
    } catch (e) {
      logger.e('Screen view logging error: $e');
    }
  }

  Future<void> logLogin({required Map<String, Object>? parameters}) async {
    if (_analytics == null) return;
    try {
      final Map<String, Object> updatedParameters = parameters ?? {};
      updatedParameters.addAll(await _getUserParameters());
      updatedParameters['timestamp'] = formatDate(DateTime.now());

      await _analytics.logLogin(
        loginMethod: "mobile",
        parameters: updatedParameters,
      );
    } catch (e) {
      logger.e('Login view logging error: $e');
    }
  }

  Future<void> logSignUp({
    required String signUpMethod,
    Map<String, Object>? parameters,
  }) async {
    if (_analytics == null) return;
    try {
      final Map<String, Object> updatedParameters = parameters ?? {};
      updatedParameters.addAll(await _getUserParameters());
      updatedParameters['timestamp'] = formatDateTime(DateTime.now());
      await _analytics.logSignUp(
        signUpMethod: signUpMethod,
        parameters: updatedParameters,
      );
    } catch (e) {
      logger.e('Sign-up logging error: $e');
    }
  }

  Future<void> logViewItem({
    required String itemId,
    required String itemName,
    required String itemCategory,
    required double price,
  }) async {
    if (_analytics == null) return;
    try {
      final item = AnalyticsEventItem(
        itemId: itemId,
        itemName: itemName,
        itemCategory: itemCategory,
        price: price,
      );
      final Map<String, Object> updatedParameters = await _getUserParameters();
      updatedParameters['date'] = formatDateTime(DateTime.now());

      await _analytics.logViewItem(
        currency: "JOR",
        items: [item],
        value: price,
        parameters: updatedParameters,
      );
    } catch (e) {
      logger.e('Purchase logging error: $e');
    }
  }

  Future<void> logError(Object error, StackTrace? stack) async {
    if (_analytics == null) return;
    try {
      final params = await _getUserParameters();
      params.addAll({
        "exception": error.toString(),
        "stackTrace": stack?.toString() ?? "no-stack",
        "timestamp": formatDateTime(DateTime.now()),
      });

      await _analytics.logEvent(name: "app_error", parameters: params);
    } catch (e) {
      logger.e("Analytics logError failed: $e");
    }
  }
}
