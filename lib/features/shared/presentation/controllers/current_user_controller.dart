import 'package:get/get.dart';
import 'package:etqan_edu_app/features/account/data/models/profile_model.dart';
import '../../../../core/routes/route_paths.dart';
import '../../../../core/services/analytics.service.dart';
import '../../../../core/services/hive_services.dart';
import '../../data/datasources/shared_remote_datasources.dart';

import '../../../../main.dart';

class CurrentUserController extends GetxController {
  final _profile = Rxn<ProfileModel>(); // user for mobile
  final _hiveService = Get.find<HiveServices>();
  final _sharedRemoteDatasource = Get.find<SharedRemoteDatasources>();

  ProfileModel? get user => _profile.value;

  void setUser(ProfileModel user) {
    _profile.value = user;

    logger.e(_profile.toJson());
  }

  ProfileModel? get profile => _profile.value;

  setProfile(ProfileModel profile) {
    _profile.value = profile;
  }

  Future<void> getUser() async {
    final res = await _sharedRemoteDatasource.getUserData();
    res.fold(
      (l) {
        Get.offAllNamed(RoutePaths.login);
        Get.find<AnalyticsService>().logEvent(
          functionName: 'getUser',
          className: 'current_user_controller',
          parameters: {"error": l},
        );
      },
      (r) {
        setUser(r);
      },
    );
  }

  Future<void> logUserOut({bool withRemote = true}) async {
    if (withRemote) {
      await _sharedRemoteDatasource.logout();
    }
    _hiveService.clearPreferences();
    Get.offAllNamed(RoutePaths.login);
    Get.find<AnalyticsService>().logEvent(
      functionName: 'logUserOut',
      className: 'current_user_controller',
      parameters: {"function": 'logout'},
    );
  }
}
