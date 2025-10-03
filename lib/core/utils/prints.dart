import 'package:flutter/foundation.dart';

void printWarning(dynamic text) {
  if (kDebugMode) {
    print('\x1B[33m$text\x1B[0m');
  }
}

void printRed(dynamic text) {
  if (kDebugMode) {
    print('\x1B[31m$text\x1B[0m');
  }
}

void printDebug(dynamic text) {
  if (kDebugMode) {
    print('\x1B[32m$text\x1B[0m');
  }
}
