import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../../core/core.dart';

class IconAndValueRowBuild extends StatelessWidget {
  final IconData? icon;
  final String? svg;
  final String value;
  final TextThemeStyleEnum? textStyle;

  const IconAndValueRowBuild({
    super.key,
    required this.value,
    this.icon,
    this.svg,
    this.textStyle,
  }) : assert(
         (icon != null && svg == null) || (icon == null && svg != null),
         'Either icon or svg must be provided, but not both.',
       );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        svg != null
            ? SvgPicture(SvgAssetLoader(svg!), height: 15.h, width: 15.h)
            : Icon(
              icon,
              size: 17.sp,
              color: Get.theme.colorScheme.tertiaryContainer,
            ),
        Gap(5.w),
        CustomTextWidget(
          text: value,
          maxLines: 1,
          textThemeStyle: textStyle ?? TextThemeStyleEnum.bodyLarge,
          color: Get.theme.colorScheme.tertiaryContainer,
        ),
      ],
    );
  }
}
