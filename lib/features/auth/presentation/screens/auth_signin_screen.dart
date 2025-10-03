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
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart' hide Trans;

import '../controllers/auth_controller.dart';

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
  bool _showPass = false;
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
    return Scaffold(
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 60.h),
            child: Padding(
              padding: UIConstants.mobileBodyPadding,
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        CircleIconButton(
                          icon: Icons.arrow_back,
                          iconColor: Get.theme.colorScheme.inverseSurface,
                          onPressed: () {
                            Get.offAllNamed(RoutePaths.visitor);
                          },
                          greyBackground: false,
                        ),
                      ],
                    ),
                    Image.asset(AssetPaths.appLogo, width: 180.w),
                    Gap(35.h),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextWidget(
                          text: 'phoneNumber',
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).colorScheme.inverseSurface,
                          textThemeStyle: TextThemeStyleEnum.bodyMedium,
                        ),
                        Gap(5.h),
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
                              child: TextWithTextField(
                                numbersOnly: true,
                                text: "phoneNumber",
                                hintText: "phoneNumber",
                                filled: true,
                                hideLabel: true,
                                validator:
                                    (value) =>
                                        phoneNumberValidator(value, context),
                                fillColor:
                                    Get.theme.colorScheme.onSecondaryContainer,
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
                      ],
                    ),
                    Gap(5.h),
                    TextWithTextField(
                      validator: (value) => passwordValidator(value, context),
                      text: "password",
                      filled: true,
                      fillColor: Get.theme.colorScheme.onSecondaryContainer,
                      boldLabel: true,
                      hintText: "password",
                      controller: _passwordController,
                      width: double.infinity,
                      isPass: !_showPass,
                      focusNode: _passwordFocusNode,
                      onFieldSubmitted: (_) {
                        // _loginAction();
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
                          _showPass ? Icons.visibility : Icons.visibility_off,
                          color: SharedColors.greyTextColor,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          LaunchUrlService.openWhatsappToSupport(context);
                        },
                        child: CustomTextWidget(
                          text: "forgotPassword",
                          color: Theme.of(context).colorScheme.primary,
                          textThemeStyle: TextThemeStyleEnum.titleSmall,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                          decorationThickness: 0.85,
                        ),
                      ),
                    ),
                    Gap(20.h),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Obx(() {
                          return CustomButton(
                            onPressed: _loginAction,
                            borderRadius: 25,
                            width: double.infinity,
                            elevation: 8,
                            child:
                                _authController.isLoading.value
                                    ? LoadingAnimation(
                                      color: Get.theme.colorScheme.onSurface,
                                    )
                                    : CustomTextWidget(
                                      text: "login",
                                      color: Get.theme.colorScheme.onSurface,
                                      fontSize: Responsive.isTablet ? 10 : null,
                                    ),
                          );
                        }),

                        if (_appController.isReviewing.value == false) ...{
                          Gap(20.h),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CustomTextWidget(
                                text: "dontHaveAnAccount",
                                textThemeStyle: TextThemeStyleEnum.titleSmall,
                              ),
                              Gap(5.w),
                              InkWell(
                                onTap: () {
                                  Get.toNamed(RoutePaths.signup);
                                },
                                child: CustomTextWidget(
                                  text: "signup",
                                  color: Theme.of(context).colorScheme.primary,
                                  textThemeStyle: TextThemeStyleEnum.titleSmall,
                                  decoration: TextDecoration.underline,
                                  decorationThickness: 0.85,
                                ),
                              ),
                            ],
                          ),

                          Gap(20.h),
                        },

                        GestureDetector(
                          onTap: () {
                            LaunchUrlService.openWhatsapp(context);
                          },
                          child: Row(
                            spacing: 6.w,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                AssetPaths.whatsappSvg,
                                height: 20.w,
                                width: 20.w,
                              ),

                              CustomTextWidget(
                                text: "needHelpContactUs",
                                textThemeStyle: TextThemeStyleEnum.titleSmall,
                                color: Get.theme.colorScheme.primary,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FlagWidget extends StatelessWidget {
  const FlagWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46.w,
      height: 46.h,
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.onSecondaryContainer,
        borderRadius: BorderRadius.circular(UIConstants.radius12),
      ),
      child: Center(child: Text('🇸🇾', style: TextStyle(fontSize: 20.sp))),
    );
  }
}
