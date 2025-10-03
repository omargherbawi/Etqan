import 'package:flutter/material.dart';
import '../../../../core/utils/shared.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreenShimmerLoading extends StatelessWidget {
  const HomeScreenShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Section: Row with heading and "View All" button shimmer
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: UIConstants.horizontalPaddingValue,
            vertical: 10.h,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _shimmerBox(width: 120.w, height: 24.h), // Heading shimmer
              _shimmerBox(width: 60.w, height: 20.h), // Button shimmer
            ],
          ),
        ),
        SizedBox(height: 16.h),

        // Horizontal list of circular category placeholders
        SizedBox(
          height: 105.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(
              horizontal: UIConstants.horizontalPaddingValue,
            ),
            itemCount: 5, // Dummy count for shimmer placeholders
            itemBuilder:
                (context, index) =>
                    Column(children: [_shimmerCircle(size: 64.w)]),
            separatorBuilder: (context, index) => SizedBox(width: 24.w),
          ),
        ),
        SizedBox(height: 24.h),

        // Section title for "Latest Courses"
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: UIConstants.horizontalPaddingValue,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _shimmerBox(width: 140.w, height: 24.h), // "Latest Courses"
              _shimmerBox(width: 60.w, height: 20.h), // "View All"
            ],
          ),
        ),
        SizedBox(height: 16.h),

        // Horizontal list of course card placeholders
        SizedBox(
          height: 225.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(
              horizontal: UIConstants.horizontalPaddingValue,
            ),
            itemCount: 3, // Dummy count for shimmer placeholders
            itemBuilder: (context, index) => _shimmerCourseCard(),
            separatorBuilder: (context, index) => SizedBox(width: 16.w),
          ),
        ),
        SizedBox(height: 24.h),

        // Section title for "Latest Courses"
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: UIConstants.horizontalPaddingValue,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _shimmerBox(width: 140.w, height: 24.h), // "Latest Courses"
              _shimmerBox(width: 60.w, height: 20.h), // "View All"
            ],
          ),
        ),
        SizedBox(height: 16.h),

        SizedBox(
          height: 225.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(
              horizontal: UIConstants.horizontalPaddingValue,
            ),
            itemCount: 3, // Dummy count for shimmer placeholders
            itemBuilder: (context, index) => _shimmerCourseCard(),
            separatorBuilder: (context, index) => SizedBox(width: 16.w),
          ),
        ),
      ],
    );
  }

  // Shimmer for a rectangular box
  Widget _shimmerBox({required double width, required double height}) {
    return Shimmer.fromColors(
      baseColor: ShimmerConstants.baseColor,
      highlightColor: ShimmerConstants.highlightColor,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: ShimmerConstants.baseColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }

  // Shimmer for circular icons
  Widget _shimmerCircle({required double size}) {
    return Shimmer.fromColors(
      baseColor: ShimmerConstants.baseColor,
      highlightColor: ShimmerConstants.highlightColor,
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: ShimmerConstants.baseColor,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  // Shimmer for a course card
  Widget _shimmerCourseCard() {
    return Shimmer.fromColors(
      baseColor: ShimmerConstants.baseColor,
      highlightColor: ShimmerConstants.highlightColor,
      child: Container(
        width: 220.w,
        decoration: BoxDecoration(
          color: ShimmerConstants.baseColor,
          borderRadius: BorderRadius.circular(UIConstants.radius12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Placeholder for course image
            Container(
              height: 133.h,
              decoration: BoxDecoration(
                color: ShimmerConstants.baseColor,
                borderRadius: BorderRadius.circular(UIConstants.radius12),
              ),
            ),
            SizedBox(height: 8.h),
            // Placeholder for course title and duration
            _shimmerBox(width: 140.w, height: 16.h),
            SizedBox(height: 6.h),
            _shimmerBox(width: 100.w, height: 14.h),
            SizedBox(height: 10.h),
            // Placeholder for price and badge
            Row(
              children: [
                _shimmerBox(width: 60.w, height: 14.h), // Price
                const Spacer(),
                _shimmerBox(width: 40.w, height: 14.h), // Badge
              ],
            ),
          ],
        ),
      ),
    );
  }
}
