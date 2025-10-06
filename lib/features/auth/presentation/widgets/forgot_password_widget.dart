// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart' hide Trans;
// import 'package:pinput/pinput.dart';
// import 'package:etqan_edu_app/config/app_colors.dart';
// import 'package:etqan_edu_app/config/asset_paths.dart';
// import 'package:etqan_edu_app/core/enums/text_style_enum.dart';
// import 'package:etqan_edu_app/core/validators/general_validations.dart';
// import 'package:etqan_edu_app/core/widgets/custom_button.dart';
// import 'package:etqan_edu_app/core/widgets/custom_form_field.dart';
// import 'package:etqan_edu_app/core/widgets/custom_rich_text.dart';
// import 'package:etqan_edu_app/core/widgets/custom_text_widget.dart';
// import 'package:etqan_edu_app/core/widgets/loader.dart';
// import 'package:etqan_edu_app/features/auth/presentation/controllers/reset_password_controller.dart';
//
// class ForgotPasswordWidget extends StatefulWidget {
//   const ForgotPasswordWidget({super.key});
//
//   @override
//   State<ForgotPasswordWidget> createState() => _ForgotPasswordWidgetState();
// }
//
// class _ForgotPasswordWidgetState extends State<ForgotPasswordWidget> {
//   final _emailController = TextEditingController();
//   final _otpController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   final _focusNode = FocusNode();
//   final resetPasswordController = Get.find<ResetPasswordController>();
//
//   bool isEmailValid = false;
//   bool isOtpValid = false;
//
//   void fillEmail() {
//     _emailController.text = resetPasswordController.email.value ?? "";
//   }
//
//   void _validateEmail() {
//     final email = _emailController.text;
//     setState(() {
//       isEmailValid = emailValidator(email, context) == null;
//     });
//   }
//
//   void _validateOtp() {
//     final otp = _otpController.text;
//     setState(() {
//       isOtpValid = otp.length == 4;
//     });
//   }
//
//   @override
//   void initState() {
//     fillEmail();
//     _focusNode.addListener(() {
//       if (_focusNode.hasFocus) {
//         setState(() {});
//       }
//     });
//     _validateEmail();
//     _emailController.addListener(_validateEmail);
//
//     _otpController.addListener(_validateOtp);
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _emailController.dispose();
//     _otpController.dispose();
//     _focusNode.dispose();
//     resetPasswordController.disableOtpView();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
//
//     return Obx(
//       () => AnimatedContainer(
//         duration: const Duration(milliseconds: 150),
//         height: resetPasswordController.isOtpView.value
//             ? (keyboardHeight > 0 ? 570.h + keyboardHeight : 570.h)
//             : (keyboardHeight > 0 ? 400.h + keyboardHeight : 400.h),
//         padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               if (resetPasswordController.isOtpView.value) ...{
//                 Center(
//                   child: SvgPicture.asset(
//                     AssetPaths.lockIcon,
//                     width: 69.w,
//                     height: 69.w,
//                   ),
//                 ),
//                 SizedBox(height: 32.h),
//                 const Center(
//                   child: CustomTextWidget(
//                     text: "checkCode",
//                     maxLines: 2,
//                   ),
//                 ),
//                 SizedBox(height: 12.h),
//                 const CustomTextWidget(
//                   text: "pleaseEnterOtp",
//                   maxLines: 2,
//                   textThemeStyle: TextThemeStyleEnum.titleSmall,
//                   textAlign: TextAlign.center,
//                 ),
//               } else ...{
//                 const CustomTextWidget(
//                   text: "forgotPasswordMessage",
//                   maxLines: 2,
//                 ),
//                 const CustomTextWidget(
//                   text: "forgotPasswordResetMessage",
//                   maxLines: 5,
//                   textThemeStyle: TextThemeStyleEnum.titleSmall,
//                 ),
//               },
//
//               SizedBox(height: 32.h),
//
//               // Form to enter either Email or OTP based on timer state
//               Form(
//                 key: _formKey,
//                 autovalidateMode: AutovalidateMode.onUserInteraction,
//                 child: resetPasswordController.isOtpView.value
//                     ? Column(
//                         children: [
//                           Center(
//                             child: Pinput(
//                               defaultPinTheme: PinTheme(
//                                 padding: EdgeInsets.symmetric(
//                                   horizontal: 25.w,
//                                   vertical: 15.h,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(
//                                     10.r,
//                                   ),
//                                   border: Border.all(
//                                     color: SharedColors.greyTextColor,
//                                   ),
//                                 ),
//                                 textStyle:
//                                     Theme.of(context).textTheme.displayLarge,
//                               ),
//                               controller: _otpController,
//                               length: 4,
//                               keyboardType: TextInputType.number,
//                             ),
//                           ),
//                           SizedBox(height: 16.h),
//                           resetPasswordController.secondsRemaining.value < 60 &&
//                                   resetPasswordController
//                                           .secondsRemaining.value >
//                                       0
//                               ? CustomTextWidget(
//                                   text:
//                                       "resend code in ${resetPasswordController.secondsRemaining}",
//                                   textThemeStyle: TextThemeStyleEnum.titleSmall,
//                                 )
//                               : CustomRichText(
//                                   firstText: "haventRecievedCode",
//                                   clickableText: "resend",
//                                   onTap: () {
//                                     resetPasswordController.sendOtp(
//                                       _emailController.text,
//                                       true,
//                                     );
//                                   },
//                                 ),
//                         ],
//                       )
//                     : CustomFormField(
//                         validator: (value) => emailValidator(value, context),
//                         controller: _emailController,
//                         focusNode: _focusNode,
//                         hintText: "email",
//                         prefix: const Icon(
//                           Icons.email,
//                           color: SharedColors.greyTextColor,
//                         ),
//                       ),
//               ),
//
//               SizedBox(height: 60.h),
//
//               // Reset Password button
//
//               if (resetPasswordController.isOtpView.value) ...{
//                 CustomButton(
//                   onPressed: () {
//                     if (!_formKey.currentState!.validate()) {
//                       return;
//                     }
//                     resetPasswordController.verifyOtp(_otpController.text);
//                   },
//                   backgroundColor:
//                       isOtpValid ? null : SharedColors.greyTextColor,
//                   width: double.infinity,
//                   child: CustomTextWidget(
//                     text: "check",
//                     color: Theme.of(context).colorScheme.onSurface,
//                   ),
//                 ),
//                 SizedBox(height: 10.h),
//                 CustomButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   width: double.infinity,
//                   backgroundColor: Theme.of(context).colorScheme.onSurface,
//                   borderColor: Theme.of(context).colorScheme.primary,
//                   child: CustomTextWidget(
//                     text: "login",
//                     color: Theme.of(context).colorScheme.primary,
//                   ),
//                 ),
//               } else ...{
//                 CustomButton(
//                   onPressed: () {
//                     if (!_formKey.currentState!.validate()) {
//                       return;
//                     }
//                     resetPasswordController.sendOtp(_emailController.text);
//                   },
//                   backgroundColor:
//                       isEmailValid ? null : SharedColors.greyTextColor,
//                   width: double.infinity,
//                   child: resetPasswordController.isLoading.value
//                       ? const Loader()
//                       : CustomTextWidget(
//                           text: "resetPassword",
//                           color: Theme.of(context).colorScheme.onSurface,
//                         ),
//                 ),
//                 SizedBox(height: 10.h),
//                 CustomButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   width: double.infinity,
//                   backgroundColor: Theme.of(context).colorScheme.onSurface,
//                   borderColor: Theme.of(context).colorScheme.primary,
//                   child: CustomTextWidget(
//                     text: "login",
//                     color: Theme.of(context).colorScheme.primary,
//                   ),
//                 ),
//               },
//
//               // Resend OTP button (disabled during countdown)
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
