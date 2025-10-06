import 'package:etqan_edu_app/config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemes {
  static final lightTheme = ThemeData(
    unselectedWidgetColor: AppLightColors.primaryColor,
    scaffoldBackgroundColor: AppLightColors.whiteColor,
    primaryColor: AppLightColors.primaryColor,
    listTileTheme: const ListTileThemeData().copyWith(iconColor: Colors.black),
    colorScheme: ColorScheme.light(
      brightness: Brightness.light,
      primary: AppLightColors.primaryColor,
      secondary: AppLightColors.secondaryColor,
      surface: AppLightColors.appBackgroundColor,
      onSurface: AppLightColors.whiteColor,
      primaryContainer: AppLightColors.grayColor,
      secondaryContainer: AppLightColors.lightGrayColor,
      error: AppLightColors.redColor,
      tertiary: AppLightColors.greenColor,
      inverseSurface: const Color(0XFF242424),
      shadow: const Color(0x0fff4f4f),
      onSecondaryContainer: AppLightColors.cardBackgroundColor,
      onTertiaryContainer: AppLightColors.cardWhiteColor,
      tertiaryContainer: AppLightColors.darkGrayColor,
      inversePrimary: AppLightColors.settingCardBackground,
    ),

    appBarTheme: const AppBarTheme().copyWith(
      iconTheme: const IconThemeData(color: Colors.black),
    ),
    bottomSheetTheme: const BottomSheetThemeData().copyWith(
      backgroundColor: Colors.white,
      dragHandleColor: AppLightColors.grayTextColor,
    ),
    shadowColor: AppLightColors.grayColor,

    textTheme: TextTheme(
      labelSmall: GoogleFonts.cairo(
        textStyle: TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.w400,
          color: AppLightColors.darkGrayColor,
          height: 0.0.h,
          letterSpacing: 0,
        ),
      ),
      labelMedium: GoogleFonts.cairo(
        textStyle: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w400,
          color: AppLightColors.darkGrayColor,
          height: 0.0.h,
          letterSpacing: 0,
        ),
      ),
      labelLarge: GoogleFonts.cairo(
        textStyle: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w400,
          color: AppLightColors.darkGrayColor,
          height: 0.0.h,
          letterSpacing: 0,
        ),
      ),
      bodySmall: GoogleFonts.cairo(
        textStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w400,
          color: AppLightColors.darkGrayColor,
          height: 0.0.h,
          letterSpacing: 0,
        ),
      ),
      bodyMedium: GoogleFonts.cairo(
        textStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppLightColors.textColor,
          height: 0.h,
          letterSpacing: 0,
        ),
      ),
      bodyLarge: GoogleFonts.cairo(
        textStyle: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: AppLightColors.textColor,
          height: 0.h,
          letterSpacing: 0,
        ),
      ),
      titleSmall: GoogleFonts.cairo(
        textStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppLightColors.darkGrayColor,
          height: 0.0.h,
        ),
      ),
      titleMedium: GoogleFonts.cairo(
        textStyle: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: AppLightColors.darkGrayColor,
          height: 0.0.h,
        ),
      ),
      titleLarge: GoogleFonts.cairo(
        textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppLightColors.textColor,
          height: 0.h,
        ),
      ),
      displayMedium: GoogleFonts.cairo(
        textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppLightColors.darkGrayColor,
          height: 0.0.h,
        ),
      ),
      displayLarge: GoogleFonts.cairo(
        textStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppLightColors.textColor,
          height: 0.0.h,
        ),
      ),
      headlineSmall: GoogleFonts.cairo(
        textStyle: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: AppLightColors.textColor,
          height: 0.0.h,
        ),
      ),
      headlineMedium: GoogleFonts.cairo(
        textStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: AppLightColors.textColor,
          height: 0.0.h,
        ),
      ),
      headlineLarge: GoogleFonts.cairo(
        textStyle: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: AppLightColors.textColor,
          height: 0.0.h,
        ),
      ),
    ),
  );

  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: AppDarkColors.backgroundColor,
    primaryColor: AppDarkColors.primaryColor,
    colorScheme: ColorScheme.dark(
      brightness: Brightness.light,
      primary: AppDarkColors.primaryColor,
      secondary: AppDarkColors.secondaryColor,
      surface: AppDarkColors.backgroundColor,
      primaryContainer: AppDarkColors.grayColor,
      secondaryContainer: AppDarkColors.lightGrayColor,
      //temp dark gray
      shadow: AppDarkColors.darkGrayColor,
      // onSecondary: AppDarkColors.whiteColor,
      error: AppDarkColors.redColor,
      tertiary: AppDarkColors.greenColor,

      //fonts
      onPrimary: AppDarkColors.textColor,
      onSecondary: AppDarkColors.textLightColor,
      onInverseSurface: AppDarkColors.whiteColor,

      //Cards
      onPrimaryContainer: AppDarkColors.cardHeaderColor,
      onSecondaryContainer: AppDarkColors.cardBackgroundColor,
      onTertiaryContainer: AppDarkColors.cardWhiteColor,

      //scaffoldBackground
      tertiaryContainer: AppDarkColors.backgroundColor,

      //settingCardColor
      inversePrimary: AppDarkColors.settingCardBackground,
    ),
    iconTheme: const IconThemeData().copyWith(
      color: AppDarkColors.primaryColor,
    ),
    // bottomSheetTheme: const BottomSheetThemeData(
    //   backgroundColor: AppDarkColors.backgroundColor,
    // ),
    shadowColor: AppDarkColors.grayColor,
    textTheme: TextTheme(
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppDarkColors.darkGrayColor,
        height: 0.0.h,
      ),
      displaySmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppDarkColors.darkGrayColor,
        height: 0.0.h,
      ),
      displayMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppDarkColors.grayColor,
        height: 0.0.h,
      ),
      displayLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: AppDarkColors.textColor,
        height: 0.0.h,
      ),
      headlineMedium: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: AppLightColors.grayColor,
        height: 0.0.h,
      ),
      headlineLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: AppLightColors.grayColor,
        height: 0.0.h,
      ),
    ),
  );
}
