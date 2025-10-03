import 'package:tedreeb_edu_app/core/enums/text_style_enum.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../config/app_colors.dart';

// Enum for TextTheme styles

class CustomTextWidget extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final int? maxLines;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final double? letterSpacing;
  final String? fontFamily;
  final TextOverflow? overflow;
  final double? height;
  final TextDecoration? decoration;
  final Color? decorationColor;
  final double? decorationThickness;
  final TextDecorationStyle? decorationStyle;
  final TextDirection? textDirection;
  final String? toolTipText;
  final TextThemeStyleEnum? textThemeStyle;
  final bool isLocalize;

  const CustomTextWidget({
    super.key,
    required this.text,
    this.textAlign,
    this.maxLines,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.letterSpacing,
    this.fontFamily,
    this.overflow,
    this.height,
    this.decoration,
    this.decorationColor,
    this.decorationThickness,
    this.decorationStyle,
    this.textDirection,
    this.toolTipText,
    this.textThemeStyle,
    this.isLocalize = true,
  });

  TextStyle _buildTextStyle(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    TextStyle baseStyle;
    if (fontSize != null) {
      baseStyle = textTheme.displayMedium ?? const TextStyle();
    } else {
      switch (textThemeStyle) {
        case TextThemeStyleEnum.labelSmall:
          baseStyle = textTheme.labelSmall ?? const TextStyle();
          break;
        case TextThemeStyleEnum.labelMedium:
          baseStyle = textTheme.labelMedium ?? const TextStyle();
          break;
        case TextThemeStyleEnum.labelLarge:
          baseStyle = textTheme.labelLarge ?? const TextStyle();
          break;
        case TextThemeStyleEnum.bodySmall:
          baseStyle = textTheme.bodySmall ?? const TextStyle();
          break;
        case TextThemeStyleEnum.bodyMedium:
          baseStyle = textTheme.bodyMedium ?? const TextStyle();
          break;
        case TextThemeStyleEnum.bodyLarge:
          baseStyle = textTheme.bodyLarge ?? const TextStyle();
          break;
        case TextThemeStyleEnum.titleSmall:
          baseStyle = textTheme.titleSmall ?? const TextStyle();
          break;
        case TextThemeStyleEnum.titleMedium:
          baseStyle = textTheme.titleMedium ?? const TextStyle();
          break;
        case TextThemeStyleEnum.titleLarge:
          baseStyle = textTheme.titleLarge ?? const TextStyle();
          break;
        case TextThemeStyleEnum.headlineSmall:
          baseStyle = textTheme.headlineSmall ?? const TextStyle();
          break;
        case TextThemeStyleEnum.displayLarge:
          baseStyle = textTheme.displayLarge ?? const TextStyle();
          break;
        case TextThemeStyleEnum.headlineMedium:
          baseStyle = textTheme.headlineMedium ?? const TextStyle();
          break;
        case TextThemeStyleEnum.headlineLarge:
          baseStyle = textTheme.headlineLarge ?? const TextStyle();
          break;
        default:
          baseStyle = textTheme.displayMedium ?? const TextStyle();
          break;
      }
    }

    // Always use Cairo font
    final cairoStyle = GoogleFonts.ibmPlexSansArabic(
      textStyle: baseStyle.copyWith(
        fontSize: fontSize?.sp ?? baseStyle.fontSize?.sp,
        fontWeight: fontWeight ?? baseStyle.fontWeight,
        color: color ?? baseStyle.color,
        letterSpacing: letterSpacing ?? 0,
        height: height?.sp ?? 0.0.sp,
        decoration: decoration ?? TextDecoration.none,
        decorationColor: decorationColor ?? color,
        decorationThickness: decorationThickness ?? 1.5,
        decorationStyle: decorationStyle ?? TextDecorationStyle.solid,
      ),
    );
    return cairoStyle;
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: toolTipText ?? '',
      textStyle: Theme.of(context).textTheme.displayMedium!.copyWith(
        color: AppLightColors.appBackgroundColor,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Text(
        isLocalize ? text.tr(context: context) : text,
        textAlign: textAlign ?? TextAlign.start,
        maxLines: maxLines ?? 1,
        overflow: overflow ?? TextOverflow.ellipsis,
        style: _buildTextStyle(context),
      ),
    );
  }
}
