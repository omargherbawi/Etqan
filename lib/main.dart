import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:logger/logger.dart';
import 'package:screen_protector/screen_protector.dart';
import 'package:etqan_edu_app/core/services/notification_service.dart';
import 'package:etqan_edu_app/di.dart';
import 'package:etqan_edu_app/firebase_options.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'app.dart';
import 'core/services/analytics.service.dart';

var logger = Logger(printer: PrettyPrinter());

void main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      FlutterError.onError =
          FirebaseCrashlytics.instance.recordFlutterFatalError;

      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };

      HttpOverrides.global = MyHttpOverrides();
      await WakelockPlus.enable();
      await EasyLocalization.ensureInitialized();
      await ScreenUtil.ensureScreenSize();

      if (GetPlatform.isMobile) {
        try {
          await ScreenProtector.protectDataLeakageWithBlur();
        } catch (e, s) {
          FirebaseCrashlytics.instance.recordError(e, s);
        }
      }

      await OneSignalNotificationService().init();

      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);

      await Hive.initFlutter();
      await Hive.openBox("App");
      DependencyInjection.init();

      final analytics = Get.find<AnalyticsService>();
      FlutterError.onError = (FlutterErrorDetails details) async {
        FlutterError.dumpErrorToConsole(details);
        await analytics.logError(details.exception, details.stack);
        FirebaseCrashlytics.instance.recordFlutterFatalError(details);
      };

      runApp(
        EasyLocalization(
          supportedLocales: const [Locale('ar'), Locale('en')],
          path: 'assets/translations',
          fallbackLocale: const Locale('ar'),
          startLocale: const Locale('ar'),
          child: const App(),
        ),
      );
    },
    (Object error, StackTrace stack) async {
      final analytics = Get.find<AnalyticsService>();
      await analytics.logError(error, stack);
    },
  );
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
