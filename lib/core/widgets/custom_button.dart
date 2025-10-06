import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:etqan_edu_app/config/app_colors.dart';

import '../enums/text_style_enum.dart';
import '../utils/shared.dart';
import 'custom_text_widget.dart';

class CustomButton extends StatelessWidget {
  final void Function()? onPressed;

  final Color? backgroundColor;
  final Color? borderColor;
  final double? fontSize;
  final Widget? child;
  final double? height;
  final double? width;
  final double? elevation;
  final double borderRadius;
  final Widget? icon;
  final String? label;
  final bool? darkText;
  final bool circular;
  final String? text;

  const CustomButton({
    super.key,
    this.onPressed,
    this.backgroundColor,
    this.borderColor,
    this.fontSize,
    this.child,
    this.circular = false,
    this.height = 48,
    this.width,
    this.elevation,
    this.borderRadius = 10.0,
    this.icon,
    this.label,
    this.darkText,
    this.text,
  });

  const CustomButton.outline({
    super.key,
    this.onPressed,
    this.backgroundColor,
    this.borderColor,
    this.fontSize,
    this.child,
    this.circular = false,
    this.height = 40,
    this.width,
    this.elevation,
    this.borderRadius = 10.0,
    this.icon,
    this.label,
    this.darkText,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child:
          icon != null && label != null
              ? ElevatedButton.icon(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  elevation: elevation ?? 0,
                  backgroundColor:
                      backgroundColor ?? Theme.of(context).primaryColor,
                  side:
                      borderColor != null
                          ? BorderSide(
                            color:
                                borderColor ??
                                Theme.of(context).colorScheme.onSurface,
                            width: 1,
                          )
                          : null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                ),
                label: CustomTextWidget(text: label ?? ""),
                icon: icon!,
              )
              : ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  elevation: elevation ?? 0,
                  backgroundColor:
                      backgroundColor ?? Theme.of(context).primaryColor,
                  side:
                      borderColor != null
                          ? BorderSide(
                            color:
                                borderColor ??
                                Theme.of(context).colorScheme.onSurface,
                            width: 1,
                          )
                          : null,
                  // padding: EdgeInsets.all(15),
                  shape:
                      circular
                          ? const CircleBorder()
                          : RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(borderRadius),
                          ),
                ),
                child:
                    text != null ? CustomTextWidget(text: text ?? "") : child,
              ),
    );
  }

  static Widget buttonText(String text) {
    return CustomTextWidget(
      text: text,
      textThemeStyle: TextThemeStyleEnum.titleLarge,
      color: Get.theme.colorScheme.onSurface,
    );
  }
}

class RoundedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Widget child;
  final double? height;
  final double? width;

  final double borderRadius;

  const RoundedButton({
    super.key,
    required this.onPressed,
    this.backgroundColor,
    required this.child,
    this.height,
    this.width,
    this.borderRadius = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width ?? double.infinity,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: backgroundColor ?? Theme.of(context).primaryColor,
            shape: BoxShape.circle,
          ),
          child: child,
        ),
      ),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final void Function()? onTap;
  final Color? color;
  final String? svg;
  final IconData? icon;
  final bool showNotification;
  final Color? iconColor;
  final Color? notificationColor;
  final double? height;
  final double? width;
  final double? iconSize;

  const CustomIconButton({
    super.key,
    this.onTap,
    this.color,
    this.icon,
    this.svg,
    this.height,
    this.width,
    this.iconSize,
    this.showNotification = false,
    this.iconColor,
    this.notificationColor,
  }) : assert(svg != null || icon != null);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: height ?? 46,
          height: width ?? 46,
          decoration: BoxDecoration(
            color:
                color ??
                Get.theme.colorScheme.onSecondaryContainer.withAlpha(50),
            borderRadius: UIConstants.circularRadius10,
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child:
                    svg != null
                        ? SvgPicture.asset(
                          svg!,
                          colorFilter: ColorFilter.mode(
                            iconColor ?? Get.theme.colorScheme.onSurface,
                            BlendMode.srcIn,
                          ),
                        )
                        : Icon(
                          icon,
                          size: iconSize ?? 32,
                          color: iconColor ?? Get.theme.colorScheme.onSurface,
                        ),
              ),
              if (showNotification) ...{
                Positioned(
                  top: 11,
                  right: 7,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: notificationColor ?? Get.theme.colorScheme.error,
                    ),
                  ),
                ),
              },
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextButton extends StatelessWidget {
  final void Function()? onTap;
  final String text;
  final TextThemeStyleEnum? textThemeStyle;
  final Color? textColor;

  const CustomTextButton({
    super.key,
    this.onTap,
    this.textThemeStyle,
    this.textColor,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: onTap,
        splashColor: Get.theme.primaryColor.withAlpha(50),
        // highlightColor: Colors.green,
        borderRadius: BorderRadius.circular(5),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
          child: CustomTextWidget(
            text: text,
            maxLines: 1,
            textThemeStyle: textThemeStyle ?? TextThemeStyleEnum.titleSmall,
            color: textColor ?? AppLightColors.primaryColor,
          ),
        ),
      ),
    );
  }
}

class CircleIconButton extends StatelessWidget {
  final IconData? icon;
  final String? svg;
  final double? height;
  final double? width;
  final double iconSize;
  final bool greyBorder;
  final bool greyBackground;
  final Color? iconColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final void Function()? onPressed;

  const CircleIconButton({
    super.key,
    this.icon,
    this.svg,
    this.height,
    this.width,
    this.iconSize = 25,
    this.greyBackground = false,
    this.greyBorder = true,
    this.onPressed,
    this.backgroundColor,
    this.borderColor,
    this.iconColor,
  }) : assert(
         (icon != null && svg == null) || (icon == null && svg != null),
         'Either icon or svg must be provided, but not both.',
       );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 40.h,
      width: width ?? 40.w,
      child: IconButton(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: CircleBorder(
            side: BorderSide(
              color:
                  borderColor ??
                  (greyBorder
                      ? Get.theme.colorScheme.onSecondaryContainer
                      : Get.theme.colorScheme.onSurface),
            ),
          ),
          backgroundColor:
              backgroundColor ??
              (greyBackground
                  ? Get.theme.colorScheme.onSecondaryContainer
                  : Get.theme.colorScheme.onSurface),
        ),
        icon:
            svg != null
                ? SvgPicture.asset(svg!, height: 25.h, width: 25.w)
                : Icon(
                  icon,
                  size: iconSize.sp,
                  color: iconColor ?? Get.theme.primaryColor,
                ),
      ),
    );
  }
}
