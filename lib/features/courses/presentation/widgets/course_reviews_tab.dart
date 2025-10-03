import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../../config/config.dart';
import '../../../../core/core.dart';
import '../../../../core/utils/date_utils.dart';
import '../controllers/course_detail_controller.dart';
import '../../data/models/single_course_model.dart';

import 'first_heading_widget.dart';

class CourseReviewsTab extends StatefulWidget {
  const CourseReviewsTab({super.key});

  @override
  State<CourseReviewsTab> createState() => _CourseReviewsTabState();
}

class _CourseReviewsTabState extends State<CourseReviewsTab> {
  final courseController = Get.find<CourseDetailController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: UIConstants.horizontalPaddingValue,
        // vertical: UIConstants.horizontalPaddingValue,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              const FirstHeadingWidget(heading: "reviews"),
              Gap(5.w),
              CustomTextWidget(
                text:
                    "(${courseController.singleCourseData.value.reviewsCount})",
                textThemeStyle: TextThemeStyleEnum.titleSmall,
                fontWeight: FontWeight.w500,
                color: Get.theme.primaryColor,
              ),
            ],
          ),
          Gap(15.h),
          Expanded(
            child:
                courseController.singleCourseData.value.reviews?.isNotEmpty ==
                        true
                    ? ListView.separated(
                      separatorBuilder: (context, index) {
                        return const SizedBox.shrink();
                      },
                      itemBuilder: (context, index) {
                        final reviews =
                            courseController.singleCourseData.value.reviews;
                        if (reviews != null && index < reviews.length) {
                          final review = reviews[index];
                          log(review.toString());
                          return buildReviewsList(review);
                        }
                        return const SizedBox.shrink();
                      },
                      itemCount:
                          courseController
                              .singleCourseData
                              .value
                              .reviews
                              ?.length ??
                          0,
                    )
                    : Center(
                      child: CustomTextWidget(
                        text: "no_reviews_available".tr,
                        textThemeStyle: TextThemeStyleEnum.bodyLarge,
                        color: Get.theme.colorScheme.tertiaryContainer,
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  Widget buildReviewsList(ReviewModel review) {
    return Column(
      children: [
        Gap(5.h),
        Row(
          children: [
            CustomAvatarWidget(
              imageUrl: AssetPaths.dashFromNetwork,
              height: 36.h,
              width: 36.w,
            ),
            Gap(8.w),
            Expanded(
              child: FirstHeadingWidget(
                heading: review.user?.fullName ?? "user",
              ),
            ),
            Gap(8.w),
            CustomTextWidget(
              text: timeStampToDate(review.createdAt ?? 0),
              textThemeStyle: TextThemeStyleEnum.bodyMedium,
              color: Get.theme.colorScheme.tertiaryContainer,
            ),
          ],
        ),
        Gap(8.h),
        CustomTextWidget(
          text: review.description ?? "",
          maxLines: 3,
          textAlign: TextAlign.start,
          textThemeStyle: TextThemeStyleEnum.bodyMedium,
          color: Get.theme.colorScheme.tertiaryContainer,
        ),
        Gap(5.h),
        Row(
          children: [
            Row(
              children: List.generate(
                4,
                (index) => Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: 17.sp,
                      color: AppLightColors.orangeColor,
                    ),
                    Gap(5.w),
                  ],
                ),
              ),
            ),
            Gap(5.w),
            CustomTextWidget(
              text: review.rate ?? "",
              textThemeStyle: TextThemeStyleEnum.titleSmall,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      ],
    );
  }
}
