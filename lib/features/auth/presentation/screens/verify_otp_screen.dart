import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart' hide Trans;
import 'package:pinput/pinput.dart';
import '../../../../core/core.dart';
import '../../../../core/validators/general_validations.dart';

import '../../data/models/signup_data_model.dart';
import '../controllers/verify_otp_controller.dart';

class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({super.key});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _focusNode = FocusNode();
  final verifyOtpController =
      VerifyOtpController.myController; //   Get.find<VerifyOtpController>();
  late SignupDataModel signupDataModel;

  bool isEmailValid = false;
  bool isOtpValid = false;

  @override
  void initState() {
    signupDataModel = Get.arguments;
    verifyOtpController.setSignupData(signupDataModel);

    super.initState();
  }

  @override
  void dispose() {
    _otpController.dispose();
    _focusNode.dispose();
    verifyOtpController.disableOtpView();
    super.dispose();
  }

  void _verifyOtp() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    verifyOtpController.verifyOtp(_otpController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: UIConstants.desktopBody,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Center(
                  child: CustomTextWidget(
                    text: "checkCode",
                    // color: Theme.of(context).colorScheme.primary,
                    textThemeStyle: TextThemeStyleEnum.headlineMedium,
                  ),
                ),
                Gap(5.h),
                Center(
                  child: CustomTextWidget(
                    text: "pleaseEnterOtp",
                    color: Get.theme.colorScheme.tertiaryContainer,
                    textThemeStyle: TextThemeStyleEnum.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                Center(
                  child:
                      signupDataModel.email != null
                          ? CustomTextWidget(
                            text: signupDataModel.email!,
                            color: Get.theme.primaryColor,
                            textThemeStyle: TextThemeStyleEnum.bodyMedium,
                            textAlign: TextAlign.center,
                          )
                          : CustomTextWidget(
                            text:
                                "\u200E${signupDataModel.countryCode} ${signupDataModel.phone}",
                            color: Get.theme.primaryColor,
                            textThemeStyle: TextThemeStyleEnum.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                ),

                Gap(30.h),

                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      Center(
                        child: Pinput(
                          defaultPinTheme: PinTheme(
                            height: 41.h,
                            width: 57.w,
                            decoration: BoxDecoration(
                              color: Get.theme.colorScheme.onSecondaryContainer,
                              borderRadius: BorderRadius.circular(
                                UIConstants.radius12,
                              ),
                            ),
                            textStyle: Theme.of(context).textTheme.bodyMedium,
                          ),
                          controller: _otpController,
                          length: 5,
                          keyboardType: TextInputType.number,
                          validator: (value) => otpValidator(value!),
                        ),
                      ),
                      SizedBox(height: 30.h),
                      CustomTextWidget(
                        text: "haventReceiveTheCode",
                        textThemeStyle: TextThemeStyleEnum.bodyMedium,
                        color: Get.theme.colorScheme.tertiaryContainer,
                      ),
                      Obx(() {
                        return verifyOtpController.secondsRemaining.value <
                                    60 &&
                                verifyOtpController.secondsRemaining.value > 0
                            ? CustomTextWidget(
                              text:
                                  "${"resendCodeIn".tr(context: context)}${verifyOtpController.secondsRemaining}",
                              textThemeStyle: TextThemeStyleEnum.bodyMedium,
                              fontWeight: FontWeight.w500,
                            )
                            : verifyOtpController.isLoading.value
                            ? const SizedBox.shrink()
                            : InkWell(
                              onTap: () => verifyOtpController.resendCode(),
                              child: CustomTextWidget(
                                text: "resendCode",
                                color: Theme.of(context).colorScheme.primary,
                                textThemeStyle: TextThemeStyleEnum.bodyMedium,
                                decoration: TextDecoration.underline,
                                decorationThickness: 0.85,
                              ),
                            );
                      }),
                    ],
                  ),
                ),

                Gap(30.h),
                Obx(() {
                  return CustomButton(
                    onPressed: _verifyOtp,
                    borderRadius: 25,
                    width: double.infinity,
                    elevation: 8,
                    child:
                        verifyOtpController.isLoading.value
                            ? LoadingAnimation(
                              color: Get.theme.colorScheme.onSurface,
                            )
                            : CustomTextWidget(
                              text: "verify",
                              color: Get.theme.colorScheme.onSurface,
                            ),
                  );
                }),
                // Reset Password button

                // Resend OTP button (disabled during countdown)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
