import 'package:get/get.dart';

import '../../config/constants.dart';
import '../errors/strings.dart';
import '../utils/toast_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'analytics.service.dart';

class LaunchUrlService {
  static Future<void> openWeb(BuildContext context, String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (!await canLaunchUrl(uri)) {
        throw "Cannot launch URL: $url";
      }
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw unexpectedFailureMessage;
      }
    } catch (error) {
      Get.find<AnalyticsService>().logEvent(
        functionName: 'openWeb',
        className: 'launch_url_service',
        parameters: {"error": "$error"},
      );
      rethrow;
    }
  }

  static void openWhatsappToSupport(BuildContext context) async {
    final locale = context.locale;
    final message =
        locale == const Locale("en")
            ? "I forgot my password"
            : "لقد نسيت كلمة مروري";

    try {
      final Uri whatsappUri = Uri.parse(
        'https://wa.me/${AppConstants.contactUsPhoneNumber}?text=${Uri.encodeComponent(message)}',
      );

      if (!await launchUrl(whatsappUri)) {
        throw unexpectedFailureMessage;
      }
    } catch (error) {
      if (!context.mounted) return;
      return ToastUtils.showError(error.toString());
    }
  }

  static Future<void> makeAPhoneCall(
    BuildContext context,
    String phoneNumber,
  ) async {
    try {
      final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);

      // Check if the phone URI can be launched before attempting to launch it
      if (!await canLaunchUrl(phoneUri)) {
        throw "Cannot make phone call to: $phoneNumber";
      }

      if (!await launchUrl(phoneUri)) {
        throw unexpectedFailureMessage;
      }
    } catch (error) {
      Get.find<AnalyticsService>().logEvent(
        functionName: 'makeAPhoneCall',
        className: 'launch_url_service',
        parameters: {"error": "$error", "phoneNumber": phoneNumber},
      );
      if (!context.mounted) return;
      return ToastUtils.showError(error.toString());
    }
  }

  static Future<void> sendEmail(
    BuildContext context,
    String emailAddress,
  ) async {
    try {
      final Uri emailUri = Uri(
        scheme: 'mailto',
        path: emailAddress,
        query: 'subject=Your Subject&body=Hello, I need assistance',
      );

      if (!await launchUrl(emailUri)) {
        throw unexpectedFailureMessage;
      }
    } catch (error) {
      Get.find<AnalyticsService>().logEvent(
        functionName: 'sendEmail',
        className: 'launch_url_service',
        parameters: {"error": "$error"},
      );
      if (!context.mounted) return;
      return ToastUtils.showError(error.toString());
    }
  }

  static Future<void> openWhatsapp(BuildContext context) async {
    final locale = context.locale;
    final message = locale == const Locale("en") ? "Hello" : "مرحبا";

    try {
      final Uri whatsappUri = Uri.parse(
        'https://wa.me/${AppConstants.contactUsPhoneNumber}?text=${Uri.encodeComponent(message)}',
      );

      if (!await launchUrl(whatsappUri)) {
        throw unexpectedFailureMessage;
      }
    } catch (error) {
      Get.find<AnalyticsService>().logEvent(
        functionName: 'openWhatsapp',
        className: 'launch_url_service',
        parameters: {"error": "$error"},
      );
      if (!context.mounted) return;
      return ToastUtils.showError(error.toString());
    }
  }

  static Future<void> openMap(double latitude, double longitude) async {
    final googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
    );

    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
    } else {
      Get.find<AnalyticsService>().logEvent(
        functionName: 'openMap',
        className: 'launch_url_service',
        parameters: {"error": "Could not open the map."},
      );
      throw 'Could not open the map.';
    }
  }
}
