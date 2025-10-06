import 'package:etqan_edu_app/core/errors/strings.dart';

class FileMaxSizeExceededException implements Exception {
  @override
  String toString() {
    return maxSizeExceededFailureMessage;
  }
}
