import 'dart:io';

import 'package:get/get.dart' hide Trans;
import '../../../../config/countries_list.dart';
import '../../../../core/errors/strings.dart';
import '../../../../core/network/network_mixin.dart';
import '../../../../core/services/analytics.service.dart';
import '../../../../core/utils/toast_utils.dart';
import '../../data/datasources/account_remote_datasource.dart';
import '../../data/models/countries_model.dart';
import '../../../shared/presentation/controllers/current_user_controller.dart';

class EditAccountController extends GetxController with NetworkMixin {
  final RxBool isLoading = false.obs;
  final tempAvatarPath = Rxn<String>();
  final selectedCountry = Country().obs;
  final _accountRemoteDatasource = Get.find<AccountRemoteDatasource>();
  final _currentUserController = Get.find<CurrentUserController>();

  final newsLetter = false.obs;

  void updateLoading(bool val) {
    isLoading.value = val;
  }

  void updateTempAvatarPath(String? path) {
    tempAvatarPath.value = path;
  }

  void updateUser(String name) async {
    if (!await isConnected) {
      return ToastUtils.showError(noInternetConnection);
    }
    updateLoading(true);
    final res = await _accountRemoteDatasource.updateAccount(
      name.trim(),
      newsLetter.value,
    );
    res.fold(
      (l) {
        Get.find<AnalyticsService>().logEvent(
          functionName: 'updateUSer',
          className: 'edit_account_controller',
          parameters: {
            "error": l.toString(),
            'message': l.message,
            'name': name,
          },
        );
        ToastUtils.showError(l.message);
      },
      (r) async {
        _currentUserController.setUser(
          _currentUserController.user!.copyWith(
            fullName: name,
            newsletter: newsLetter.value,
          ),
        );
        if (tempAvatarPath.value != null) {
          await updateUserImage();
        }
        ToastUtils.showSuccess("profileUpdatedSuccessfully");
      },
    );
    updateLoading(false);
  }

  Future<void> updateUserImage() async {
    if (!await isConnected) {
      return ToastUtils.showError(noInternetConnection);
    }
    // updateLoading(true);
    final res = await _accountRemoteDatasource.updateUserImage(
      File(tempAvatarPath.value!),
      null,
      null,
    );
    res.fold(
      (l) {
        ToastUtils.showError(l.message);
      },
      (r) {
        _currentUserController.getUser();

        // ToastUtils.showSuccess("passwordUpdatedSuccessfully");
      },
    );
    // updateLoading(false);
  }

  // void updatePassword(String oldPassword, String newPassword) async {
  //   if (!await isConnected) {
  //     return ToastUtils.showError(noInternetConnection);
  //   }
  //   updateLoading(true);
  //   final res = await _accountRemoteDatasource.updatePassword(
  //     oldPassword.trim(),
  //     newPassword.trim(),
  //   );
  //   res.fold((l) {
  //     ToastUtils.showError(l.message);
  //   }, (r) {
  //     ToastUtils.showSuccess("passwordUpdatedSuccessfully");
  //   });
  //   updateLoading(false);
  // }

  void updateTempCountry(String iso2) {
    final country = countriesList.firstWhere((c) => c.iso2 == iso2);
    selectedCountry.value = country;
  }
}
