import 'dart:async';

import 'package:get/get.dart';
import '../../../../core/routes/route_paths.dart';
import '../../../../core/services/analytics.service.dart';
import '../../../../core/utils/toast_utils.dart';
import '../../data/models/signup_data_model.dart';

import '../../data/datasources/auth_remote_datasource.dart';

class VerifyOtpController extends GetxController {
  // static  VerifyOtpController get   myController => Get.find< VerifyOtpController>();
  static VerifyOtpController get myController {
    // Checking if the controller is already exist or not
    bool conExist = Get.isRegistered<VerifyOtpController>();
    if (!conExist) {
      Get.lazyPut<VerifyOtpController>(
        () => VerifyOtpController(),
        fenix: true,
      );
    }

    // checking if the AuthRemoteDatasource is already exist or not
    conExist = Get.isRegistered<AuthRemoteDatasource>();
    if (!conExist) {
      Get.lazyPut<AuthRemoteDatasource>(
        () => AuthRemoteDatasource(),
        fenix: true,
      );
    }

    return Get.find<VerifyOtpController>();
  }

  RxInt secondsRemaining = 60.obs;
  Timer? _timer;
  RxBool isLoading = false.obs;
  final _authRemoteDatasource = Get.find<AuthRemoteDatasource>();

  RxBool isResetingPassword = false.obs;
  final otpCode = Rxn<String>();
  RxBool isOtpView = false.obs;
  RxBool isOtpVerified = false.obs; // Track if OTP is verified
  SignupDataModel? signUpData;

  void setSignupData(SignupDataModel data) {
    signUpData = data;
    if (!data.newUser) {
      resendCode();
    } else {
      _startTimer();
    }

    // if (data.email != null && (data.email != signUpData?.email)) {
    //   signUpData = data;
    //   sendOtp(true);
    // } else if (data.phone != null && (data.phone != signUpData?.phone)) {
    //   signUpData = data;
    //   sendOtp(true);
    // } else {
    //   signUpData = data;
    // }
  }

  // void sendOtp([bool force = false]) async {
  //   if (force == false && isOtpVerified.value == false) {
  //     isOtpView.value = true;
  //     return;
  //   }
  //
  //   if (isOtpVerified.value) {
  //     _nextScreen();
  //     return;
  //   }
  //   _startTimer();
  //
  //   isLoading.value = true;
  //   await Future.delayed(const Duration(seconds: 1)); // Simulate API call delay
  //   isLoading.value = false;
  //   isOtpView.value = true;
  //
  //   // Start the timer for 60 seconds
  // }

  Future<void> resendCode() async {
    isLoading.value = true;

    if (signUpData!.email != null) {
      await _authRemoteDatasource.sendOtp(signUpData!.email!, null);
    } else {
      await _authRemoteDatasource.sendOtp(
        signUpData!.phone!,
        signUpData!.countryCode!,
      );
    }
    isLoading.value = false;
    _startTimer();
  }

  void _nextScreen() {
    if (signUpData!.newUser) {
      ToastUtils.showSuccess("accountCreatedSuccessfully");
      //   Remove all route and go to login
      Get.offAllNamed(RoutePaths.login);
    } else {
      Get.toNamed(RoutePaths.resetPasswordScreen);
    }
  }

  Future<void> verifyOtp(String otp) async {
    otpCode(otp.trim());
    isLoading.value = true;

    final response = await _authRemoteDatasource.verifyCode(
      countryCode: signUpData!.countryCode,
      code: otp,
      identifier: signUpData!.email ?? signUpData!.phone!,
    );
    response.fold(
      (l) {
        Get.find<AnalyticsService>().logEvent(
          functionName: 'verifyOtp',
          className: 'verify_otp_controller',
          parameters: {"error": l.message},
        );
        ToastUtils.showError(l.message);
      },
      (r) {
        if (r) {
          // await FirebaseMessaging.instance.deleteToken();
          //
          // locator<PageProvider>().setPage(PageNames.home);
          // nextRoute(MainPage.pageName, isClearBackRoutes: true, arguments: data['user_id']);

          _nextScreen();
        }
      },
    );

    isLoading.value = false;
  }

  // void resetPassword(String password) async {
  //   // password.trim();
  //   isResetingPassword.value = true;
  //   await Future.delayed(const Duration(seconds: 1));
  //   isResetingPassword.value = false;
  // }

  Future<void> resetPassword(String password) async {
    // password.trim();
    isResetingPassword.value = true;
    try {
      // if (identifier.value != null && !identifier.value!.startsWith("@")) {
      await _authRemoteDatasource.resetMobilePassword(
        identifier: signUpData!.email ?? signUpData!.phone!,
        password: password,
        countryCode: signUpData!.countryCode,
        otp: otpCode.value ?? "",
      );

      Get.back();
      Get.back();
      ToastUtils.showSuccess("passwordResetSuccess");
    } catch (e) {
      Get.find<AnalyticsService>().logEvent(
        functionName: 'resetPassword',
        className: 'verify_otp_controller',
        parameters: {
          "error": e.toString(),
          "password": password,
          "otp": otpCode.value ?? "",
        },
      );
      ToastUtils.showError(e.toString());
    }
    isResetingPassword.value = false;
  }

  void _startTimer() {
    secondsRemaining.value = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        _stopTimer();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    // secondsRemaining.value = 60;
  }

  void disableOtpView() {
    isOtpView.value = false;
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
