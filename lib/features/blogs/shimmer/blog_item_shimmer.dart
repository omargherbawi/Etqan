import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../core/core.dart';
import 'package:shimmer/shimmer.dart';

class BlogItemShimmer extends StatelessWidget {
  const BlogItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: ShimmerConstants.baseColor,
      highlightColor: ShimmerConstants.highlightColor,
      child: Container(
        width: Get.width,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // image
            shimmerUi(height: 200, width: Get.width, radius: 10.r),

            const Gap(16),

            // title
            shimmerUi(height: 8, width: Get.width * .6),

            const Gap(20),

            // desc
            shimmerUi(height: 8, width: Get.width),

            const Gap(8),

            // desc
            shimmerUi(height: 8, width: Get.width),

            const Gap(8),

            // desc
            shimmerUi(height: 8, width: Get.width * .3),

            const Gap(24),

            Row(
              children: [
                shimmerUi(height: 8, width: 50),
                const Gap(20),
                shimmerUi(height: 8, width: 50),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
