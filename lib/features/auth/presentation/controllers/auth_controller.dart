import '../../../../config/notification.dart';
import '../../../../core/routes/route_paths.dart';
import '../../../../core/services/analytics.service.dart';
import '../../../../core/utils/toast_utils.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/models/register_config_model.dart';
import '../../../shared/presentation/controllers/current_user_controller.dart';
import 'package:country_picker/country_picker.dart' as country_picker;
import 'package:get/get.dart';

import '../../../../main.dart';

class AuthController extends GetxController {
  final isLoading = false.obs;
  final isSignupLoading = false.obs;
  final _authRemoteDatasource = Get.find<AuthRemoteDatasource>();
  final _currentUserController = Get.find<CurrentUserController>();
  RegisterConfigModel? registerConfig;

  final selectedCountry = country_picker.Country(
    phoneCode: '962',
    countryCode: 'JO',
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: 'Jordan',
    example: 'Jordan',
    displayName: 'Jordan (الأردن)',
    displayNameNoCountryCode: 'Jordan (الأردن)',
    e164Key: '962-JO-0',
  ).obs;

  void updateLoginLoading(bool val) {
    isLoading.value = val;
  }

  void updateSignupLoading(bool val) {
    isSignupLoading.value = val;
  }

  void updateSelectedCountry(country_picker.Country country) {
    selectedCountry.value = country;
  }

  Future<void> login({
    required String identifier,
    required String password,
  }) async {
    updateLoginLoading(true);
    final res = await _authRemoteDatasource.login(
      identifier,
      password,
      '+${selectedCountry.value.phoneCode}',
    );

    res.fold(
      (l) {
        logger.e("Login Msg: ${l.message}");
        Get.find<AnalyticsService>().logEvent(
          functionName: 'login',
          className: 'auth_controller',
          parameters: {
            "error": l.message,
            "identifier": identifier,
            'password': password,
            'country': '+${selectedCountry.value.phoneCode}',
          },
        );
        ToastUtils.showError(l.message);
      },
      (r) async {
        _currentUserController.setUser(r);
        NotificationService().notificationInitializer();

        Get.offAllNamed(RoutePaths.navScreen);
      },
    );
    updateLoginLoading(false);
  }
}
