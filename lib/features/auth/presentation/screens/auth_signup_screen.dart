import 'package:easy_localization/easy_localization.dart';

import '../../../../core/routes/route_paths.dart';
import '../../../../core/services/url_launcher_service.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart' hide Trans;
import '../../../../config/config.dart';
import '../../../../core/core.dart';
import '../../../../core/utils/console_log_functions.dart';
import '../../../../core/validators/general_validations.dart';
import '../../data/models/country_code_model.dart';
import '../controllers/auth_signup_controller.dart';

class AuthSignupScreen extends StatefulWidget {
  const AuthSignupScreen({super.key});

  @override
  State<AuthSignupScreen> createState() => _AuthSignupScreenState();
}

class _AuthSignupScreenState extends State<AuthSignupScreen>
    with SingleTickerProviderStateMixin {
  final _fullNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  late TabController _tabController;

  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool _showPass = false;
  bool _showConfirmPass = false;
  final _signupController = Get.find<AuthSignupController>();
  String accountType = 'user';
  String? otherRegisterMethod;

  late CountryCode countryCode;
  final signupController = Get.find<AuthSignupController>();

  FocusNode phoneNode = FocusNode();
  bool isParent = false;

  @override
  void initState() {
    super.initState();
    countryCode = CountryCode(code: "SY", dialCode: "+963", name: "syria");
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      logInfo("_tabController.index: ${_tabController.index}");

      if (_tabController.index == 1 && !isParent) {
        isParent = true;
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: CustomTextWidget(
                  text: 'confirmation',
                  textThemeStyle: TextThemeStyleEnum.titleLarge,
                  color: Get.theme.colorScheme.inverseSurface,
                ),
                content: CustomTextWidget(
                  text: 'thisIsParentAccount',
                  textThemeStyle: TextThemeStyleEnum.titleSmall,
                  color: Get.theme.colorScheme.inverseSurface,
                  maxLines: 4,
                ),
                actions: [
                  CustomTextButton(
                    text: "close",
                    onTap: () {
                      Get.back();
                    },
                  ),
                ],
              ),
        );
      } else if (_tabController.index == 0) {
        setState(() {
          isParent = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(() {});
    _tabController.dispose();
    _fullNameController.dispose();
    _passwordController.dispose();
    phoneController.dispose();
    _confirmPasswordController.dispose();
    _confirmPasswordFocusNode.dispose();
    _passwordFocusNode.dispose();

    super.dispose();
  }

  void _signupAction() async {
    if (_signupController.isLoading.value) {
      return;
    }

    if (!_formKey.currentState!.validate()) {
      ToastUtils.showError("pleaseFillAllFields");
      return;
    }

    if (_signupController.agreeWithTerms.value == false) {
      ToastUtils.showError("pleaseAcceptTermsAndConditions");

      return;
    }

    await _signupController.signupWithPhone(
      fullName: _fullNameController.text,
      phone: phoneController.text.trim(),
      dialCode: '+${_signupController.selectedCountry.value.phoneCode}',
      password: _passwordController.text,
      accountType: isParent == true ? "parent" : "user",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Padding(
            padding: UIConstants.desktopBody,
            child: Column(
              children: [
                Gap(30.h),
                Obx(
                  () => Stack(
                    children: [
                      CircleIconButton(
                        icon: Icons.arrow_back,
                        iconColor: Get.theme.colorScheme.inverseSurface,
                        onPressed: () {
                          Get.back();
                        },
                        greyBackground: false,
                      ),
                      Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Gap(30.h),

                            const Center(
                              child: CustomTextWidget(
                                text: "createAccount",
                                // color: Theme.of(context).colorScheme.primary,
                                textThemeStyle:
                                    TextThemeStyleEnum.headlineMedium,
                              ),
                            ),
                            Gap(5.h),
                            Center(
                              child: CustomTextWidget(
                                text: "fillYourInformationBelowToRegister",
                                color: Get.theme.colorScheme.tertiaryContainer,
                                textThemeStyle: TextThemeStyleEnum.bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                            ),

                            // Gap(30.h),
                            // Center(child: AuthAvatarPicker()),
                            // CustomTabbarWidget(
                            //   controller: _tabController,
                            //   allowPadding: false,
                            //   tabs: [
                            //     'student'.tr(context: context),
                            //     'parent'.tr(context: context),
                            //   ],
                            // ),
                            Gap(5.h),
                            TextWithTextField(
                              validator: (value) => isNotEmpty(value, context),
                              text: "name",
                              hintText: "name",
                              filled: true,
                              fillColor:
                                  Get.theme.colorScheme.onSecondaryContainer,
                              boldLabel: true,
                              controller: _fullNameController,
                            ),
                            Gap(5.h),

                            // GestureDetector(
                            //   onTap: () {
                            //     HelperFunctions.showCustomModalBottomSheet(
                            //       isScrollControlled: true,
                            //       context: context,
                            //       child: Column(
                            //         mainAxisSize: MainAxisSize.min,
                            //         children: List.generate(
                            //           _signupController.governorateList.length,
                            //           (index) {
                            //             final governorate =
                            //                 _signupController
                            //                     .governorateList[index];
                            //             return Padding(
                            //               padding: EdgeInsets.symmetric(
                            //                 vertical: 8.0.h,
                            //               ),
                            //               child: GestureDetector(
                            //                 onTap: () {
                            //                   _signupController
                            //                       .updateSelectedGovernorate(
                            //                         governorate,
                            //                       );
                            //                   Get.close(1);
                            //                 },
                            //                 child: CustomTextWidget(
                            //                   text: governorate.arName ?? '',
                            //                 ),
                            //               ),
                            //             );
                            //           },
                            //         ),
                            //       ),
                            //     );
                            //   },
                            //   child: AbsorbPointer(
                            //     absorbing: true,
                            //     child: TextWithTextField(
                            //       enabled: false,
                            //       // validator: (value) => isNotEmpty(value, context),
                            //       text: "governorate",

                            //       suffix: const Icon(
                            //         Icons.keyboard_arrow_down_sharp,
                            //         color: Colors.black,
                            //       ),
                            //       hintText: "selectGovernorate",
                            //       filled: true,
                            //       fillColor:
                            //           Get
                            //               .theme
                            //               .colorScheme
                            //               .onSecondaryContainer,
                            //       boldLabel: true,
                            //       controller: TextEditingController(
                            //         text:
                            //             _signupController
                            //                 .selectedGovernorate
                            //                 .value
                            //                 ?.arName ??
                            //             "",
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            Gap(5.h),
                            GestureDetector(
                              onTap: () {
                                HelperFunctions.showCustomModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: List.generate(
                                      _signupController.programList.length,
                                      (index) {
                                        final major =
                                            _signupController
                                                .programList[index];
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 8.0.h,
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              _signupController
                                                  .updateSelectedMajor(major);
                                              Get.close(1);
                                            },
                                            child: CustomTextWidget(
                                              text: major.arName ?? '',
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                              child: AbsorbPointer(
                                absorbing: true,
                                child: TextWithTextField(
                                  enabled: false,

                                  // validator: (value) => isNotEmpty(value, context),
                                  text: "yourStudyStage",

                                  suffix: const Icon(
                                    Icons.keyboard_arrow_down_sharp,
                                    color: Colors.black,
                                  ),
                                  hintText: "chooseYourStudyStage",
                                  filled: true,
                                  fillColor:
                                      Get
                                          .theme
                                          .colorScheme
                                          .onSecondaryContainer,
                                  boldLabel: true,
                                  controller: TextEditingController(
                                    text:
                                        _signupController
                                            .selectedProgram
                                            .value
                                            ?.arName ??
                                        "",
                                  ),
                                ),
                              ),
                            ),
                            Gap(5.h),

                            // GestureDetector(
                            //   onTap: () {
                            //     if (_signupController.selectedProgram.value ==
                            //         null) {
                            //       ToastUtils.showError("chooseYourClassFirst");
                            //       return;
                            //     }
                            //     HelperFunctions.showCustomModalBottomSheet(
                            //       isScrollControlled: true,
                            //       context: context,
                            //       child: Column(
                            //         mainAxisSize: MainAxisSize.min,
                            //         children: List.generate(
                            //           _signupController.filteredClasses.length,
                            //           (index) {
                            //             final selectedClass =
                            //                 _signupController
                            //                     .filteredClasses[index];
                            //             return Padding(
                            //               padding: EdgeInsets.symmetric(
                            //                 vertical: 8.0.h,
                            //               ),
                            //               child: GestureDetector(
                            //                 onTap: () {
                            //                   _signupController
                            //                       .updateSelectedSubject(
                            //                         selectedClass,
                            //                       );
                            //                   Get.close(1);
                            //                 },
                            //                 child: CustomTextWidget(
                            //                   text: selectedClass.arName ?? '',
                            //                 ),
                            //               ),
                            //             );
                            //           },
                            //         ),
                            //       ),
                            //     );
                            //   },
                            //   child: AbsorbPointer(
                            //     absorbing: true,
                            //     child: TextWithTextField(
                            //       enabled: false,

                            //       // validator: (value) => isNotEmpty(value, context),
                            //       text: "class",

                            //       suffix: const Icon(
                            //         Icons.keyboard_arrow_down_sharp,
                            //         color: Colors.black,
                            //       ),
                            //       hintText: "chooseYourClass",
                            //       filled: true,
                            //       fillColor:
                            //           Get
                            //               .theme
                            //               .colorScheme
                            //               .onSecondaryContainer,
                            //       boldLabel: true,
                            //       controller: TextEditingController(
                            //         text:
                            //             _signupController
                            //                 .selectedClass
                            //                 .value
                            //                 ?.arName ??
                            //             "",
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            Gap(5.h),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomTextWidget(
                                  text: 'phoneNumber',
                                  fontWeight: FontWeight.w400,
                                  color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.inverseSurface,
                                  textThemeStyle: TextThemeStyleEnum.bodyMedium,
                                ),
                                Gap(5.h),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Obx(() {
                                      final selectedCountry =
                                          _signupController
                                              .selectedCountry
                                              .value;
                                      return GestureDetector(
                                        onTap: () {
                                          showCountryPicker(
                                            context: context,
                                            showPhoneCode: false,
                                            favorite: ['SY', 'TR', 'US', 'LU'],
                                            countryListTheme: CountryListThemeData(
                                              bottomSheetHeight: 700.h,
                                              backgroundColor: Colors.white,
                                              flagSize: 25.sp,
                                              borderRadius:
                                                  BorderRadius.circular(18.r),
                                              textStyle: TextStyle(
                                                fontSize: 16.sp,
                                              ),
                                              inputDecoration: InputDecoration(
                                                hintText: 'Search'.tr(),
                                                hintStyle: TextStyle(
                                                  color: Get
                                                      .theme
                                                      .colorScheme
                                                      .inverseSurface
                                                      .withOpacity(0.6),
                                                ),
                                                filled: true,
                                                fillColor:
                                                    Get
                                                        .theme
                                                        .colorScheme
                                                        .onSecondaryContainer,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                      horizontal: 16.w,
                                                      vertical: 12.h,
                                                    ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        UIConstants.radius12,
                                                      ),
                                                  borderSide: BorderSide.none,
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            UIConstants
                                                                .radius12,
                                                          ),
                                                      borderSide:
                                                          BorderSide.none,
                                                    ),

                                                prefixIcon: Icon(
                                                  Icons.search,
                                                  color: Get
                                                      .theme
                                                      .colorScheme
                                                      .inverseSurface
                                                      .withOpacity(0.6),
                                                ),
                                              ),
                                            ),
                                            onSelect: (Country country) {
                                              _signupController
                                                  .updateSelectedCountry(
                                                    country,
                                                  );
                                            },
                                          );
                                        },
                                        child: Container(
                                          width: 60.w,
                                          height: 48.h,
                                          decoration: BoxDecoration(
                                            color:
                                                Get
                                                    .theme
                                                    .colorScheme
                                                    .onSecondaryContainer,
                                            borderRadius: BorderRadius.circular(
                                              UIConstants.radius12,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                selectedCountry.flagEmoji,
                                                style: TextStyle(
                                                  fontSize: 20.sp,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                                    Gap(10.w),
                                    Expanded(
                                      child: TextWithTextField(
                                        text: "phoneNumber",
                                        hintText: "phoneNumber",
                                        filled: true,
                                        hideLabel: true,
                                        validator:
                                            (value) => phoneNumberValidator(
                                              value,
                                              context,
                                            ),
                                        fillColor:
                                            Get
                                                .theme
                                                .colorScheme
                                                .onSecondaryContainer,
                                        controller: phoneController,
                                        onFieldSubmitted: (_) {
                                          FocusScope.of(
                                            context,
                                          ).requestFocus(_passwordFocusNode);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Gap(5.h),
                            TextWithTextField(
                              validator:
                                  (value) => passwordValidator(value, context),
                              text: "password",
                              hintText: "password",
                              filled: true,
                              fillColor:
                                  Get.theme.colorScheme.onSecondaryContainer,
                              boldLabel: true,
                              controller: _passwordController,
                              isPass: !_showPass,
                              focusNode: _passwordFocusNode,
                              onFieldSubmitted: (_) {
                                FocusScope.of(
                                  context,
                                ).requestFocus(_confirmPasswordFocusNode);
                              },
                              suffix: IconButton(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onPressed: () {
                                  setState(() {
                                    _showPass = !_showPass;
                                  });
                                },
                                icon: Icon(
                                  _showPass
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: SharedColors.greyTextColor,
                                ),
                              ),
                            ),
                            TextWithTextField(
                              validator:
                                  (value) => confirmPasswordValidator(
                                    value,
                                    _passwordController.text,
                                    context,
                                  ),
                              text: "confirmPassword",
                              hintText: "confirmPassword",
                              filled: true,
                              fillColor:
                                  Get.theme.colorScheme.onSecondaryContainer,
                              boldLabel: true,
                              controller: _confirmPasswordController,
                              isPass: !_showConfirmPass,
                              focusNode: _confirmPasswordFocusNode,
                              suffix: IconButton(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onPressed: () {
                                  setState(() {
                                    _showConfirmPass = !_showConfirmPass;
                                  });
                                },
                                icon: Icon(
                                  _showConfirmPass
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: SharedColors.greyTextColor,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Theme(
                                  data: ThemeData(
                                    unselectedWidgetColor:
                                        Get.theme.colorScheme.tertiaryContainer,
                                  ),
                                  child: Obx(() {
                                    return Checkbox(
                                      activeColor: Get.theme.primaryColor,
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          color:
                                              Get
                                                  .theme
                                                  .colorScheme
                                                  .tertiaryContainer,
                                        ),
                                      ),
                                      hoverColor: Get.theme.primaryColor,
                                      value:
                                          _signupController
                                              .agreeWithTerms
                                              .value,
                                      onChanged: (value) {
                                        _signupController.agreeWithTerms.value =
                                            value ?? false;
                                      },
                                    );
                                  }),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomTextWidget(
                                      text: "agreeTo",
                                      textThemeStyle:
                                          TextThemeStyleEnum.titleSmall,
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.inverseSurface,
                                    ),
                                    Gap(5.w),
                                    InkWell(
                                      onTap: () {
                                        LaunchUrlService.openWeb(
                                          context,
                                          "https://tedreeb.com/pages/terms-and-conditions",
                                        );
                                      },
                                      child: CustomTextWidget(
                                        text: "termsAndCondition",
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                        textThemeStyle:
                                            TextThemeStyleEnum.titleSmall,
                                        decoration: TextDecoration.underline,
                                        decorationThickness: 0.85,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(15.h),
                Obx(() {
                  return CustomButton(
                    onPressed: _signupAction,
                    borderRadius: 25,
                    width: double.infinity,
                    elevation: 8,
                    child:
                        _signupController.isSignupLoading.value
                            ? LoadingAnimation(
                              color: Get.theme.colorScheme.onSurface,
                            )
                            : CustomTextWidget(
                              text: "signup",
                              color: Get.theme.colorScheme.onSurface,
                            ),
                  );
                }),
                Gap(20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CustomTextWidget(
                      text: "alreadyHaveAnAccount",
                      textThemeStyle: TextThemeStyleEnum.bodyMedium,
                    ),
                    Gap(5.w),
                    InkWell(
                      onTap: () {
                        Get.offAllNamed(RoutePaths.login);
                      },

                      child: CustomTextWidget(
                        text: "login",
                        color: Theme.of(context).colorScheme.primary,
                        textThemeStyle: TextThemeStyleEnum.bodyMedium,
                        decoration: TextDecoration.underline,
                        decorationThickness: 0.85,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
