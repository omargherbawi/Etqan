import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomRichText extends StatelessWidget {
  final String firstText;
  final String clickableText;
  final Function()? onTap;

  const CustomRichText({
    super.key,
    required this.firstText,
    required this.clickableText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "${firstText.tr(context: context)} ",
            style: Theme.of(context).textTheme.displaySmall,
          ),
          TextSpan(
            text: clickableText.tr(context: context),
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w700,
              fontSize: 16.sp,
            ),
            recognizer: TapGestureRecognizer()..onTap = onTap,
          ),
        ],
      ),
    );
  }
}
