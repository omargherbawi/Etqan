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
import '../widgets/auth_text_field_widget.dart';
import '../widgets/social_button_widget.dart';
import '../../../shared/presentation/controllers/app_controller.dart';

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
  final _signupController = Get.find<AuthSignupController>();
  final _appController = Get.find<AppController>();
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
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.23,
                width: double.infinity,
                child: Image.asset(AssetPaths.appLogo, fit: BoxFit.contain),
              ),
              Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height * 0.75,
                ),
                decoration: const BoxDecoration(
                  color: SharedColors.authPrimaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'createAccount'.tr(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'fillYourInformationBelowToRegister'.tr(),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        AuthTextFieldWidget(
                          title: "name",
                          prefixIcon: const Icon(
                            Icons.person_outlined,
                            color: Colors.grey,
                          ),
                          keyboardType: TextInputType.text,
                          controller: _fullNameController,
                          validator: (value) => isNotEmpty(value ?? "", context),
                        ),
                        const SizedBox(height: 14),
                        Obx(() {
                          final selectedProgram =
                              _signupController.selectedProgram.value;
                          return GestureDetector(
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
                                          _signupController.programList[index];
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
                              child: AuthTextFieldWidget(
                                title: selectedProgram != null
                                    ? (selectedProgram.arName ?? "chooseYourStudyStage")
                                    : "chooseYourStudyStage",
                                prefixIcon: const Icon(
                                  Icons.school_outlined,
                                  color: Colors.grey,
                                ),
                                keyboardType: TextInputType.none,
                                controller: TextEditingController(
                                  text: selectedProgram?.arName ?? "",
                                ),
                              ),
                            ),
                          );
                        }),
                        const SizedBox(height: 14),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(() {
                              final selectedCountry =
                                  _signupController.selectedCountry.value;
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
                                      borderRadius: BorderRadius.circular(18.r),
                                      textStyle: TextStyle(fontSize: 16.sp),
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
                                            SharedColors.authTextFieldBgColor,
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16.w,
                                          vertical: 12.h,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            UIConstants.radius12,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            UIConstants.radius12,
                                          ),
                                          borderSide: BorderSide.none,
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
                                      _signupController.updateSelectedCountry(
                                        country,
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  width: 60.w,
                                  height: 48.h,
                                  decoration: BoxDecoration(
                                    color: SharedColors.authTextFieldBgColor,
                                    borderRadius: BorderRadius.circular(
                                      UIConstants.radius12,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        selectedCountry.flagEmoji,
                                        style: TextStyle(fontSize: 20.sp),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                            Gap(10.w),
                            Expanded(
                              child: AuthTextFieldWidget(
                                numbersOnly: true,
                                title: "phoneNumber",
                                prefixIcon: const Icon(
                                  Icons.phone_outlined,
                                  color: Colors.grey,
                                ),
                                keyboardType: TextInputType.phone,
                                validator: (value) =>
                                    phoneNumberValidator(value, context),
                                controller: phoneController,
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(_passwordFocusNode);
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        AuthTextFieldWidget(
                          title: 'password',
                          prefixIcon: const Icon(
                            Icons.lock_outlined,
                            color: Colors.grey,
                          ),
                          keyboardType: TextInputType.text,
                          isPassword: true,
                          controller: _passwordController,
                          validator: (value) =>
                              passwordValidator(value, context),
                          focusNode: _passwordFocusNode,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_confirmPasswordFocusNode);
                          },
                        ),
                        const SizedBox(height: 14),
                        AuthTextFieldWidget(
                          title: 'confirmPassword',
                          prefixIcon: const Icon(
                            Icons.lock_outlined,
                            color: Colors.grey,
                          ),
                          keyboardType: TextInputType.text,
                          isPassword: true,
                          controller: _confirmPasswordController,
                          validator: (value) => confirmPasswordValidator(
                            value,
                            _passwordController.text,
                            context,
                          ),
                          focusNode: _confirmPasswordFocusNode,
                          onFieldSubmitted: (_) {
                            _signupAction();
                          },
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Theme(
                              data: ThemeData(
                                unselectedWidgetColor: Colors.grey,
                              ),
                              child: Obx(() {
                                return Checkbox(
                                  activeColor: SharedColors.authSecondaryColor,
                                  checkColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  value: _signupController.agreeWithTerms.value,
                                  onChanged: (value) {
                                    _signupController.agreeWithTerms.value =
                                        value ?? false;
                                  },
                                );
                              }),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Text(
                                    "agreeTo".tr(),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  InkWell(
                                    onTap: () {
                                      LaunchUrlService.openWeb(
                                        context,
                                        "https://tedreeb.com/pages/terms-and-conditions",
                                      );
                                    },
                                    child: Text(
                                      "termsAndCondition".tr(),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: SharedColors.authSecondaryColor,
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Obx(() {
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: SharedColors.authActionColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            onPressed: _signupAction,
                            child: _signupController.isSignupLoading.value
                                ? LoadingAnimation(
                                    color: Get.theme.colorScheme.onSurface,
                                  )
                                : Text(
                                    'signup'.tr(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                          );
                        }),
                        const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'alreadyHaveAnAccount'.tr(),
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () {
                                Get.offAllNamed(RoutePaths.login);
                              },
                              child: Text(
                                'login'.tr(),
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: SharedColors.authSecondaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (_appController.isReviewing.value == false) ...{
                          SizedBox(height: 12.h),
                          Row(
                            children: [
                              const Expanded(
                                child: Divider(
                                  color: Colors.grey,
                                  thickness: 1,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                child: Text(
                                  'OR'.tr(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const Expanded(
                                child: Divider(
                                  color: Colors.grey,
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          SocialButtonWidget(
                            text: 'Google',
                            iconPath: AssetPaths.googleSvg,
                            backgroundColor: SharedColors.authActionColor,
                            onPressed: () {
                              // TODO: Implement Google signup
                            },
                          ),
                          SizedBox(height: 12.h),
                          SocialButtonWidget(
                            text: 'Facebook'.tr(),
                            iconPath: AssetPaths.facebook,
                            backgroundColor: SharedColors.authActionColor,
                            onPressed: () {
                              // TODO: Implement Facebook signup
                            },
                          ),
                        },
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
