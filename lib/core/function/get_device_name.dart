import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

Future<String> getDeviceName() async {
  final deviceInfoPlugin = DeviceInfoPlugin();

  if (Platform.isAndroid) {
    final androidInfo = await deviceInfoPlugin.androidInfo;
    return "${androidInfo.manufacturer} ${androidInfo.model} ${androidInfo.name}";
  } else if (Platform.isIOS) {
    final iosInfo = await deviceInfoPlugin.iosInfo;
    return iosInfo.name;
  } else {
    return "Unknown Device";
  }
}
