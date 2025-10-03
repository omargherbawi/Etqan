import 'dart:developer';

import '../../../../config/config.dart';
import '../../../../config/notification.dart';
import '../../../../core/routes/route_paths.dart';
import '../../../../core/services/hive_services.dart';
import '../../../../core/utils/force_update_state.dart';
import '../../../../core/utils/toast_utils.dart';
import '../controllers/app_controller.dart';
import '../controllers/current_user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' hide Trans;

class UserState extends StatefulWidget {
  const UserState({super.key});

  @override
  State<UserState> createState() => _UserStateState();
}

class _UserStateState extends State<UserState> {
  final _localStorage = Get.find<HiveServices>();
  final appController = Get.find<AppController>();

  void isReviewing() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // appController.fetchIsReviewing();
    });
  }

  @override
  void initState() {
    checkUserState();
    super.initState();
  }

  void checkUserState() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchData();
    });
  }

  Future<void> fetchData() async {
    // Here we validate if onboarding has been shown or not, if not then move to it, otherwise move to login screen
    // if (!_localStorage.getIsOnBoardingShown() && !isDesktop) {
    //   Get.offAllNamed(RoutePaths.onboarding);
    //   return;
    // }

    if (_localStorage.getToken == null) {
      await Future.delayed(const Duration(seconds: 1));

      // Check if force update is active
      if (ForceUpdateState.isForceUpdateActive) {
        // Don't navigate if force update dialog is active
        return;
      }

      Get.offAllNamed(RoutePaths.login);

      return;
    }

    await Future.wait([Get.find<CurrentUserController>().getUser()])
        .then((_) {
          NotificationService().notificationInitializer();
          Get.offAllNamed(RoutePaths.navScreen);

          return;
        })
        .onError((e, stackTrace) {
          log(stackTrace.toString());
          Get.offAllNamed(RoutePaths.login);
          ToastUtils.showError("errorOccuredPleaseCloseTheAppAndTryAgain $e");
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RepaintBoundary(
            child: Image.asset(
              AssetPaths.appLogo,
              width: 200.w,
            ).animate().shimmer(duration: 900.ms),
          ),

          const SizedBox(width: double.infinity),
        ],
      ),
    );
  }
}
