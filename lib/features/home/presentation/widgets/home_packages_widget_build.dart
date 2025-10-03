import '../../../../config/app_colors.dart';
import '../../../../core/enums/text_style_enum.dart';
import '../../../../core/services/url_launcher_service.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/utils/shared.dart';
import '../../../../core/widgets/custom_cached_image.dart';
import '../../../../core/widgets/custom_text_widget.dart';
import '../../../courses/data/models/packages/datum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class HomePackagesBuild extends StatelessWidget {
  final List<Datum> packages;

  const HomePackagesBuild({super.key, required this.packages});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Responsive.isTablet ? 300.h : 240.h,
      child: ListView.separated(
        separatorBuilder: (context, index) => SizedBox(width: 16.w),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        scrollDirection: Axis.horizontal,
        itemCount: packages.length,
        itemBuilder: (context, index) {
          final package = packages[index];
          return SizedBox(
            width: 220.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () async {
                    await LaunchUrlService.openWeb(context, package.link ?? "");
                  },
                  child: Container(
                    width: double.infinity,
                    height: Responsive.isTablet ? 200.h : 143.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(UIConstants.radius12),
                      color: Get.theme.colorScheme.inversePrimary,
                    ),
                    child: CustomCachedImage(
                      image: package.image ?? "",
                      fit: BoxFit.cover,
                      borderRadius: BorderRadius.circular(UIConstants.radius12),

                      width: double.infinity,
                    ),
                  ),
                ),
                Gap(8.h),
                CustomTextWidget(
                  text: package.name ?? "",
                  maxLines: 1,
                  textAlign: TextAlign.start,
                  textThemeStyle: TextThemeStyleEnum.titleSmall,
                  fontWeight: FontWeight.w500,
                  color: Get.theme.colorScheme.inverseSurface,
                ),
                Gap(8.h),
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
          );
        },
      ),
    );
  }
}
