import '../../../../config/app_colors.dart';
import '../../../../core/enums/text_style_enum.dart';
import '../../../../core/utils/shared.dart';
import '../../../../core/widgets/custom_text_widget.dart';
import '../../data/models/packages/datum.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class PackageCard extends StatelessWidget {
  Future<void> _launchURL(int id) async {
    if (await canLaunch("https://etqan.com/packages/package-details/$id")) {
      await launch("https://etqan.com/packages/package-details/$id");
    } else {
      throw tr('unableToOpenTheLink');
    }
  }

  final Datum package;

  const PackageCard({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _launchURL(package.id ?? 0);
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(UIConstants.radius12),
          color: Get.theme.cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(UIConstants.radius12),
              ),
              child: Image.network(
                package.image ?? '',
                height: 150.h,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder:
                    (_, __, ___) => Container(
                      height: 150.h,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.broken_image, size: 40),
                    ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextWidget(
                    text: package.name ?? '',
                    textThemeStyle: TextThemeStyleEnum.titleSmall,
                    fontWeight: FontWeight.w600,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Gap(6.h),

                  CustomTextWidget(
                    text: package.description ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textThemeStyle: TextThemeStyleEnum.bodySmall,
                    color: Colors.grey,
                  ),
                  Gap(12.h),
                  if (package.stringPrice != null) ...{
                    CustomTextWidget(
                      text: package.stringPrice!,
                      textThemeStyle: TextThemeStyleEnum.bodyMedium,
                      fontWeight: FontWeight.bold,
                      color: AppLightColors.secondaryColor,
                    ),
                  },
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
