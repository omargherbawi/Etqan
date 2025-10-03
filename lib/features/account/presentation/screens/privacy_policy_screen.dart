import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/core.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "privacyPolicy"),
      body: Padding(
        padding: UIConstants.mobileBodyPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextWidget(
              text: 'Cancelation Policy',
              textThemeStyle: TextThemeStyleEnum.titleMedium,
              fontWeight: FontWeight.w500,
              color: Get.theme.primaryColor,
            ),
            CustomTextWidget(
              text:
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat',
              textThemeStyle: TextThemeStyleEnum.bodyMedium,
              color: Get.theme.colorScheme.tertiaryContainer,
              maxLines: 10,
            ),
          ],
        ),
      ),
    );
  }
}
