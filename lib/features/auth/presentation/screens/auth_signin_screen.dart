import 'package:easy_localization/easy_localization.dart';

import '../../../../config/app_colors.dart';
import '../../../../config/asset_paths.dart';
import '../../../../core/core.dart';
import '../../../../core/routes/route_paths.dart';
import '../../../../core/services/url_launcher_service.dart';
import '../../../../core/validators/general_validations.dart';
import '../../../shared/presentation/controllers/app_controller.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart' hide Trans;

import '../controllers/auth_controller.dart';
import '../widgets/auth_text_field_widget.dart';
import '../widgets/social_button_widget.dart';

class AuthSigninScreen extends StatefulWidget {
  const AuthSigninScreen({super.key});

  @override
  State<AuthSigninScreen> createState() => _AuthSigninScreenState();
}

class _AuthSigninScreenState extends State<AuthSigninScreen> {
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final _authController = Get.find<AuthController>();
  final _appController = Get.find<AppController>();

  @override
  void initState() {
    super.initState();
    if (GetPlatform.isAndroid && kDebugMode) {
      _phoneController.text = "";
      _passwordController.text = "";
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _loginAction() async {
    // Get.toNamed(RoutePaths.navScreen);

    if (_authController.isLoading.value) {
      return;
    }
    if (!_formKey.currentState!.validate()) {
      return;
    }

    await _authController.login(
      identifier: _phoneController.text,
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final imageHeight = screenHeight * 0.30;
    final topSpacing = screenHeight * 0.03;
    
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: screenHeight,
            ),
            child: Column(
              children: [
                SizedBox(height: topSpacing),
                SizedBox(
                  height: imageHeight,
                  width: double.infinity,
                  child: Image.asset(AssetPaths.login, fit: BoxFit.cover),
                ),
                Container(
                  width: double.infinity,
                  constraints: BoxConstraints(
                    minHeight: screenHeight - imageHeight - topSpacing,
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
                          'login'.tr(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(() {
                              final selectedCountry =
                                  _authController.selectedCountry.value;
                              return GestureDetector(
                                onTap: () {
                                  showCountryPicker(
                                    context: context,
                                    showPhoneCode: false,
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
                                            Get
                                                .theme
                                                .colorScheme
                                                .onSecondaryContainer,
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
                                      _authController.updateSelectedCountry(
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
                                validator:
                                    (value) =>
                                        phoneNumberValidator(value, context),
                                controller: _phoneController,
                                onFieldSubmitted: (_) {
                                  FocusScope.of(
                                    context,
                                  ).requestFocus(_passwordFocusNode);
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
                          validator:
                              (value) => passwordValidator(value, context),
                          focusNode: _passwordFocusNode,
                          onFieldSubmitted: (_) {
                            _loginAction();
                          },
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
                            onPressed: _loginAction,
                            child:
                                _authController.isLoading.value
                                    ? LoadingAnimation(
                                      color: Get.theme.colorScheme.onSurface,
                                    )
                                    : Text(
                                      'login'.tr(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                          );
                        }),
                        const SizedBox(height: 18),
                        GestureDetector(
                          onTap: () {
                            LaunchUrlService.openWhatsappToSupport(context);
                          },
                          child: Text(
                            "forgotPassword".tr(),
                            style: const TextStyle(
                              color: SharedColors.authSecondaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (_appController.isReviewing.value == false) ...{
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'dontHaveAnAccount'.tr(),
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed(RoutePaths.signup);
                                },
                                child: Text(
                                  'signup'.tr(),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: SharedColors.authSecondaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                              // TODO: Implement Google login
                            },
                          ),
                          SizedBox(height: 12.h),
                          SocialButtonWidget(
                            text: 'Facebook'.tr(),
                            iconPath: AssetPaths.facebook,
                            backgroundColor: SharedColors.authActionColor,
                            onPressed: () {
                              // TODO: Implement Facebook login
                            },
                          ),
                        },
                      ],
                    ),
                  ),
                ),
              ),
            ],
            ),
          ),
        ),
      ),
    );
  }
}
