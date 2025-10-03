import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../../core/core.dart';
import '../../../auth/data/models/user_model.dart';

class MentorTileWidget extends StatelessWidget {
  final UserModel mentor;
  final void Function()? onTap;
  final bool showRatingAndReview;
  final double? imageHeight;
  final TextThemeStyleEnum? nameTextThemeStyle;

  const MentorTileWidget({
    super.key,
    required this.mentor,
    this.onTap,
    this.imageHeight,
    this.nameTextThemeStyle,
    this.showRatingAndReview = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAvatarWidget(
            imageUrl: mentor.avatar ?? "",
            height: imageHeight ?? 48.w,
            width: imageHeight ?? 48.w,
          ),
          Gap(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextWidget(
                  text: mentor.fullName ?? "",
                  maxLines: 1,
                  textThemeStyle:
                      nameTextThemeStyle ?? TextThemeStyleEnum.titleSmall,
                  fontWeight: FontWeight.w600,
                  color: Get.theme.colorScheme.inverseSurface,
                ),
                if ((mentor.bio ?? "").isNotEmpty) ...{
                  CustomTextWidget(
                    text: mentor.bio ?? "",
                    maxLines: 1,
                    textThemeStyle: TextThemeStyleEnum.bodyMedium,
                    color: Get.theme.colorScheme.tertiaryContainer,
                  ),
                },
              ],
            ),
          ),
        ],
      ),
    );
  }
}
