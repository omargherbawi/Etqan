import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../config/app_colors.dart';

import 'settings_row_widget.dart';

class IconAndTextTTile extends StatelessWidget {
  final String? iconPath;
  final IconData? icon;
  final String text;
  final Color? textColor;
  final Color? svgColor;
  final bool hideArrow;
  final FontWeight? textWeight;
  final Color? iconColor;
  final Function()? onTap;
  final EdgeInsetsGeometry? padding;

  const IconAndTextTTile({
    super.key,
    this.svgColor,
    this.textColor,

    this.iconPath,
    this.icon,
    this.hideArrow = false,
    required this.text,
    this.iconColor,
    this.padding,
    this.onTap,
    this.textWeight,
  }) : assert(iconPath != null || icon != null);

  @override
  Widget build(BuildContext context) {
    return SettingsRowWidget(
      padding: padding ?? EdgeInsets.symmetric(vertical: 5.h),
      onTap: onTap,
      leadingWidget:
          iconPath != null
              ? SvgPicture.asset(
                iconPath!,
                width: 24.w,
                height: 24.h,

                color: svgColor ?? Get.theme.colorScheme.primary,
              )
              : Icon(
                icon,
                size: 20.sp,
                color: iconColor ?? Get.theme.colorScheme.primary,
              ),
      text: text,
      textWeight: textWeight ?? FontWeight.w400,
      textColor: textColor ?? Get.theme.colorScheme.inverseSurface,
      trailingWidget:
          hideArrow
              ? const SizedBox.shrink()
              : Icon(
                Icons.arrow_forward_ios,
                size: 16.w,
                color: Get.theme.primaryColor,
              ),
    );
  }
}

class IconAndTextSwitch extends StatelessWidget {
  final String? iconPath;
  final IconData? icon;
  final String text;
  final bool value;
  final ValueChanged<bool> onChanged;

  const IconAndTextSwitch({
    super.key,
    this.iconPath,
    this.icon,
    required this.text,
    required this.value,
    required this.onChanged,
  }) : assert(iconPath != null || icon != null);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: SettingsRowWidget(
          leadingWidget:
              iconPath != null
                  ? SvgPicture.asset(
                    iconPath!,
                    color: Get.theme.primaryColor,
                    height: 25.w,
                    width: 25.w,
                  )
                  : Icon(icon, size: 25.w, color: Get.theme.primaryColor),
          text: text,
          trailingWidget: Switch(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
            value: value,
            onChanged: onChanged,
            activeColor: Get.theme.colorScheme.primary,
            inactiveThumbColor: Get.theme.colorScheme.onSurface,
            inactiveTrackColor: SharedColors.inActiveSwitchColor,
          ),
        ),
      ),
    );
  }
}
