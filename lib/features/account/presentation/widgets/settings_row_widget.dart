import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../../core/core.dart';

class SettingsRowWidget extends StatelessWidget {
  final Function()? onTap;
  final Widget leadingWidget;
  final String text;
  final Color? textColor;
  final Widget trailingWidget;
  final EdgeInsetsGeometry? padding;
  final FontWeight? textWeight;

  const SettingsRowWidget({
    super.key,
    required this.leadingWidget,
    this.textColor,
    required this.text,
    required this.trailingWidget,
    this.padding,
    this.onTap,
    this.textWeight,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: padding ?? const EdgeInsets.all(0.0),
        child: Row(
          children: [
            leadingWidget,
            SizedBox(width: 12.w),
            Expanded(
              child: CustomTextWidget(
                text: text,
                // fontSize: 14,
                fontWeight: textWeight ?? FontWeight.w400,
                textThemeStyle: TextThemeStyleEnum.displayLarge,
                color: textColor ?? Get.theme.colorScheme.inverseSurface,
                maxLines: 1,
              ),
            ),
            trailingWidget,
          ],
        ),
      ),
    );
  }
}
