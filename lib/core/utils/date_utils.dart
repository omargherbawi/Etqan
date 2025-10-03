import 'package:get/get.dart';
import 'package:intl/intl.dart';

extension CustomDate on DateTime {
  String toDate() => DateFormat('d MMM y', Get.locale?.languageCode).format(this);

  String toHour() => DateFormat('Hms', Get.locale?.languageCode).format(this);

  String toDayHour() {
    return '${DateFormat('d MMMM', Get.locale?.languageCode).format(this)}, ${DateFormat('Hm').format(this)}';
  }
}

String dayHourMinuteSecondFormatted(Duration date) {
  return [date.inDays, date.inHours.remainder(24), date.inMinutes.remainder(60), date.inSeconds.remainder(60)]
      .map((seg) {
    return seg.toString().padLeft(2, '0');
  }).join(':');
}

String timeStampToDate(int timeStamp, {bool isUtc = true}) => DateFormat('d MMM y', Get.locale?.languageCode)
    .format(DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000, isUtc: isUtc));

String timeStampToDateHour(int timeStamp, {bool isUtc = true}) =>
    DateFormat('d MMM y  hh:mm', Get.locale?.languageCode)
        .format(DateTime.fromMillisecondsSinceEpoch(timeStamp, isUtc: isUtc));

String formatHHMMSS(int seconds) {
  int hours = (seconds / 3600).truncate();
  seconds = (seconds % 3600).truncate();
  int minutes = (seconds / 60).truncate();

  String hoursStr = (hours).toString().padLeft(2, '0');
  String minutesStr = (minutes).toString().padLeft(2, '0');
  String secondsStr = (seconds % 60).toString().padLeft(2, '0');

  if (hours == 0) {
    return "$minutesStr:$secondsStr";
  }

  return "$hoursStr:$minutesStr:$secondsStr";
}

String formatTimestamp(int timestamp) {
  final now = DateTime.now();
  final inputTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
  final difference = now.difference(inputTime);

  if (difference.inMinutes < 60) {
    // Less than an hour
    return '${difference.inMinutes} min';
  } else if (difference.inHours < 24 && inputTime.day == now.day) {
    // Today
    return '${difference.inHours} hr';
  } else if (difference.inDays < 7) {
    // Within the last 7 days
    return '${difference.inDays}d';
  } else {
    // Beyond 7 days
    return '${inputTime.year}-${inputTime.month.toString().padLeft(2, '0')}-${inputTime.day.toString().padLeft(2, '0')}';
  }
}

DateTime toLocal(String date) {
  if (date.isEmpty) {
    return DateTime.now();
  }
  return DateFormat("yyyy-MM-ddTHH:mm:ssZ").parseUTC(date).toLocal();
}

String durationToString(int minutes) {
  var d = Duration(minutes: minutes);
  List<String> parts = d.toString().split(':');
  return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
}

String secondDurationToString(int seconds) {
  var d = Duration(seconds: seconds);
  List<String> parts = d.toString().split(':');
  return '${parts[1].padLeft(2, '0')}:${parts[2].padLeft(2, '0').split('.').first}';
}
