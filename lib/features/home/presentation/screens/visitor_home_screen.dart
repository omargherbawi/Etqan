import '../../../../config/app_colors.dart';
import '../../../../config/asset_paths.dart';
import '../../../../core/core.dart';
import '../../../../core/routes/route_paths.dart';
import '../../../categories/presentation/controllers/filter_courses_controller.dart';
import '../../../courses/presentation/controllers/free_classes_controller.dart';
import '../../../courses/presentation/controllers/user_course_controller.dart';
import '../../../courses/presentation/screens/free_classes_screen.dart';
import '../widgets/home_courses_widget_courses_build.dart';
import '../widgets/top_heading_row_build.dart';
import '../../../shared/presentation/controllers/shared_courses_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class VisitorHomeScreen extends StatelessWidget {
  const VisitorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: SharedColors.darkRedColor,
        actions: const [
          Padding(
            padding: EdgeInsets.only(top: 8, right: 8, left: 18, bottom: 8),
            child: SizedBox(
              width: 100,
              height: 100,
              child: Image(image: AssetImage(AssetPaths.appLogo)),
            ),
          ),
        ],
        title: Column(
          children: [
            CustomTextWidget(
              text: 'dearStudent',
              color: Theme.of(context).colorScheme.surface,
              maxLines: 1,
              textThemeStyle: TextThemeStyleEnum.displayLarge,
            ),
            CustomTextWidget(
              text: "letsStartLearning",
              color: Theme.of(context).colorScheme.surface,
              maxLines: 1,
              fontWeight: FontWeight.w400,
              textThemeStyle: TextThemeStyleEnum.titleLarge,
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        toolbarHeight: Responsive.isTablet ? 110.h : 75.h,
        titleSpacing: UIConstants.horizontalPaddingValue,
        centerTitle: false,
      ),

      body: SafeArea(top: false, child: VisitorHomeScreenBody()),
    );
  }
}

class VisitorHomeScreenBody extends StatelessWidget {
  VisitorHomeScreenBody({super.key});

  final onSurfaceColor = Get.theme.colorScheme.onSurface;
  final sharedCoursesController = Get.put(SharedCoursesController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (sharedCoursesController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return RefreshIndicator(
        onRefresh: () async {
          sharedCoursesController.onReady();
        },
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Image.asset(AssetPaths.sloganPng),
                        Positioned.fill(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomTextWidget(
                                text: "منصة تدريب",
                                color: onSurfaceColor,
                              ),
                              CustomTextWidget(
                                text: "تعليم يتخطى الوقت والحدود",
                                color: onSurfaceColor,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    if (sharedCoursesController
                        .freeCoursesClasses
                        .isNotEmpty) ...{
                      TopHeadingRowBuild(
                        heading: "freeClasses",
                        buttonText: "viewAll",
                        onTap: () {
                          Get.lazyPut(() => FilterCoursesController());
                          Get.lazyPut(() => UserCourseController());
                          final controller = Get.put(FreeClassesController());
                          controller.free.value = true;
                          Get.to(() => const FreeClassesScreen());
                        },
                      ),
                      HomeCoursesBuild(
                        courses: sharedCoursesController.freeCoursesClasses,
                      ),
                    } else
                      Padding(
                        padding: EdgeInsets.all(20.h),
                        child: const Center(
                          child: CustomTextWidget(
                            text: "ThereAreNoFreeCoursesCurrently",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    tr('StartYourJourney'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: SharedColors.darkRedColor,
                    ),
                  ),
                  SizedBox(height: 15.h),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Get.toNamed(RoutePaths.login);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppLightColors.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                          ),
                          child: Text(
                            tr('login'),
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Get.toNamed(RoutePaths.signup);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: SharedColors.darkRedColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                          ),
                          child: Text(
                            tr("signup"),
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
