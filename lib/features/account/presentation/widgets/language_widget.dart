import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' hide Trans;
import '../../../../config/app_colors.dart';

class LanguageWidget extends StatelessWidget {
  const LanguageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    bool isArabic = context.locale == const Locale('ar');

    return Row(
      key: ValueKey(isArabic),
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:
          isArabic
              ? [
                _buildLanguageButton(
                  context,
                  locale: const Locale('ar'),
                  text: 'العربية',
                ),
                _buildLanguageButton(
                  context,
                  locale: const Locale('en'),
                  text: 'English',
                ),
              ]
              : [
                _buildLanguageButton(
                  context,
                  locale: const Locale('en'),
                  text: 'English',
                ),
                _buildLanguageButton(
                  context,
                  locale: const Locale('ar'),
                  text: 'العربية',
                ),
              ],
    );
  }

  Widget _buildLanguageButton(
    BuildContext context, {
    required Locale locale,
    required String text,
  }) {
    bool isSelected = context.locale == locale;

    return GestureDetector(
      onTap: () async {
        if (!isSelected) {
          await Future.wait([
            context.setLocale(locale),
            Get.updateLocale(locale),
          ]);
        }
      },
      child: Container(
        width: 93.w,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? Get.theme.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isSelected ? Colors.transparent : SharedColors.greyTextColor,
            width: 1.0,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color:
                  isSelected
                      ? Theme.of(context).colorScheme.onSurface
                      : Colors.black,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
