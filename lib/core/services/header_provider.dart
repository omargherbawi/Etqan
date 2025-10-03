import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:package_info_plus/package_info_plus.dart';

import '../../config/constants.dart';
import 'hive_services.dart';

class HeadersProvider {
  final HiveServices hive;

  HeadersProvider({required this.hive});

  Future<String> get platform async {
    if (kIsWeb) return 'web';
    if (Platform.isAndroid) {
      final installer = await appInstaller;

      if (installer == 'com.huawei.appmarket' ||
          installer.toLowerCase().contains('huawei')) {
        return 'huawei';
      }
      return 'android';
    }
    if (Platform.isIOS) return 'ios';
    if (Platform.isWindows) return 'windows';
    if (Platform.isMacOS) return 'macos';
    if (Platform.isLinux) return 'linux';
    return 'unknown';
  }

  Future<String> get appVersion async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  Future<String> get appInstaller async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.installerStore ?? '';
  }

  Future<Map<String, String>> getHeaders({Map<String, String>? extra}) async {
    final version = await appVersion;
    final platformName = await platform;

    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${hive.getToken}',
      'locale': hive.getLanguage,
      'x-api-key': AppConstants.apiKey,
      'platform': platformName,
      'app-version': version,
    };

    if (extra != null) headers.addAll(extra);
    return headers;
  }
}
