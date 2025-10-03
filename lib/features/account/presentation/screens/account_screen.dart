import '../../../../config/config.dart';
import '../../../../core/core.dart';
import '../../../../core/routes/route_paths.dart';
import '../../../../core/services/url_launcher_service.dart';
import '../../../shared/presentation/controllers/current_user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../widgets/IconAndTextTile.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<CurrentUserController>();
    return Scaffold(
      appBar: const CustomAppBar(
        title: "myProfile",
        leading: SizedBox.shrink(),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: UIConstants.mobileBodyPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                // width: 100.w,
                // height: 100.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Get.theme.colorScheme.onSecondaryContainer,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                child: CustomAvatarWidget(
                  imageUrl: userController.user?.avatar,
                  height: 120.h,
                  width: 120.w,
                ),
              ),

              // // display user name
              SizedBox(height: 15.h),
              CustomTextWidget(
                text: userController.user?.fullName ?? "Not logged in",
                textThemeStyle: TextThemeStyleEnum.displayLarge,
              ),
              SizedBox(height: 20.h),

              // IconAndTextTTile(
              //   iconPath: AssetPaths.yourProfileSvg,
              //   text: "yourProfile",
              //   onTap: () => Get.toNamed(RoutePaths.accountEdit),
              // ),
              // if (Platform.isIOS) ...{
              //   const Divider(color: SharedColors.grayColor, thickness: 0.5),
              //   IconAndTextTTile(
              //     iconPath: AssetPaths.cashSvg,
              //     text: "restorePurchases",
              //     onTap: () => HelperFunctions.showRestoreDialog(context),
              //   ),
              // },

              // const Divider(color: SharedColors.grayColor, thickness: 0.5),
              // IconAndTextTTile(
              //   iconPath: AssetPaths.paymentMethodSvg,
              //   text: "Payment Methods",
              //   onTap: () => Get.toNamed(RoutePaths.paymentMethod),
              // ),
              const Divider(color: SharedColors.grayColor, thickness: 0.5),

              IconAndTextTTile(
                iconPath: AssetPaths.settingsSvg,
                text: "settings",
                onTap: () => Get.toNamed(RoutePaths.settings),
              ),
              const Divider(color: SharedColors.grayColor, thickness: 0.5),

              // IconAndTextTTile(
              //   icon: CupertinoIcons.settings,
              //   text: "giveReviewToCourse",
              //   onTap: () =>
              //       Get.toNamed(RoutePaths.giveReviewAboutCourseScreen),
              // ),
              // const Divider(color: SharedColors.grayColor, thickness: 0.5),

              // IconAndTextTTile(
              //   icon: CupertinoIcons.settings,
              //   text: "giveReviewToMentor",
              //   onTap: () => Get.toNamed(RoutePaths.giveReviewAboutMentorScreen),
              // ),

              // IconAndTextTTile(
              //   iconPath: AssetPaths.yourProfileSvg,
              //   text: "shareApp",
              //   onTap: () async {
              //     final result = await Share.share('Check this app, it is good for learning');
              //
              //     if (result.status == ShareResultStatus.success) {
              //       logSuccess('Thank you for sharing Qout!');
              //     }
              //   },
              // ),

              // const Divider(color: SharedColors.grayColor, thickness: 0.5),
              // IconAndTextTTile(
              //   iconPath: AssetPaths.helpCenterSvg,
              //   text: "helpCenter",
              //   onTap: () => Get.toNamed(RoutePaths.helpCenterSearch),
              // ),
              IconAndTextTTile(
                iconPath: AssetPaths.infoSvg,
                text: "abouttedreeb",
                onTap: () {
                  LaunchUrlService.openWeb(
                    context,
                    "https://tedreeb.com/pages/about",
                  );
                },
              ),
              const Divider(color: SharedColors.grayColor, thickness: 0.5),
              IconAndTextTTile(
                iconPath: AssetPaths.privacyPolicySvg,
                text: "privacyPolicy",
                onTap: () {
                  LaunchUrlService.openWeb(
                    context,
                    "https://tedreeb.com/pages/privacy-policy",
                  );
                },
              ),
              const Divider(color: SharedColors.grayColor, thickness: 0.5),
              IconAndTextTTile(
                iconPath: AssetPaths.logoutSvg,
                text: "logOut",
                onTap: () => HelperFunctions.showLogoutDialog(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


