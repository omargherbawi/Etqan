import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/core.dart';

class FirstHeadingWidget extends StatelessWidget {
  final String heading;

  const FirstHeadingWidget({super.key, required this.heading});

  @override
  Widget build(BuildContext context) {
    return CustomTextWidget(
      text: heading,
      textThemeStyle: TextThemeStyleEnum.titleSmall,
      fontWeight: FontWeight.w500,
      color: Get.theme.colorScheme.inverseSurface,
    );
  }
}
