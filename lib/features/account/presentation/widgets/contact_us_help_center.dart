import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart' hide Trans;
import '../../../../config/constants.dart';
import '../../../../core/core.dart';
import '../../../../core/services/url_launcher_service.dart';

class ContactUsModel {
  final String source;
  final String value;
  final IconData icon;

  ContactUsModel({
    required this.source,
    required this.value,
    required this.icon,
  });
}

class ContactUsHelpCenterBuild extends StatelessWidget {
  const ContactUsHelpCenterBuild({super.key});

  @override
  Widget build(BuildContext context) {
    // Build your contacts list using translations if needed.
    final List<ContactUsModel> contacts = [
      ContactUsModel(
        source: "phone".tr(),
        value: AppConstants.contactUsPhoneNumber,
        icon: Icons.phone,
      ),
      ContactUsModel(
        source: "whatsapp".tr(),
        value: "0796333245",
        icon: Icons.call,
      ),
      ContactUsModel(
        source: "instagram".tr(),
        value: "Instagram",
        icon: Icons.camera_alt,
      ),
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Gap(10.h),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: contacts.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildContactTile(context, contacts[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildContactTile(BuildContext context, ContactUsModel contact) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: Get.theme.colorScheme.onSecondaryContainer,
          width: 2,
        ),
      ),
      margin: EdgeInsets.only(bottom: 8.h),
      child: ListTile(
        leading: Icon(contact.icon, size: 25.sp, color: Get.theme.primaryColor),
        title: CustomTextWidget(
          text: contact.source,
          textThemeStyle: TextThemeStyleEnum.titleLarge,
        ),
        subtitle: CustomTextWidget(
          text: contact.value,
          textThemeStyle: TextThemeStyleEnum.bodyMedium,
          color: Get.theme.colorScheme.tertiaryContainer,
        ),
        onTap: () => _handleContactTap(context, contact),
      ),
    );
  }

  void _handleContactTap(BuildContext context, ContactUsModel contact) {
    final String lowerSource = contact.source.toLowerCase();
    if (lowerSource.contains("phone") || lowerSource.contains("رقم الهاتف")) {
      // For phone numbers, open WhatsApp.
      LaunchUrlService.openWhatsapp(context);
    } else if (lowerSource.contains("facebook")) {
      // For Facebook, open the Facebook URL.
      LaunchUrlService.openWeb(context, AppConstants.facebookUrl);
    } else if (lowerSource.contains("instagram")) {
      // For Instagram, open the Instagram URL.
      LaunchUrlService.openWeb(context, AppConstants.instagramUrl);
    } else {
      ToastUtils.showError("Unsupported contact type".tr());
    }
  }
}
