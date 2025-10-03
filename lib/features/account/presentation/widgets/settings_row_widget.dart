import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/core.dart';

class SettingsRowWidget extends StatelessWidget {
  final Function()? onTap;
  final Widget leadingWidget;
  final String text;
  final Widget trailingWidget;
  final EdgeInsetsGeometry? padding;

  const SettingsRowWidget({
    super.key,
    required this.leadingWidget,
    required this.text,
    required this.trailingWidget,
    this.padding,
    this.onTap,
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
                fontWeight: FontWeight.w400,
                textThemeStyle: TextThemeStyleEnum.displayLarge,
                // color: Get.theme.colorScheme.inverseSurface,
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
