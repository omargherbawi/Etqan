import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../../config/app_colors.dart';
import '../../../../core/core.dart';
import '../../../../core/routes/route_paths.dart';
import '../../../../core/validators/general_validations.dart';
import '../controllers/account_reset_password_controller.dart';
import '../../../auth/data/models/signup_data_model.dart';
import '../../../shared/presentation/controllers/current_user_controller.dart';

class AccountResetPasswordScreen extends StatefulWidget {
  const AccountResetPasswordScreen({super.key});

  @override
  State<AccountResetPasswordScreen> createState() =>
      _AccountResetPasswordScreenState();
}

class _AccountResetPasswordScreenState
    extends State<AccountResetPasswordScreen> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _showOldPass = false;
  bool _showNewPass = false;
  bool _showConfirmPass = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "resetPassword"),
      body: SingleChildScrollView(
        padding: UIConstants.mobileBodyPadding,
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formKey,
          child: Column(
            children: [
              TextWithTextField(
                filled: true,
                fillColor: Get.theme.colorScheme.onSecondaryContainer,
                boldLabel: true,
                text: "oldPassword",
                hintText: "oldPassword",
                controller: _oldPasswordController,
                suffix: IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    setState(() {
                      _showOldPass = !_showOldPass;
                    });
                  },
                  icon: Icon(
                    _showOldPass ? Icons.visibility : Icons.visibility_off,
                    color: SharedColors.greyTextColor,
                  ),
                ),
                isPass: !_showOldPass,
                validator: (value) => passwordValidator(value, context),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {
                    final user = Get.find<CurrentUserController>().user;
                    bool isPhoneMode = user?.email == null;

                    SignupDataModel signupDataModel = SignupDataModel(
                      userId: '1',
                      email: isPhoneMode ? null : user?.email,
                      phone: isPhoneMode ? user?.mobile : null,
                      countryCode:
                          isPhoneMode ? user?.countryId.toString() : null,
                      password: '12345678',
                      retypePassword: '12345678',
                      newUser: false,
                    );

                    Get.toNamed(
                      RoutePaths.verifyOtpScreen,
                      arguments: signupDataModel,
                    );

                    // showModalBottomSheet(
                    //   isScrollControlled: true,
                    //   showDragHandle: true,
                    //   context: context,
                    //   builder: (context) {
                    //     return const ForgotPasswordWidget();
                    //   },
                    // );
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
              TextWithTextField(
                filled: true,
                fillColor: Get.theme.colorScheme.onSecondaryContainer,
                boldLabel: true,
                text: "newPassword",
                hintText: "newPassword",
                controller: _newPasswordController,
                suffix: IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    setState(() {
                      _showNewPass = !_showNewPass;
                    });
                  },
                  icon: Icon(
                    _showNewPass ? Icons.visibility : Icons.visibility_off,
                    color: SharedColors.greyTextColor,
                  ),
                ),
                isPass: !_showNewPass,
                validator: (value) => passwordValidator(value, context),
              ),
              TextWithTextField(
                filled: true,
                fillColor: Get.theme.colorScheme.onSecondaryContainer,
                boldLabel: true,
                text: "confirmNewPassword",
                hintText: "confirmNewPassword",
                controller: _confirmPasswordController,
                suffix: IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    setState(() {
                      _showConfirmPass = !_showConfirmPass;
                    });
                  },
                  icon: Icon(
                    _showConfirmPass ? Icons.visibility : Icons.visibility_off,
                    color: SharedColors.greyTextColor,
                  ),
                ),
                isPass: !_showConfirmPass,
                validator:
                    (value) => confirmPasswordValidator(
                      value,
                      _newPasswordController.text,
                      context,
                    ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
        child: Obx(() {
          final resetPasswordController =
              Get.find<AccountResetPasswordController>();
          return CustomButton(
            elevation: 8,
            width: double.infinity,
            borderRadius: UIConstants.radius25,
            onPressed: () {
              if (!_formKey.currentState!.validate()) {
                return;
              }
              resetPasswordController.updatePassword(
                _oldPasswordController.text,
                _newPasswordController.text,
              );
            },
            child:
                resetPasswordController.isLoading.value
                    ? LoadingAnimation(color: Get.theme.colorScheme.onSurface)
                    : CustomTextWidget(
                      text: "savePassword",
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
          );
        }),
      ),
    );
  }
}
