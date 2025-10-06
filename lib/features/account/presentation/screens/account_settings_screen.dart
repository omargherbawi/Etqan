import '../../../../config/config.dart';
import '../../../../core/core.dart';
import '../controllers/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/IconAndTextTile.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsController = Get.find<SettingsController>();

    return Scaffold(
      appBar: const CustomAppBar(title: "settings"),
      body: SingleChildScrollView(
        padding: UIConstants.mobileBodyPadding,
        child:
        // Obx(() {
        //   return
        Column(
          children: [
            // _buildHeaderRow(
            //   icon: Icons.language,
            //   text: "appLanguage",
            // ),
            // SizedBox(height: 15.h),
            // const LanguageWidget(),
            // SizedBox(height: 25.h),
            // IconAndTextSwitch(
            //   iconPath: AssetPaths.theme,
            //   text: "darkTheme",
            //   value: themeController.themeMode.value == ThemeMode.dark,
            //   onChanged: themeController.toggleThemeToDark,
            // ),
            // const Divider(color: SharedColors.grayColor, thickness: 0.5),

            // IconAndTextTTile(
            //   iconPath: AssetPaths.yourProfileSvg,
            //   text: "notificationSettings",
            //   onTap: () => Get.toNamed(RoutePaths.accountResetPassword),
            // ),
            Obx(() {
              return SwitchButton(
                iconPath: AssetPaths.yourProfileSvg,
                text: "allowNotifications",
                state: settingsController.notificationEnabled.value,
                onChangeState: (value) {
                  settingsController.changeNotificationStatus(value);
                },
                loading: settingsController.changingNotificationStatus.value,
              );
            }),

            const Divider(color: SharedColors.grayColor, thickness: 0.5),

            // IconAndTextTTile(
            //   iconPath: AssetPaths.passwordManagerSvg,
            //   text: "passwordManager",
            //   onTap: () => Get.toNamed(RoutePaths.accountResetPassword),
            // ),
            // const Divider(color: SharedColors.grayColor, thickness: 0.5),
            IconAndTextTTile(
              iconPath: AssetPaths.deleteAccountSvg,
              text: "deleteAcc",
              onTap: () => HelperFunctions.showDeleteDialog(context),
            ),
            const Divider(color: SharedColors.grayColor, thickness: 0.5),

            // IconAndTextSwitch(
            //   icon: Icons.notifications,
            //   text: "dailyReminderCollectCoins",
            //   value:
            //       settingsController.dailyCoinsCollectionReminder.value,
            //   onChanged:
            //       settingsController.toggleDailyCoinsCollectionReminder,
            // ),
            // const Divider(color: SharedColors.grayColor, thickness: 0.5),
            // IconAndTextSwitch(
            //   icon: Icons.notifications,
            //   text: "newQuizReminder",
            //   value: settingsController.newQuizReminder.value,
            //   onChanged: settingsController.toggleNewQuizReminder,
            // ),
            // const Divider(color: SharedColors.grayColor, thickness: 0.5),
            // IconAndTextSwitch(
            //   icon: Icons.visibility_off,
            //   text: "hideMeInLeaderboard",
            //   value: settingsController.hideMeInLeaderboard.value,
            //   onChanged: settingsController.toggleHideMeInLeaderboard,
            // ),
            // const Divider(color: SharedColors.grayColor, thickness: 0.5),
            // IconAndTextSwitch(
            //   icon: Icons.vibration,
            //   text: "vibrateOnWrongAnswer",
            //   value: settingsController.vibrateOnWrongAnswer.value,
            //   onChanged: settingsController.toggleVibrateOnWrongAnswer,
            // ),
            // const Divider(color: SharedColors.grayColor, thickness: 0.5),
            // const IconAndTextTTile(
            //   icon: Icons.restore,
            //   text: "restorePurchases",
            // ),
            // const Divider(color: SharedColors.grayColor, thickness: 0.5),
            // const IconAndTextTTile(
            //   icon: CupertinoIcons.delete_solid,
            //   text: "deleteAcc",
            //   iconColor: SharedColors.redColor,
            // ),
          ],
        ),
        // }),
      ),
    );
  }
}

// import 'dart:io';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:etqan_edu_app/config/app_colors.dart';
// import 'package:etqan_edu_app/config/asset_paths.dart';
// import 'package:etqan_edu_app/core/enums/text_style_enum.dart';
// import 'package:etqan_edu_app/core/routes/route_paths.dart';
// import 'package:etqan_edu_app/core/utils/helper_functions.dart';
// import 'package:etqan_edu_app/core/utils/shared.dart';
// import 'package:etqan_edu_app/core/widgets/custom_appbar.dart';
// import 'package:etqan_edu_app/core/widgets/custom_text_widget.dart';
// import 'package:etqan_edu_app/features/account/presentation/controllers/settings_controller.dart';
// import 'package:etqan_edu_app/features/account/presentation/screens/account_faq_screen.dart';
// import 'package:etqan_edu_app/features/account/presentation/widgets/language_widget.dart';
// import 'package:etqan_edu_app/features/account/presentation/widgets/settings_row_widget.dart';
// import 'package:etqan_edu_app/features/shared/presentation/controllers/app_theme_controller.dart';
//
// class AccountSettingsScreen extends StatelessWidget {
//   const AccountSettingsScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final settingsController = Get.find<SettingsController>();
//
//     return Scaffold(
//       appBar: const CustomAppBar(
//         title: "settings",
//       ),
//       body: SingleChildScrollView(
//         padding: UIConstants.bodyPadding.copyWith(top: 0),
//         child: Card(
//           color: Theme.of(context).colorScheme.onSurface,
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 18.h),
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     Icon(Icons.language, size: 24.w),
//                     SizedBox(width: 12.w),
//                     const CustomTextWidget(
//                       text: "appLanguage",
//                       textThemeStyle: TextThemeStyleEnum.displaySmall,
//                       fontWeight: FontWeight.w700,
//                       color: Colors.black,
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 15.h),
//                 const LanguageWidget(),
//                 SizedBox(height: 25.h),
//                 Obx(
//                   () {
//                     final themeController = Get.find<ThemeController>();
//                     return SettingsRowWidget(
//                       leadingWidget: SvgPicture.asset(
//                         AssetPaths.theme,
//                         height: 25.w,
//                         width: 25.w,
//                       ),
//                       text: "darkTheme",
//                       trailingWidget: Switch(
//                         materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                         trackOutlineColor:
//                             const WidgetStatePropertyAll(Colors.transparent),
//                         value:
//                             themeController.themeMode.value == ThemeMode.dark,
//                         onChanged: (value) {
//                           themeController.toggleThemeToDark(value);
//                         },
//                         activeColor: Theme.of(context).colorScheme.primary,
//                         inactiveThumbColor: Theme.of(context).colorScheme.onSurface,
//                         inactiveTrackColor: SharedColors.inActiveSwitchColor,
//                       ),
//                     );
//                   },
//                 ),
//                 SizedBox(height: 17.h),
//                 Obx(
//                   () {
//                     return SettingsRowWidget(
//                       leadingWidget: Icon(
//                         Icons.notifications,
//                         size: 25.w,
//                       ),
//                       text: "dailyReminderCollectCoins",
//                       trailingWidget: Switch(
//                         materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                         trackOutlineColor:
//                             const WidgetStatePropertyAll(Colors.transparent),
//                         value: settingsController
//                             .dailyCoinsCollectionReminder.value,
//                         onChanged: (value) {
//                           settingsController
//                               .toggleDailyCoinsCollectionReminder(value);
//                         },
//                         activeColor: Theme.of(context).colorScheme.primary,
//                         inactiveThumbColor: Theme.of(context).colorScheme.onSurface,
//                         inactiveTrackColor: SharedColors.inActiveSwitchColor,
//                       ),
//                     );
//                   },
//                 ),
//                 SizedBox(height: 17.h),
//                 Obx(
//                   () {
//                     return SettingsRowWidget(
//                       leadingWidget: Icon(
//                         Icons.notifications,
//                         size: 25.w,
//                       ),
//                       text: "newQuizReminder",
//                       trailingWidget: Switch(
//                         materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                         trackOutlineColor:
//                             const WidgetStatePropertyAll(Colors.transparent),
//                         value: settingsController.newQuizReminder.value,
//                         onChanged: (value) {
//                           settingsController.toggleNewQuizReminder(value);
//                         },
//                         activeColor: Theme.of(context).colorScheme.primary,
//                         inactiveThumbColor: Theme.of(context).colorScheme.onSurface,
//                         inactiveTrackColor: SharedColors.inActiveSwitchColor,
//                       ),
//                     );
//                   },
//                 ),
//                 SizedBox(height: 17.h),
//                 Obx(
//                   () {
//                     return SettingsRowWidget(
//                       leadingWidget: Icon(
//                         Icons.visibility_off,
//                         size: 25.w,
//                       ),
//                       text: "hideMeInLeaderboard",
//                       trailingWidget: Switch(
//                         materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                         trackOutlineColor:
//                             const WidgetStatePropertyAll(Colors.transparent),
//                         value: settingsController.hideMeInLeaderboard.value,
//                         onChanged: (value) {
//                           settingsController.toggleHideMeInLeaderboard(value);
//                         },
//                         activeColor: Theme.of(context).colorScheme.primary,
//                         inactiveThumbColor: Theme.of(context).colorScheme.onSurface,
//                         inactiveTrackColor: SharedColors.inActiveSwitchColor,
//                       ),
//                     );
//                   },
//                 ),
//                 SizedBox(height: 17.h),
//                 Obx(
//                   () {
//                     return SettingsRowWidget(
//                       leadingWidget: Icon(
//                         Icons.vibration,
//                         size: 25.w,
//                       ),
//                       text: "vibrateOnWrongAnswer",
//                       trailingWidget: Switch(
//                         materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                         trackOutlineColor:
//                             const WidgetStatePropertyAll(Colors.transparent),
//                         value: settingsController.vibrateOnWrongAnswer.value,
//                         onChanged: (value) {
//                           settingsController.vibrateOnWrongAnswer(value);
//                         },
//                         activeColor: Theme.of(context).colorScheme.primary,
//                         inactiveThumbColor: Theme.of(context).colorScheme.onSurface,
//                         inactiveTrackColor: SharedColors.inActiveSwitchColor,
//                       ),
//                     );
//                   },
//                 ),
//                 SizedBox(height: 17.h),
//                 SettingsRowWidget(
//                   leadingWidget: SvgPicture.asset(
//                     AssetPaths.noAds,
//                     width: 25.w,
//                     height: 25.w,
//                   ),
//                   text: "removeAdsWithPoints",
//                   trailingWidget: Icon(
//                     Icons.arrow_forward_ios,
//                     size: 24.w,
//                     color: SharedColors.greyTextColor,
//                   ),
//                 ),
//                 SizedBox(height: 17.h),
//                 SettingsRowWidget(
//                   onTap: () {
//                     Get.toNamed(RoutePaths.categories);
//                   },
//                   leadingWidget: const Icon(Icons.star_rounded),
//                   text: "favCategories",
//                   trailingWidget: Icon(
//                     Icons.arrow_forward_ios,
//                     size: 24.w,
//                     color: SharedColors.greyTextColor,
//                   ),
//                 ),
//                 SizedBox(height: 17.h),
//                 SettingsRowWidget(
//                   onTap: () {
//                     Get.to(() => const AccountFaqScreen());
//                   },
//                   leadingWidget: SvgPicture.asset(
//                     AssetPaths.faq,
//                     height: 25.w,
//                     width: 25.w,
//                   ),
//                   text: "faq",
//                   trailingWidget: Icon(
//                     Icons.arrow_forward_ios,
//                     size: 24.w,
//                     color: SharedColors.greyTextColor,
//                   ),
//                 ),
//                 SizedBox(height: 17.h),
//                 SettingsRowWidget(
//                   leadingWidget: Icon(
//                     Platform.isIOS ? CupertinoIcons.share : Icons.share,
//                   ),
//                   text: "shareApp",
//                   trailingWidget: Icon(
//                     Icons.arrow_forward_ios,
//                     size: 24.w,
//                     color: SharedColors.greyTextColor,
//                   ),
//                 ),
//                 SizedBox(height: 17.h),
//                 SettingsRowWidget(
//                   leadingWidget: const Icon(Icons.restore),
//                   text: "restorePurchases",
//                   trailingWidget: Icon(
//                     Icons.arrow_forward_ios,
//                     size: 24.w,
//                     color: SharedColors.greyTextColor,
//                   ),
//                 ),
//                 SizedBox(height: 17.h),
//                 SettingsRowWidget(
//                   leadingWidget: const Icon(
//                     CupertinoIcons.delete_solid,
//                     color: SharedColors.redColor,
//                   ),
//                   text: "deleteAcc",
//                   trailingWidget: Icon(
//                     Icons.arrow_forward_ios,
//                     size: 24.w,
//                     color: SharedColors.greyTextColor,
//                   ),
//                 ),
//                 SizedBox(height: 17.h),
//                 SettingsRowWidget(
//                   leadingWidget: const Icon(
//                     Icons.mail,
//                   ),
//                   text: "contactUs",
//                   trailingWidget: Icon(
//                     Icons.arrow_forward_ios,
//                     size: 24.w,
//                     color: SharedColors.greyTextColor,
//                   ),
//                 ),
//                 SizedBox(height: 17.h),
//                 SettingsRowWidget(
//                   onTap: () => HelperFunctions.showLogoutDialog(context),
//                   leadingWidget: const Icon(
//                     Icons.logout,
//                   ),
//                   text: "logout",
//                   trailingWidget: Icon(
//                     Icons.arrow_forward_ios,
//                     size: 24.w,
//                     color: SharedColors.greyTextColor,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
