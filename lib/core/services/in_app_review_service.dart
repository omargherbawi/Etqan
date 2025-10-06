// import 'package:get/get.dart';
// import 'package:in_app_review/in_app_review.dart';
// import 'package:etqan_edu_app/core/services/hive_services.dart';
// import 'dart:async';

// import 'package:etqan_edu_app/core/utils/prints.dart';

// class InAppReviewService extends GetxController {
//   final InAppReview inAppReview = InAppReview.instance;
//   final HiveServices _hiveService = Get.find<HiveServices>();

//   Timer? _timer;
//   int _secondsSpent = 0;

//   @override
//   void onInit() {
//     super.onInit();
//     loadPreviousTimeSpent();
//     startTrackingTime();
//   }

//   void loadPreviousTimeSpent() {
//     _secondsSpent = _hiveService.getTotalTimeSpent();
//   }

//   void startTrackingTime() {
//     if (_hiveService.getIsAppRated() == true) {
//       return;
//     }

//     _timer = Timer.periodic(Duration(seconds: 1), (timer) {
//       _secondsSpent++;
//       printDebug("iar timer increased, total: $_secondsSpent");

//       // Store the total time spent in Hive
//       _hiveService.setTotalTimeSpent(_secondsSpent);

//       // Check if 20 minutes (1200 seconds) have passed
//       if (_secondsSpent >= 1200) {
//         _timer?.cancel();
//         _hiveService.setAppRated();
//         return rateApp();
//       }
//     });
//   }

//   void rateApp() async {
//     if (await inAppReview.isAvailable()) {
//       await inAppReview.requestReview();
//     }
//   }

//   void pauseTimer() {
//     _timer?.cancel();
//   }

//   void resumeTimer() {
//     startTrackingTime();
//   }

//   @override
//   void onClose() {
//     _timer?.cancel();
//     super.onClose();
//   }
// }
