import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../../config/config.dart';
import '../../../../core/core.dart';
import '../../../../core/routes/route_paths.dart';
import '../../../categories/presentation/controllers/filter_courses_controller.dart';
import '../../../categories/presentation/widgets/dynamic_filter.dart';
import '../../../categories/presentation/widgets/options_filter_widget.dart';
import 'icon_and_value_row_build.dart';

import '../../data/models/course_model.dart';

class ViewAllPageBody extends StatelessWidget {
  final FilterCoursesController controller;
  final ScrollController scrollController;
  final PageController sliderPageController;
  final void Function(int)? onPageChanged;
  final int currentSliderIndex;

  const ViewAllPageBody({
    super.key,
    required this.controller,
    required this.scrollController,
    required this.sliderPageController,
    required this.currentSliderIndex,
    this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Gap(20.h),
        // Filters row.
        // OptionAndFilterRow(controller: controller),
        // Gap(8.h),
        // Main content.
        Expanded(
          child: Obx(() {
            if (controller.courses.isEmpty &&
                controller.featuredCourses.isEmpty &&
                !controller.isLoading.value) {
              return emptyState(
                AssetPaths.noResultFound,
                "dataNotFound",
                "dataNotFoundDesc",
              );
            }
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Featured Courses section.
                  if (controller.featuredCourses.isNotEmpty) ...[
                    // HomeWidget.titleAndMore("featuredClasses", isViewAll: false),
                    SizedBox(
                      width: Get.width,
                      height: 215.h,
                      child: PageView(
                        controller: sliderPageController,
                        onPageChanged: onPageChanged,
                        physics: const BouncingScrollPhysics(),
                        // children: List.generate(
                        //   controller.featuredCourses.length,
                        //   (index) => courseSliderItem(controller.featuredCourses[index]),
                        // ),
                      ),
                    ),
                    Gap(18.h),
                    // Indicator dots.
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        controller.featuredCourses.length,
                        (index) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: currentSliderIndex == index ? 16.w : 7.w,
                            height: 7.h,
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                              color: Get.theme.primaryColor,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          );
                        },
                      ),
                    ),
                    Gap(14.h),
                  ],
                  SizedBox(
                    width: Get.width,
                    child: Column(
                      children: [
                        if (controller.isLoading.value &&
                            controller.courses.isEmpty) ...{
                          const LoadingAnimation(),
                        } else ...{
                          ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.symmetric(horizontal: 21.w),
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.courses.length,
                            itemBuilder: (context, index) {
                              final course = controller.courses[index];

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: ViewAllCourseBuild(course: course),
                              );
                            },
                          ),
                          if (controller.isFetchingMoreData.value)
                            const Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: LoadingAnimation(),
                            ),
                        },
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}

class OptionAndFilterRow extends StatelessWidget {
  final FilterCoursesController controller;

  const OptionAndFilterRow({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: UIConstants.mobileBodyPadding,
      child: Row(
        children: [
          // Options button.
          Expanded(
            child: CustomButton(
              onPressed: () async {
                var res = await baseBottomSheet(child: const OptionsFilter());
                if (res != null && res) {
                  controller.refreshData();
                }
              },
              width: Get.width,
              height: 48,
              text: "options",
              backgroundColor: Colors.transparent,
              borderColor: Get.theme.primaryColor,
              borderRadius: 15,
            ),
          ),
          Gap(18.w),
          // Filters button.
          Expanded(
            child: CustomButton(
              onPressed: () async {
                if (controller.filters.isNotEmpty) {
                  var res = await baseBottomSheet(
                    child: const DynamicllyFilter(),
                  );

                  if (res != null && res) {
                    controller.refreshData();
                  }
                }
              },
              width: Get.width,
              height: 48,
              text: "filters",
              backgroundColor: Colors.transparent,
              borderColor:
                  controller.filters.isEmpty
                      ? Get.theme.primaryColor.withValues(alpha: 0.35)
                      : Get.theme.primaryColor,
              borderRadius: 15,
            ),
          ),
        ],
      ),
    );
  }
}

class ViewAllCourseBuild extends StatelessWidget {
  final CourseModel course;

  const ViewAllCourseBuild({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          RoutePaths.courseDetailScreen,
          arguments: {
            "isBundle": course.type == "bundle",
            "id": course.id,
            "isPrivate": course.isPrivate == 1 ? true : false,
          },
        );
      },
      child: Container(
        padding: EdgeInsets.all(5.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(UIConstants.radius12),
          border: Border.all(color: Get.theme.colorScheme.surface),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Row(
              children: [
                Container(
                  height: 90.h,
                  width: 110.h,
                  decoration: BoxDecoration(
                    color: Get.theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(UIConstants.radius8),
                  ),
                  child: CustomCachedImage(
                    image: course.image ?? "",
                    fit: BoxFit.fill,
                  ),
                ),
                Gap(10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomTextWidget(
                        text: "${course.title}",
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        textThemeStyle: TextThemeStyleEnum.titleSmall,
                        fontWeight: FontWeight.w500,
                        color: Get.theme.colorScheme.inverseSurface,
                      ),

                      Gap(3.h),
                      CustomTextWidget(
                        text: course.classSemester ?? "",
                        textThemeStyle: TextThemeStyleEnum.bodyMedium,
                        maxLines: 2,
                      ),
                      IconAndValueRowBuild(
                        svg: AssetPaths.personGrey,
                        value: course.teacher?.fullName ?? "",
                      ),
                      Gap(5.h),
                      // Row(
                      //   children: [
                      //     CustomTextWidget(
                      //       text: course.price == 0 ? "free" : course.priceString ?? "",
                      //       maxLines: 1,
                      //       textAlign: TextAlign.start,
                      //       textThemeStyle: TextThemeStyleEnum.titleSmall,
                      //       fontWeight: FontWeight.w500,
                      //       color: Get.theme.primaryColor,
                      //     ),
                      //     const Spacer(),
                      //     getBadge(course),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
