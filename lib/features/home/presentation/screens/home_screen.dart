import 'dart:io';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart' hide Trans;
import 'package:etqan_edu_app/config/config.dart';
import 'package:etqan_edu_app/core/core.dart';
import 'package:etqan_edu_app/core/routes/route_paths.dart';
import 'package:etqan_edu_app/features/categories/presentation/controllers/filter_courses_controller.dart';
import 'package:etqan_edu_app/features/courses/presentation/controllers/free_classes_controller.dart';
import 'package:etqan_edu_app/features/courses/presentation/screens/paid_classes_screen.dart';
import 'package:etqan_edu_app/features/home/presentation/shimmers/home_loading_shimmer.dart';
import 'package:etqan_edu_app/features/home/presentation/widgets/home_courses_widget_courses_build.dart';
import 'package:etqan_edu_app/features/home/presentation/widgets/top_heading_row_build.dart';
import 'package:etqan_edu_app/features/shared/presentation/controllers/current_user_controller.dart';
import 'package:etqan_edu_app/features/shared/presentation/controllers/shared_courses_controller.dart';

import '../../../courses/presentation/controllers/user_course_controller.dart';
import '../../../courses/presentation/screens/all_packages_screen.dart';
import '../widgets/home_packages_widget_build.dart';
import '../widgets/course_in_learning_build.dart';
import '../controllers/last_opened_course_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserController = Get.find<CurrentUserController>();

    if (!Get.isRegistered<LastOpenedCourseController>()) {
      Get.put(LastOpenedCourseController());
    } else {
      Get.find<LastOpenedCourseController>().refresh();
    }

    return Scaffold(
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: UIConstants.horizontalPaddingValue,
                  vertical: 16.h,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 40.h),
                          Obx(
                            () => CustomTextWidget(
                              text:
                                  currentUserController.user?.fullName != null
                                      ? "${"hi".tr(context: context)}${currentUserController.user!.fullName!} 👋"
                                      : "dearStudent 👋",
                              color: Colors.grey,
                              maxLines: 1,
                              textThemeStyle: TextThemeStyleEnum.displayLarge,
                            ),
                          ),
                          Gap(20.h),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextWidget(
                                text: "Start",
                                color: Colors.black,
                                maxLines: 1,
                                fontWeight: FontWeight.w400,
                                textThemeStyle: TextThemeStyleEnum.titleLarge,
                                fontSize: 28.sp,
                                height: 1,
                              ),
                              Row(
                                children: [
                                  CustomTextWidget(
                                    text: "EducationalJourney",
                                    color: AppLightColors.primaryColor,
                                    maxLines: 1,
                                    fontWeight: FontWeight.w600,
                                    textThemeStyle:
                                        TextThemeStyleEnum.titleLarge,
                                    fontSize: 28.sp,
                                  ),
                                  CustomTextWidget(
                                    text: "Today",
                                    color: Colors.black,
                                    maxLines: 1,
                                    fontWeight: FontWeight.w600,
                                    textThemeStyle:
                                        TextThemeStyleEnum.titleLarge,
                                    fontSize: 28.sp,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    CustomIconButton(
                      color: Colors.transparent,
                      iconColor: AppLightColors.primaryColor,
                      svg: AssetPaths.notificationSvg,
                      height: Responsive.isTablet ? 25.sp : null,
                      width: Responsive.isTablet ? 25.sp : null,
                      onTap: () => Get.toNamed(RoutePaths.notifications),
                    ),
                  ],
                ),
              ),
              const _HomeScreenBodyContent(),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeScreenBodyContent extends StatelessWidget {
  const _HomeScreenBodyContent();

  @override
  Widget build(BuildContext context) {
    final sharedCoursesController = Get.find<SharedCoursesController>();

    return Obx(() {
      return sharedCoursesController.isLoading.value
          ? const HomeScreenShimmerLoading()
          : Column(
            children: [
              Obx(() {
                final lastCourseController =
                    Get.find<LastOpenedCourseController>();
                return Column(
                  children: [
                    if (lastCourseController.lastOpenedCourse.value !=
                        null) ...{
                      const CourseInLearningBuild(),
                      Gap(8.h),
                    },
                  ],
                );
              }),
              if (Platform.isAndroid &&
                  sharedCoursesController.paidCoursesClasses.isNotEmpty) ...{
                TopHeadingRowBuild(
                  heading: "paidClasses",
                  buttonText: "viewAll",
                  onTap: () {
                    Get.lazyPut(() => FilterCoursesController());
                    Get.lazyPut(() => UserCourseController());

                    final FreeClassesController paidCoursesController = Get.put(
                      FreeClassesController(),
                    );
                    paidCoursesController.free.value = false;

                    Get.to(() => const PaidClassesScreen());
                  },
                ),
                HomeCoursesBuild(
                  courses: sharedCoursesController.paidCoursesClasses,
                ),
              },
              Gap(8.h),

              // if (sharedCoursesController.freeCoursesClasses.isNotEmpty) ...{
              //   TopHeadingRowBuild(
              //     heading: "freeClasses",
              //     buttonText: "viewAll",
              //     onTap: () {
              //       Get.lazyPut(() => FilterCoursesController());
              //       Get.lazyPut(() => UserCourseController());

              //       final FreeClassesController bestSellerCoursesController =
              //           Get.put(FreeClassesController());
              //       bestSellerCoursesController.free.value = true;

              //       Get.to(() => const FreeClassesScreen());
              //     },
              //   ),
              //   HomeCoursesBuild(
              //     courses: sharedCoursesController.freeCoursesClasses,
              //   ),
              // },
              if (Platform.isAndroid &&
                  sharedCoursesController.packages.isNotEmpty) ...{
                TopHeadingRowBuild(
                  heading: "pakages",
                  buttonText: "viewAll",
                  onTap: () {
                    Get.to(() => const AllPackagesScreen());
                  },
                ),
                HomePackagesBuild(packages: sharedCoursesController.packages),
              },
            ],
          );
    });
  }
}

class DiamondEffectContainer extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  const DiamondEffectContainer({
    super.key,
    required this.child,
    this.width = 140,
    this.height = 160,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: width.w,
          height: height.h,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 94, 79, 176), // background color
            borderRadius: BorderRadius.circular(24),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(painter: DiamondPatternPainter()),
              ),
              // You can put other children here
            ],
          ),
        ),
        child,
      ],
    );
  }
}

class DiamondPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double squareSize = 6;
    const double spacing = 10;
    final Paint paint = Paint();

    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final double maxDistance = (size.shortestSide) / 1.2;

    for (double y = 0; y < size.height; y += spacing) {
      for (double x = 0; x < size.width; x += spacing) {
        final dx = x - centerX;
        final dy = y - centerY;
        final distance = sqrt(dx * dx + dy * dy);
        final opacity = (1 - (distance / maxDistance)).clamp(0.0, 1.0);

        if (opacity <= 0) continue;

        paint.color = Colors.white.withValues(alpha: opacity * 0.15);

        canvas.save();
        canvas.translate(x, y);
        canvas.rotate(pi / 4); // 45 degrees
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset.zero,
            width: squareSize,
            height: squareSize,
          ),
          paint,
        );
        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
