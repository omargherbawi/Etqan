import 'dart:async';

import 'package:get/get.dart';

class ResetPasswordController extends GetxController {
  RxInt secondsRemaining = 60.obs;
  Timer? _timer;
  RxBool isLoading = false.obs;
  RxBool isResetingPassword = false.obs;
  RxBool isOtpView = false.obs;
  RxBool isOtpVerified = false.obs; // Track if OTP is verified

  // void sendOtp(String email, [bool force = false]) async {
  //   // Skip calling the API if the email matches the previous
  //   if (email.trim() == this.email.value?.trim() &&
  //       force == false &&
  //       isOtpVerified.value == false) {
  //     isOtpView.value = true;
  //     return;
  //   }
  //
  //   if (isOtpVerified.value) {
  //     Get.to(() => const ResetPasswordScreen());
  //     return;
  //   }
  //   _startTimer();
  //
  //   isLoading.value = true;
  //   await Future.delayed(const Duration(seconds: 2)); // Simulate API call delay
  //   isLoading.value = false;
  //   this.email.value = email.trim();
  //   isOtpView.value = true;
  //
  //   // Start the timer for 60 seconds
  // }
  //
  // void verifyOtp(String otp) {
  //   if (otp == "1234") {
  //     isOtpVerified.value = true;
  //     if (Get.context != null) {
  //       Navigator.pop(Get.context!);
  //     }
  //     Get.to(() => const ResetPasswordScreen());
  //   } else {
  //     ToastUtils.showError("Invalid OTP");
  //   }
  // }

  // void resetPassword(String password) async {
  //   // password.trim();
  //   isResetingPassword.value = true;
  //   await Future.delayed(const Duration(seconds: 1));
  //   isResetingPassword.value = false;
  // }

  // void _startTimer() {
  //   secondsRemaining.value = 60;
  //   _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
  //     if (secondsRemaining.value > 0) {
  //       secondsRemaining.value--;
  //     } else {
  //       _stopTimer();
  //     }
  //   });
  // }

  // void _stopTimer() {
  //   _timer?.cancel();
  //   secondsRemaining.value = 60;
  // }
  //
  // void disableOtpView() {
  //   isOtpView.value = false;
  // }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
