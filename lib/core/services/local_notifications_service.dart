import 'dart:async';
import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';

class LocalNotificationsServices {
  LocalNotificationsServices._privateConstructor() {
    tz.initializeTimeZones();
  }

  static final LocalNotificationsServices _instance =
      LocalNotificationsServices._privateConstructor();

  static LocalNotificationsServices get instance => _instance;

  late FlutterLocalNotificationsPlugin _fltrNotification;

  Future<void> initialize() async {
    try {
      tz.initializeTimeZones();
      const androidInitilize =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const iOSinitilize = DarwinInitializationSettings();
      const initilizationsSettings = InitializationSettings(
        android: androidInitilize,
        iOS: iOSinitilize,
      );
      _fltrNotification = FlutterLocalNotificationsPlugin();

      await _fltrNotification.initialize(
        initilizationsSettings,
        // to handle event when we receive notification
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      );
      // await FirebaseMessaging.instance
      //     .setForegroundNotificationPresentationOptions(
      //   alert: true,
      //   badge: true,
      //   sound: true,
      // );
    } catch (e) {
      rethrow;
    }
  }

  void onDidReceiveNotificationResponse(
    NotificationResponse? notificationResponse,
  ) {
    if (notificationResponse == null) return;
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      log('notification payload: $payload');
    }
  }

  Future<bool?> requestAndroidPermissions() async {
    try {
      return await _fltrNotification
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()!
          .requestNotificationsPermission();
    } catch (error) {
      rethrow;
    }
  }

  Future<bool?> requestIOSPermissions() async {
    try {
      return await _fltrNotification
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()!
          .requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } catch (error) {
      rethrow;
    }
  }

  Future<void> cancelNotification(int notificationID) async {
    try {
      await _fltrNotification.cancel(notificationID);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> cancelAllNotification() async {
    try {
      await _fltrNotification.cancelAll();
      // final List l = await _fltrNotification.pendingNotificationRequests();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> turnOnNotification(
    int? notificationId,
    DateTime? dateOfNextCheck,
    String? channelID,
    String? channelName,
    String? notificationTitle,
    String? notificationBody,
  ) async {
    try {
      if (dateOfNextCheck == null ||
          notificationId == null ||
          channelID == null ||
          channelName == null) {
        return;
      }
      if (dateOfNextCheck.isBefore(DateTime.now())) return;
      final androidDetails = AndroidNotificationDetails(
        channelID,
        channelName,
        importance: Importance.max,
      );

      final String nowInStringFormat = DateFormat(
        'yyyy-MM-dd',
        'en_US',
      ).add_Hms().format(
            DateTime.now(),
          );
      final DateTime? now = DateTime.tryParse(
        nowInStringFormat,
      );
      if (now == null) return;

      Duration duration = dateOfNextCheck.difference(now);
      if (duration.isNegative) {
        duration *= -1;
      }
      const iSODetails = DarwinNotificationDetails();
      final generalNotificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iSODetails,
      );

      await _fltrNotification.zonedSchedule(
        notificationId,
        notificationTitle,
        notificationBody,
        tz.TZDateTime.now(tz.local).add(duration),
        generalNotificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    } catch (error) {
      log(error.toString());
      rethrow;
    }
  }

  Future<void> turnOnNotificationPeriodically(
    int notificationId,
    RepeatInterval repeatInterval,
    String channelID,
    String channelName,
    String notificationTitle,
    String notificationBody,
  ) async {
    try {
      final androidDetails = AndroidNotificationDetails(
        channelID,
        channelName,
        importance: Importance.max,
      );

      const iSODetails = DarwinNotificationDetails();
      final generalNotificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iSODetails,
      );

      await _fltrNotification.periodicallyShow(
        notificationId,
        notificationTitle,
        notificationBody,
        repeatInterval,
        generalNotificationDetails,
        androidScheduleMode: AndroidScheduleMode.inexact,
      );
    } catch (error) {
      rethrow;
    }
  }
}
