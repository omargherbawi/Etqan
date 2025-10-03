import '../presentation/controllers/account_reset_password_controller.dart';
import 'package:get/get.dart';

class AccountResetPasswordBinding extends Bindings {
  @override
  void dependencies() => [
    Get.lazyPut<AccountResetPasswordController>(
      () => AccountResetPasswordController(),
    ),
  ];
}
