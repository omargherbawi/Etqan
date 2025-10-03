import 'package:get/get.dart';
import '../data/datasources/auth_remote_datasource.dart';
import '../presentation/controllers/auth_controller.dart';

import '../presentation/controllers/auth_signup_controller.dart';
import '../presentation/controllers/verify_otp_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() => [
    Get.lazyPut<AuthController>(() => AuthController()),
    // Get.lazyPut<ResetPasswordController>(() => ResetPasswordController()),
    Get.put<AuthRemoteDatasource>(AuthRemoteDatasource(), permanent: true),
    Get.lazyPut<AuthSignupController>(
      () => AuthSignupController(),
      fenix: true,
    ),
    Get.lazyPut<VerifyOtpController>(() => VerifyOtpController(), fenix: true),
  ];
}
