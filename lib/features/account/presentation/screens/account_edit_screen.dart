import '../../../../core/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' hide Trans;
import '../../../../core/routes/route_paths.dart';
import '../../../../core/utils/shared.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_widget.dart';
import '../../../../core/widgets/loader.dart';
import '../../../../core/widgets/text_with_text_field.dart';
import '../controllers/edit_account_controller.dart';
import '../widgets/avatar_picker_widget.dart';
import '../../../shared/presentation/controllers/current_user_controller.dart';

class AccountEditScreen extends StatefulWidget {
  const AccountEditScreen({super.key});

  @override
  State<AccountEditScreen> createState() => _AccountEditScreenState();
}

class _AccountEditScreenState extends State<AccountEditScreen> {
  final _userController = Get.find<CurrentUserController>();
  final _accountController = Get.find<EditAccountController>();
  final _fullNameController = TextEditingController();
  // final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _usernameController = TextEditingController();
  final _selectedGender = ValueNotifier<String>("Male");
  final _selectedBirthday = ValueNotifier<String?>(null);

  @override
  void initState() {
    _fullNameController.text = _userController.user?.fullName ?? "";
    // _emailController.text = _userController.user?.email ?? "";
    _phoneController.text = _userController.user?.mobile ?? "";
    // _accountController.newsLetter.value =
    //     _userController.user?.newsletter ?? false;
    super.initState();
  }

  @override
  void dispose() {
    _accountController.updateTempAvatarPath(null);
    _fullNameController.dispose();
    // _emailController.dispose();
    _phoneController.dispose();
    _usernameController.dispose();
    _selectedBirthday.dispose();
    _selectedGender.dispose();
    super.dispose();
  }

  void _updateProfile() {
    _accountController.updateUser(_fullNameController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "yourProfile"),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: UIConstants.mobileBodyPadding,
          child: Column(
            children: [
              Center(child: AvatarPickerWidget(width: 120.w, height: 120.h)),

              // Image.asset(AssetPaths.appLogo, width: 200.w, height: 200.w),
              SizedBox(height: 14.h),
              // const CustomTextWidget(
              //   text: "changePicture",
              //   textThemeStyle: TextThemeStyleEnum.displaySmall,
              // ),
              SizedBox(height: 20.h),

              TextWithTextField(
                text: "fullName",
                hintText: "fullName",
                controller: _fullNameController,
                filled: true,
                fillColor: Get.theme.colorScheme.onSecondaryContainer,
                boldLabel: true,
              ),

              // TextWithTextField(
              //   text: "email",
              //   hintText: "email",
              //   controller: _emailController,
              //   filled: true,
              //   enabled: false,
              //   fillColor: Get.theme.colorScheme.onSecondaryContainer,
              //   boldLabel: true,
              // ),
              TextWithTextField(
                text: "phoneNumber",
                hintText: "phoneNumber",
                filled: true,
                enabled: false,
                boldLabel: true,
                // validator: (value) => phoneNumberValidator(value, context),
                fillColor: Get.theme.colorScheme.onSecondaryContainer,
                controller: _phoneController,
              ),
              // TextWithTextField(
              //   text: "username",
              //   hintText: "username",
              //   controller: _usernameController,
              //   filled: true,
              //   fillColor: Get.theme.colorScheme.onSecondaryContainer,
              //   boldLabel: true,
              // ),
              // AccountBirthdaySelection(
              //   onChanged: (value) {
              //     _selectedBirthday.value = value;
              //   },
              //   selectedBirthday: _selectedBirthday,
              // ),
              // GestureDetector(
              //   onTap: () {
              //     showModalBottomSheet(
              //       isScrollControlled: true,
              //       constraints: BoxConstraints(
              //         maxHeight: 0.9.sh,
              //         minWidth: 1.sw,
              //       ),
              //       context: context,
              //       builder: (context) {
              //         return const CountryScreen();
              //       },
              //     );
              //   },
              //   child: AbsorbPointer(
              //     absorbing: true,
              //     child: Obx(
              //       () {
              //         final selectedCountry = (_accountController.selectedCountry.value.name != null &&
              //                 _accountController.selectedCountry.value.flag != null)
              //             ? (Get.locale?.languageCode == "ar"
              //                 ? "${_accountController.selectedCountry.value.name_ar} ${_accountController.selectedCountry.value.flag}"
              //                 : "${_accountController.selectedCountry.value.name} ${_accountController.selectedCountry.value.flag}")
              //             : null;
              //
              //         return TextWithTextField(
              //           text: "country",
              //           controller: TextEditingController(
              //             text: selectedCountry ?? "",
              //           ),
              //           hintText: "country",
              //           suffix: Icon(
              //             Icons.arrow_forward_ios,
              //             size: 20.sp,
              //             color: Theme.of(context).colorScheme.inverseSurface,
              //           ),
              //         );
              //       },
              //     ),
              //   ),
              // ),
              // AccountGenderSelection(
              //   selectedGender: _selectedGender,
              //   onChanged: (value) {
              //     _selectedGender.value = value;
              //   },
              // ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(RoutePaths.accountResetPassword);
                },
                child: AbsorbPointer(
                  absorbing: true,
                  child: TextWithTextField(
                    filled: true,
                    fillColor: Get.theme.colorScheme.onSecondaryContainer,
                    boldLabel: true,
                    text: "password",
                    controller: TextEditingController(text: "*********"),
                    suffix: Icon(
                      Icons.arrow_forward_ios,
                      size: 20.sp,
                      color: Theme.of(context).colorScheme.inverseSurface,
                    ),
                  ),
                ),
              ),

              // Obx(() {
              //   return switchButton(
              //     "joinNewsletter",
              //     _accountController.newsLetter.value,
              //     (value) {
              //       _accountController.newsLetter.value = value;
              //     },
              //   );
              // }),

              // Switch(
              //   materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              //   trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
              //   value: value,
              //   onChanged: onChanged,
              //   activeColor: Get.theme.colorScheme.primary,
              //   inactiveThumbColor: Get.theme.colorScheme.onSurface,
              //   inactiveTrackColor: SharedColors.inActiveSwitchColor,
              // ),

              // switchButton(appText.joinNewsletter, newsletter, (value) {
              //   onTapChangeNewsletter(value);
              // }),
              SizedBox(height: 60.h),
            ],
          ),
        ),
      ),
      extendBody: true,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
        child: Obx(
          () => CustomButton(
            onPressed: _updateProfile,
            borderRadius: UIConstants.radius25,
            child:
                _accountController.isLoading.value
                    ? LoadingAnimation(color: Get.theme.colorScheme.onSurface)
                    : CustomTextWidget(
                      text: "updateProfile",
                      color: Get.theme.colorScheme.onSurface,
                      fontSize: Responsive.isTablet ? 10 : null,
                    ),
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:etqan_edu_app/core/enums/text_style_enum.dart';
// import 'package:etqan_edu_app/core/routes/route_paths.dart';
// import 'package:etqan_edu_app/core/utils/shared.dart';
// import 'package:etqan_edu_app/core/widgets/custom_appbar.dart';
// import 'package:etqan_edu_app/core/widgets/custom_button.dart';
// import 'package:etqan_edu_app/core/widgets/custom_text_widget.dart';
// import 'package:etqan_edu_app/core/widgets/loader.dart';
// import 'package:etqan_edu_app/core/widgets/text_with_text_field.dart';
// import 'package:etqan_edu_app/features/account/presentation/controllers/edit_account_controller.dart';
// import 'package:etqan_edu_app/features/account/presentation/screens/account_select_country.dart';
// import 'package:etqan_edu_app/features/account/presentation/widgets/account_birthday_selection.dart';
// import 'package:etqan_edu_app/features/account/presentation/widgets/account_gender_selection.dart';
// import 'package:etqan_edu_app/features/account/presentation/widgets/avatar_picker_widget.dart';
// import 'package:etqan_edu_app/features/shared/presentation/controllers/current_user_controller.dart';
//
// class AccountEditScreen extends StatefulWidget {
//   const AccountEditScreen({super.key});
//
//   @override
//   State<AccountEditScreen> createState() => _AccountEditScreenState();
// }
//
// class _AccountEditScreenState extends State<AccountEditScreen> {
//   final _userController = Get.find<CurrentUserController>();
//   final _accountController = Get.find<EditAccountController>();
//   final _fullNameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _usernameController = TextEditingController();
//   final _selectedGender = ValueNotifier<String>("Male");
//   final _selectedBirthday = ValueNotifier<String?>(null);
//
//   @override
//   void initState() {
//     _fullNameController.text = _userController.user.value?.fullName ?? "";
//     _emailController.text = _userController.user.value?.email ?? "";
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _accountController.updateTempAvatarPath(null);
//     _fullNameController.dispose();
//     _emailController.dispose();
//     _usernameController.dispose();
//     _selectedBirthday.dispose();
//     _selectedGender.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const CustomAppBar(
//         title: "editAcc",
//       ),
//       body: SingleChildScrollView(
//         padding: UIConstants.bodyPadding,
//         child: Column(
//           children: [
//             Center(child: AvatarPickerWidget()),
//             SizedBox(height: 14.h),
//             const CustomTextWidget(
//               text: "changePicture",
//               textThemeStyle: TextThemeStyleEnum.displaySmall,
//             ),
//             SizedBox(height: 20.h),
//             TextWithTextField(
//               text: "fullName",
//               hintText: "fullName",
//               controller: _fullNameController,
//             ),
//             TextWithTextField(
//               text: "email",
//               hintText: "email",
//               controller: _emailController,
//               suffix: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 6),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [],
//                 ),
//               ),
//             ),
//             TextWithTextField(
//               text: "username",
//               hintText: "username",
//               controller: _usernameController,
//             ),
//             AccountBirthdaySelection(
//               onChanged: (value) {
//                 _selectedBirthday.value = value;
//               },
//               selectedBirthday: _selectedBirthday,
//             ),
//             GestureDetector(
//               onTap: () {
//                 showModalBottomSheet(
//                   isScrollControlled: true,
//                   constraints: BoxConstraints(
//                     maxHeight: 0.9.sh,
//                     minWidth: 1.sw,
//                   ),
//                   context: context,
//                   builder: (context) {
//                     return const CountryScreen();
//                   },
//                 );
//               },
//               child: AbsorbPointer(
//                 absorbing: true,
//                 child: Obx(
//                   () {
//                     final selectedCountry = (_accountController.selectedCountry.value.name != null &&
//                             _accountController.selectedCountry.value.flag != null)
//                         ? (Get.locale?.languageCode == "ar"
//                             ? "${_accountController.selectedCountry.value.name_ar} ${_accountController.selectedCountry.value.flag}"
//                             : "${_accountController.selectedCountry.value.name} ${_accountController.selectedCountry.value.flag}")
//                         : null;
//
//                     return TextWithTextField(
//                       text: "country",
//                       controller: TextEditingController(
//                         text: selectedCountry ?? "",
//                       ),
//                       hintText: "country",
//                       suffix: Icon(
//                         Icons.arrow_forward_ios,
//                         size: 20.sp,
//                         color: Theme.of(context).colorScheme.inverseSurface,
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//             AccountGenderSelection(
//               selectedGender: _selectedGender,
//               onChanged: (value) {
//                 _selectedGender.value = value;
//               },
//             ),
//             GestureDetector(
//               onTap: () {
//                 Get.toNamed(RoutePaths.accountResetPassword);
//               },
//               child: AbsorbPointer(
//                 absorbing: true,
//                 child: TextWithTextField(
//                   text: "password",
//                   controller: TextEditingController(text: "*********"),
//                   suffix: Icon(
//                     Icons.arrow_forward_ios,
//                     size: 20.sp,
//                     color: Theme.of(context).colorScheme.inverseSurface,
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 60.h),
//           ],
//         ),
//       ),
//       extendBody: true,
//       bottomNavigationBar: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
//         child: Obx(
//           () => CustomButton(
//             onPressed: () {},
//             child: _accountController.isLoading.value
//                 ? const LoadingAnimation()
//                 : CustomTextWidget(
//                     text: "saveInfo",
//                     color: Theme.of(context).colorScheme.onSurface,
//                   ),
//           ),
//         ),
//       ),
//     );
//   }
// }
