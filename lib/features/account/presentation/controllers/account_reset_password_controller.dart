import 'package:get/get.dart' hide Trans;
import '../../../../core/errors/strings.dart';
import '../../../../core/network/network_mixin.dart';
import '../../../../core/services/analytics.service.dart';
import '../../../../core/utils/toast_utils.dart';
import '../../data/datasources/account_remote_datasource.dart';

class AccountResetPasswordController extends GetxController with NetworkMixin {
  final RxBool isLoading = false.obs;
  final _accountRemoteDatasource = Get.find<AccountRemoteDatasource>();

  void updateLoading(bool val) {
    isLoading.value = val;
  }

  void updatePassword(String oldPassword, String newPassword) async {
    if (!await isConnected) {
      return ToastUtils.showError(noInternetConnection);
    }
    updateLoading(true);
    final res = await _accountRemoteDatasource.updatePassword(
      oldPassword.trim(),
      newPassword.trim(),
    );
    res.fold(
      (l) {
        Get.find<AnalyticsService>().logEvent(
          functionName: 'updatePassword',
          className: 'account_reset_pas_controller',
          parameters: {
            "error": l.toString(),
            'message': l.message,
            'oldPassword': oldPassword,
            'newPassword': newPassword,
          },
        );
        ToastUtils.showError(l.message);
      },

      (r) {
        ToastUtils.showSuccess("passwordUpdateDesc");
      },
    );

    updateLoading(false);
  }
}
