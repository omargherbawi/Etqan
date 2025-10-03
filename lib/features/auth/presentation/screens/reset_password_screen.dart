import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../../config/app_colors.dart';
import '../../../../core/core.dart';
import '../../../../core/validators/general_validations.dart';
import '../controllers/verify_otp_controller.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _newPasswordController = TextEditingController();

  final _confirmPasswordController = TextEditingController();
  bool showNewPass = false;
  bool showConfirmNewPass = false;
  bool isPasswordValid = false;
  final _formKey = GlobalKey<FormState>();
  final resetPasswordController = Get.find<VerifyOtpController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    resetPasswordController.isResetingPassword.value = false;
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: UIConstants.desktopBody,
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            child: Column(
              children: [
                const Center(
                  child: CustomTextWidget(
                    text: "newPassword",
                    // color: Theme.of(context).colorScheme.primary,
                    textThemeStyle: TextThemeStyleEnum.headlineMedium,
                  ),
                ),
                Gap(5.h),
                Center(
                  child: CustomTextWidget(
                    text:
                        "Your new password must be different from previously used passwords.",
                    maxLines: 3,
                    color: Get.theme.colorScheme.tertiaryContainer,
                    textThemeStyle: TextThemeStyleEnum.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                Gap(30.h),
                TextWithTextField(
                  text: "newPassword",
                  controller: _newPasswordController,
                  hintText: "newPassword",
                  filled: true,
                  fillColor: Get.theme.colorScheme.onSecondaryContainer,
                  boldLabel: true,
                  validator: (value) => passwordValidator(value, context),
                  isPass: !showNewPass,
                  suffix: IconButton(
                    onPressed: () {
                      setState(() {
                        showNewPass = !showNewPass;
                      });
                    },
                    icon: Icon(
                      showNewPass ? Icons.visibility : Icons.visibility_off,
                    ),
                    color: SharedColors.greyTextColor,
                  ),
                ),
                TextWithTextField(
                  text: "confirmNewPassword",
                  controller: _confirmPasswordController,
                  hintText: "confirmNewPassword",
                  filled: true,
                  fillColor: Get.theme.colorScheme.onSecondaryContainer,
                  boldLabel: true,
                  isPass: !showConfirmNewPass,
                  validator:
                      (value) => confirmPasswordValidator(
                        value,
                        _newPasswordController.text,
                        context,
                      ),
                  suffix: IconButton(
                    onPressed: () {
                      setState(() {
                        showConfirmNewPass = !showConfirmNewPass;
                      });
                    },
                    icon: Icon(
                      showConfirmNewPass
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    color: SharedColors.greyTextColor,
                  ),
                ),
                Gap(30.h),
                Obx(() {
                  return CustomButton(
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }
                      resetPasswordController.resetPassword(
                        _confirmPasswordController.text,
                      );
                    },
                    borderRadius: 25,
                    width: double.infinity,
                    elevation: 8,
                    child:
                        resetPasswordController.isResetingPassword.value
                            ? LoadingAnimation(
                              color: Get.theme.colorScheme.onSurface,
                            )
                            : CustomTextWidget(
                              text: "createNewPassword",
                              color: Get.theme.colorScheme.onSurface,
                            ),
                  );
                  // CustomButton(
                  //   backgroundColor: isPasswordValid ? null : SharedColors.greyTextColor,
                  //   onPressed: () {
                  //     if (!_formKey.currentState!.validate()) {
                  //       return;
                  //     }
                  //     resetPasswordController.resetPassword(_confirmPasswordController.text);
                  //   },
                  //   child: resetPasswordController.isResetingPassword.value
                  //       ? const LoadingAnimation()
                  //       : CustomTextWidget(
                  //     text: "resetPassword",
                  //     color: Theme.of(context).colorScheme.onSurface,
                  //   ),
                  // ),
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
