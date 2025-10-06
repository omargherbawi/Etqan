import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:etqan_edu_app/core/utils/regex_patterns.dart';

String? emailValidator(String? value, BuildContext context) {
  RegExp emailRegex = RegExp(RegexPatterns.emailPattern);

  // Check if the value is a valid email
  if ((value != null || value!.isEmpty) && emailRegex.hasMatch(value)) {
    return null; // Valid email, return null
  } else {
    return "invalidEmail".tr();
  }
}

String? phoneNumberValidator(String? value, BuildContext context) {
  final isEnglish = context.locale == const Locale('en');

  if (value == null || value.trim().isEmpty) {
    return isEnglish ? "Phone number can't be empty" : "رقم الهاتف مطلوب";
  }

  final phone = value.trim();

  // Disallow country code
  // if (phone.startsWith('+') || phone.startsWith('963')) {
  //   return isEnglish
  //       ? "Please enter the phone number without the country code"
  //       : "يرجى إدخال رقم الهاتف بدون رمز الدولة";
  // }

  // Disallow starting with zero
  // if (phone.startsWith('0')) {
  //   return isEnglish
  //       ? "Phone number should not start with 0"
  //       : "يجب ألا يبدأ رقم الهاتف بصفر";
  // }

  // Syria phone validation: must start with 9 and have exactly 9 digits
  final syriaPattern = RegExp(r'^[0-9]{6,}$');

  if (!syriaPattern.hasMatch(phone)) {
    return isEnglish
        ? "Phone number must be 6 digits or more"
        : "يجب أن يكون رقم الهاتف من 6 أرقام وأكثر";
  }

  return null; // ✅ Valid
}

String? nameValidator(String? value, BuildContext context) {
  if (value == null || value.isEmpty) {
    return context.locale == const Locale('en')
        ? "Name can't be empty"
        : "الاسم مطلوب";
  }
  return null;
}

String? isNotEmpty(String value, BuildContext context) {
  if (value.isEmpty) {
    return "cantBeEmpty".tr();
  }
  return null;
}

String? otpValidator(String value) {
  if (value.isEmpty) {
    return "cantBeEmpty".tr();
  } else if (value.length < 5) {
    return "pleaseEnterOtp".tr();
  }
  return null;
}

String? passwordValidator(String? value, BuildContext context) {
  if (value != null && value.length < 8) {
    return "invalidPassword".tr(context: context);
  }

  return null;
}

String? confirmPasswordValidator(
  String? value,
  String? password,
  BuildContext context,
) {
  if (value == null || value.isEmpty) {
    return "";
  } else if (value.trim() != password?.trim()) {
    return "passwordDoesntMatch".tr(context: context);
  }
  return null;
}

bool isEmail(String value) {
  RegExp emailRegex = RegExp(RegexPatterns.emailPattern);
  return emailRegex.hasMatch(value);
}

bool isPhoneNumber(String value) {
  // Remove any '+' from the phone number before checking
  String cleanedNumber = value.replaceAll('+', '');

  // Check if the cleaned number contains only numeric characters
  RegExp onlyNumbersRegex = RegExp(RegexPatterns.onlyNumbers);
  if (onlyNumbersRegex.hasMatch(cleanedNumber)) {
    return true;
  }

  // Check if the cleaned number contains at least one numeric character
  RegExp containsNumbersRegex = RegExp(RegexPatterns.containsNumbers);
  return containsNumbersRegex.hasMatch(cleanedNumber);
}
