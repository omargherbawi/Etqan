// ignore_for_file: deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tedreeb_edu_app/config/app_colors.dart';
import 'package:tedreeb_edu_app/core/core.dart';

class Badges {
  static Color blue64() => const Color(0xff1F3B64);
  static Color greyB2 = const Color(0xffA9AEB2);
  static Color greyE7 = const Color(0xffE7E7E7);
  static Color red49 = const Color(0xffFF4949);
  static Color green77() => AppLightColors.primaryColor;
  static Color yellow29 = const Color(0xffFFC529);

  static Widget finished() {
    return Container(
      constraints: BoxConstraints(minWidth: 40.w),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
      decoration: BoxDecoration(
        color: greyE7,
        borderRadius: BorderRadius.circular(100),
      ),
      child: CustomTextWidget(
        textThemeStyle: TextThemeStyleEnum.bodyMedium,
        text: "finished",
        color: greyB2,
      ),
    );
  }

  static Widget notConducted() {
    return Container(
      constraints: BoxConstraints(minWidth: 40.w),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      decoration: BoxDecoration(
        color: blue64().withOpacity(.3),
        borderRadius: BorderRadius.circular(100),
      ),
      child: CustomTextWidget(
        textThemeStyle: TextThemeStyleEnum.bodyMedium,
        text: "finished",
        color: blue64(),
      ),
    );
  }

  static Widget inProgress() {
    return Container(
      constraints: BoxConstraints(minWidth: 40.w),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      decoration: BoxDecoration(
        color: blue64().withOpacity(.3),
        borderRadius: BorderRadius.circular(100),
      ),
      child: CustomTextWidget(
        textThemeStyle: TextThemeStyleEnum.bodyMedium,
        text: "inProgress",
        color: blue64(),
      ),
    );
  }

  static Widget off(String percent, {bool isRedBg = false}) {
    return Container(
      constraints: BoxConstraints(minWidth: 40.w),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      decoration: BoxDecoration(
        color: red49.withOpacity(isRedBg ? 1 : .3),
        borderRadius: BorderRadius.circular(100),
      ),
      child: CustomTextWidget(
        textThemeStyle: TextThemeStyleEnum.bodyMedium,
        text: '${"percent".tr()}% ${"off".tr()}',
        color: red49,
      ),
    );
  }

  static Widget liveClass() {
    return Container(
      constraints: BoxConstraints(minWidth: 40.w),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      decoration: BoxDecoration(
        color: green77().withOpacity(.3),
        borderRadius: BorderRadius.circular(100),
      ),
      child: CustomTextWidget(
        textThemeStyle: TextThemeStyleEnum.bodyMedium,
        text: "liveClass",
        color: green77(),
      ),
    );
  }

  static Widget course() {
    return Container(
      constraints: BoxConstraints(minWidth: 40.w),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      decoration: BoxDecoration(
        color: AppLightColors.primaryColor.withOpacity(.3),
        borderRadius: BorderRadius.circular(100),
      ),
      child: CustomTextWidget(
        textThemeStyle: TextThemeStyleEnum.bodyMedium,
        text: "course",
        color: AppLightColors.primaryColor,
      ),
    );
  }

  static Widget textClass() {
    return Container(
      constraints: BoxConstraints(minWidth: 40.w),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      decoration: BoxDecoration(
        color: green77().withOpacity(.3),
        borderRadius: BorderRadius.circular(100),
      ),
      child: CustomTextWidget(
        textThemeStyle: TextThemeStyleEnum.bodyMedium,
        text: "textClass",
        color: green77(),
      ),
    );
  }

  static Widget featured() {
    return Container(
      constraints: BoxConstraints(minWidth: 40.w),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      decoration: BoxDecoration(
        color: yellow29.withOpacity(.3),
        borderRadius: BorderRadius.circular(100),
      ),
      child: CustomTextWidget(
        textThemeStyle: TextThemeStyleEnum.bodyMedium,
        text: "featured",
        color: yellow29,
      ),
    );
  }

  static Widget notSubmitted() {
    return Container(
      constraints: BoxConstraints(minWidth: 40.w),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      decoration: BoxDecoration(
        color: red49,
        borderRadius: BorderRadius.circular(100),
      ),
      child: const CustomTextWidget(
        textThemeStyle: TextThemeStyleEnum.bodyMedium,
        text: "notSubmitted",
        color: Colors.white,
        height: 1,
      ),
    );
  }

  static Widget failed() {
    return Container(
      constraints: BoxConstraints(minWidth: 40.w),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      decoration: BoxDecoration(
        color: red49,
        borderRadius: BorderRadius.circular(100),
      ),
      child: const CustomTextWidget(
        textThemeStyle: TextThemeStyleEnum.bodyMedium,
        text: "failed",
        color: Colors.white,
      ),
    );
  }

  static Widget rejected() {
    return Container(
      constraints: BoxConstraints(minWidth: 40.w),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      decoration: BoxDecoration(
        color: red49,
        borderRadius: BorderRadius.circular(100),
      ),
      child: const CustomTextWidget(
        textThemeStyle: TextThemeStyleEnum.bodyMedium,
        text: "rejected",
        color: Colors.white,
      ),
    );
  }

  static Widget passed() {
    return Container(
      constraints: BoxConstraints(minWidth: 40.w),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      decoration: BoxDecoration(
        color: green77(),
        borderRadius: BorderRadius.circular(100),
      ),
      child: const CustomTextWidget(
        textThemeStyle: TextThemeStyleEnum.bodyMedium,
        text: "passed",
        color: Colors.white,
        height: 1,
      ),
    );
  }

  static Widget pending() {
    return Container(
      constraints: BoxConstraints(minWidth: 40.w),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      decoration: BoxDecoration(
        color: yellow29,
        borderRadius: BorderRadius.circular(100),
      ),
      child: const CustomTextWidget(
        textThemeStyle: TextThemeStyleEnum.bodyMedium,
        text: "pending",
        color: Colors.white,
      ),
    );
  }

  static Widget waiting() {
    return Container(
      constraints: BoxConstraints(minWidth: 40.w),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      decoration: BoxDecoration(
        color: yellow29,
        borderRadius: BorderRadius.circular(100),
      ),
      child: const CustomTextWidget(
        textThemeStyle: TextThemeStyleEnum.bodyMedium,
        text: "waiting",
        color: Colors.white,
        height: 1,
      ),
    );
  }

  static Widget open() {
    return Container(
      constraints: BoxConstraints(minWidth: 40.w),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      decoration: BoxDecoration(
        color: yellow29,
        borderRadius: BorderRadius.circular(100),
      ),
      child: const CustomTextWidget(
        textThemeStyle: TextThemeStyleEnum.bodyMedium,
        text: "open",
        color: Colors.white,
        height: 1,
      ),
    );
  }

  static Widget active() {
    return Container(
      constraints: BoxConstraints(minWidth: 40.w),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      decoration: BoxDecoration(
        color: green77(),
        borderRadius: BorderRadius.circular(100),
      ),
      child: const CustomTextWidget(
        textThemeStyle: TextThemeStyleEnum.bodyMedium,
        text: "active",
        color: Colors.white,
        height: 1,
      ),
    );
  }

  static Widget closed() {
    return Container(
      constraints: BoxConstraints(minWidth: 40.w),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      decoration: BoxDecoration(
        color: greyE7,
        borderRadius: BorderRadius.circular(100),
      ),
      child: CustomTextWidget(
        textThemeStyle: TextThemeStyleEnum.bodyMedium,
        text: "closed",
        color: greyB2,
        height: 1,
      ),
    );
  }

  static Widget private() {
    return Container(
      constraints: BoxConstraints(minWidth: 40.w),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      decoration: BoxDecoration(
        color: red49,
        borderRadius: BorderRadius.circular(100),
      ),
      child: const CustomTextWidget(
        textThemeStyle: TextThemeStyleEnum.bodyMedium,
        text: "private",
        color: Colors.white,
        height: 1,
      ),
    );
  }

  static Widget replied() {
    return Container(
      constraints: BoxConstraints(minWidth: 40.w),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      decoration: BoxDecoration(
        color: green77().withOpacity(.3),
        borderRadius: BorderRadius.circular(100),
      ),
      child: CustomTextWidget(
        textThemeStyle: TextThemeStyleEnum.bodyMedium,
        text: "replied",
        color: green77(),
        height: 1,
      ),
    );
  }
}
