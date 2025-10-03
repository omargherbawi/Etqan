import 'dart:io';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart' hide Trans;
import 'package:lottie/lottie.dart';
import 'package:tedreeb_edu_app/config/config.dart';
import 'package:tedreeb_edu_app/core/core.dart';
import 'package:tedreeb_edu_app/core/routes/route_paths.dart';
import 'package:tedreeb_edu_app/features/categories/presentation/controllers/filter_courses_controller.dart';
import 'package:tedreeb_edu_app/features/courses/presentation/controllers/free_classes_controller.dart';
import 'package:tedreeb_edu_app/features/courses/presentation/screens/free_classes_screen.dart';
import 'package:tedreeb_edu_app/features/courses/presentation/screens/paid_classes_screen.dart';
import 'package:tedreeb_edu_app/features/home/presentation/controllers/files_controller.dart';
import 'package:tedreeb_edu_app/features/home/presentation/controllers/refresh_home_data_controller.dart';
import 'package:tedreeb_edu_app/features/home/presentation/screens/files_screen.dart';
import 'package:tedreeb_edu_app/features/home/presentation/shimmers/home_loading_shimmer.dart';
import 'package:tedreeb_edu_app/features/home/presentation/widgets/home_courses_widget_courses_build.dart';
import 'package:tedreeb_edu_app/features/home/presentation/widgets/home_top_mentor_build.dart';
import 'package:tedreeb_edu_app/features/home/presentation/widgets/top_heading_row_build.dart';
import 'package:tedreeb_edu_app/features/shared/presentation/controllers/app_controller.dart';
import 'package:tedreeb_edu_app/features/shared/presentation/controllers/current_user_controller.dart';
import 'package:tedreeb_edu_app/features/shared/presentation/controllers/shared_courses_controller.dart';
import 'package:tedreeb_edu_app/features/blogs/presentation/controllers/blogs_controller.dart';
import 'package:tedreeb_edu_app/features/blogs/presentation/screens/blog_screen.dart';

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

    // Initialize or get the last opened course controller
    if (!Get.isRegistered<LastOpenedCourseController>()) {
      Get.put(LastOpenedCourseController());
    } else {
      // Refresh the data when returning to home
      Get.find<LastOpenedCourseController>().refresh();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: SharedColors.darkRedColor,
        automaticallyImplyLeading: false,
        toolbarHeight: Responsive.isTablet ? 125.h : 90.h,
        titleSpacing: UIConstants.horizontalPaddingValue,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => CustomTextWidget(
                text:
                    currentUserController.user?.fullName != null
                        ? "${"hi".tr(context: context)}${currentUserController.user!.fullName!}"
                        : "dearStudent",
                color: Theme.of(context).colorScheme.surface,
                maxLines: 1,
                textThemeStyle: TextThemeStyleEnum.displayLarge,
              ),
            ),
            Obx(
              () => CustomTextWidget(
                text: currentUserController.user?.program ?? "",

                color: Theme.of(context).colorScheme.surface,
                maxLines: 1,
                textThemeStyle: TextThemeStyleEnum.displayLarge,
              ),
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
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              right: UIConstants.horizontalPaddingValue,
              left: UIConstants.horizontalPaddingValue,
            ),
            child: CustomIconButton(
              svg: AssetPaths.notificationSvg,
              height: Responsive.isTablet ? 25.sp : null,
              width: Responsive.isTablet ? 25.sp : null,
              onTap: () => Get.toNamed(RoutePaths.notifications),
            ),
          ),
        ],
      ),
      body: const SafeArea(top: false, child: _HomeScreenBodyBuild()),
    );
  }
}

class _HomeScreenBodyBuild extends StatefulWidget {
  const _HomeScreenBodyBuild();

  @override
  State<_HomeScreenBodyBuild> createState() => _HomeScreenBodyBuildState();
}

class _HomeScreenBodyBuildState extends State<_HomeScreenBodyBuild>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Future<LottieComposition> _compositionFuture;
  final onSurfaceColor = Get.theme.colorScheme.onSurface;
  final appController = Get.find<AppController>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    // Preload composition to assign manually
    _compositionFuture = AssetLottie(AssetPaths.shopAnimation).load();
    _compositionFuture.then((composition) {
      _controller.duration = composition.duration;
      _controller.value = 0.3; // ⬅️ Start at 50%
      _controller.forward(); // optional if you want to play from 50%
      _controller.repeat(min: 0.3);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sharedCoursesController = Get.find<SharedCoursesController>();
    final homeDataController = Get.put(HomeDataController());
    return Obx(() {
      return RefreshIndicator(
        onRefresh:
            () => Future.delayed(const Duration(milliseconds: 100), () {
              sharedCoursesController.onReady();
              homeDataController.fetchAllInstructors();
            }),
        child: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: <Widget>[
            sharedCoursesController.isLoading.value
                ? const SliverToBoxAdapter(child: HomeScreenShimmerLoading())
                : SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Image.asset(AssetPaths.sloganPng),

                          Positioned(
                            top: 0,
                            right: 0,
                            left: 0,
                            bottom: 0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CustomTextWidget(
                                  text: "منصة إتقان",
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

                      if (appController.isReviewing.value == false) ...{
                        const CustomTextWidget(
                          text: "tedreebServices",
                          color: AppLightColors.charcoalblue,
                          textThemeStyle: TextThemeStyleEnum.displayLarge,
                        ),
                        Gap(8.h),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Gap(4.w),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6.w),
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(
                                    () => const FilesScreen(),
                                    binding: BindingsBuilder(() {
                                      Get.put(FilesController());
                                    }),
                                  );
                                },
                                child: DiamondEffectContainer(
                                  width: 165,
                                  height: 160,
                                  child: Column(
                                    children: [
                                      Lottie.asset(
                                        AssetPaths.filesAnimation,
                                        height: 80.w,
                                        width: 120.w,
                                        addRepaintBoundary: true,
                                      ),
                                      Gap(5.h),
                                      CustomTextWidget(
                                        text: "files",
                                        color: Colors.white,
                                        fontSize:
                                            Responsive.isTablet ? 10 : null,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Gap(8.w),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6.w),
                              child: GestureDetector(
                                onTap: () {
                                  Future.wait([
                                    Get.find<BlogsController>().getData(),
                                    Get.find<BlogsController>().getCategories(),
                                  ]);
                                  Get.to(() => const BlogScreen(false));
                                },
                                child: DiamondEffectContainer(
                                  width: 165,
                                  height: 160,
                                  child: Column(
                                    children: [
                                      Lottie.asset(
                                        AssetPaths.blogsanimation,
                                        height: 80.w,
                                        width: 120.w,
                                        addRepaintBoundary: true,
                                      ),
                                      Gap(5.h),

                                      CustomTextWidget(
                                        text: "blog",
                                        color: Colors.white,
                                        fontSize:
                                            Responsive.isTablet ? 10 : null,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Gap(8.h),
                      },
                      if (Platform.isAndroid &&
                          sharedCoursesController
                              .paidCoursesClasses
                              .isNotEmpty) ...{
                        TopHeadingRowBuild(
                          heading: "paidClasses",
                          buttonText: "viewAll",
                          onTap: () {
                            Get.lazyPut(() => FilterCoursesController());
                            Get.lazyPut(() => UserCourseController());

                            final FreeClassesController paidCoursesController =
                                Get.put(FreeClassesController());
                            paidCoursesController.free.value = false;

                            Get.to(() => const PaidClassesScreen());
                          },
                        ),
                        HomeCoursesBuild(
                          courses: sharedCoursesController.paidCoursesClasses,
                        ),
                      },
                      Gap(8.h),

                      if (sharedCoursesController
                          .freeCoursesClasses
                          .isNotEmpty) ...{
                        TopHeadingRowBuild(
                          heading: "freeClasses",
                          buttonText: "viewAll",
                          onTap: () {
                            Get.lazyPut(() => FilterCoursesController());
                            Get.lazyPut(() => UserCourseController());

                            final FreeClassesController
                            bestSellerCoursesController = Get.put(
                              FreeClassesController(),
                            );
                            bestSellerCoursesController.free.value = true;

                            Get.to(() => const FreeClassesScreen());
                          },
                        ),
                        HomeCoursesBuild(
                          courses: sharedCoursesController.freeCoursesClasses,
                        ),
                      },

                      if (Platform.isAndroid &&
                          sharedCoursesController.packages.isNotEmpty) ...{
                        TopHeadingRowBuild(
                          heading: "pakages",
                          buttonText: "viewAll",
                          onTap: () {
                            Get.to(() => const AllPackagesScreen());
                          },
                        ),
                        HomePackagesBuild(
                          packages: sharedCoursesController.packages,
                        ),
                      },

                      // Continue Learning Section
                      Obx(() {
                        final lastCourseController =
                            Get.find<LastOpenedCourseController>();
                        return Column(
                          children: [
                            if (lastCourseController.lastOpenedCourse.value !=
                                null) ...{
                              TopHeadingRowBuild(
                                heading: "continueLearning",
                                buttonText: "",
                                onTap: () {},
                              ),
                              const CourseInLearningBuild(),
                              Gap(16.h),
                            },
                          ],
                        );
                      }),

                      TopHeadingRowBuild(
                        heading: "معلمونا",
                        buttonText: "viewAll",
                        onTap: () => Get.toNamed(RoutePaths.allMentorScreen),
                      ),
                      SizedBox(
                        height: Responsive.isTablet ? 200.h : 110.h,
                        child: const HomeTopMentorBuild(),
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

// old column children:

// TopHeadingRowBuild(
//   heading: "categories",
//   buttonText: "",
//   onTap: () {},
// ),
// const HomeCategoriesBuild(),
// if (sharedCoursesController.featuredClasses.isNotEmpty) ...{
//   TopHeadingRowBuild(
//     heading: "featuredClasses",
//     buttonText: "viewAll",
//     onTap: () {},
//   ),
//   HomeCoursesBuild(
//     courses: sharedCoursesController.featuredClasses,
//   ),
// },
// if (sharedCoursesController.newestClasses.isNotEmpty) ...{
//   TopHeadingRowBuild(
//     heading: "newestClasses",
//     buttonText: "viewAll",
//     onTap: () {
//       Get.lazyPut(() => FilterCoursesController());
//       final NewestClassesController
//       bestRatedCoursesController = Get.put(
//         NewestClassesController(),
//       );
//       bestRatedCoursesController.sort.value = 'newest';
//       Get.to(() => const NewestClassesScreen());
//     },
//   ),
//   HomeCoursesBuild(
//     courses: sharedCoursesController.newestClasses,
//   ),
// },
// if (sharedCoursesController
//     .bestRatedClasses
//     .isNotEmpty) ...{
//   TopHeadingRowBuild(
//     heading: "bestRated",
//     buttonText: "viewAll",
//     onTap: () {
//       Get.lazyPut(() => FilterCoursesController());

//       final BestRatedCourseController
//       bestRatedCoursesController = Get.put(
//         BestRatedCourseController(),
//       );
//       bestRatedCoursesController.sort.value = 'best_rates';
//       Get.toNamed(RoutePaths.bestRatedCourseScreen);
//     },
//   ),
//   HomeCoursesBuild(
//     courses: sharedCoursesController.bestRatedClasses,
//   ),
// },
// if (sharedCoursesController
//     .bestSellersClasses
//     .isNotEmpty) ...{
//   TopHeadingRowBuild(
//     heading: "bestSellers",
//     buttonText: "viewAll",
//     onTap: () {
//       Get.lazyPut(() => FilterCoursesController());

//       final BestSellerCoursesController
//       bestSellerCoursesController = Get.put(
//         BestSellerCoursesController(),
//       );
//       bestSellerCoursesController.sort.value =
//           'bestsellers';

//       Get.to(() => const BestSellerCoursesScreen());
//     },
//   ),
//   HomeCoursesBuild(
//     courses: sharedCoursesController.bestSellersClasses,
//   ),
// },
// if (sharedCoursesController
//     .freeCoursesClasses
//     .isNotEmpty) ...{
//   TopHeadingRowBuild(
//     heading: "freeClasses",
//     buttonText: "viewAll",
//     onTap: () {
//       Get.lazyPut(() => FilterCoursesController());

//       final FreeClassesController
//       bestSellerCoursesController = Get.put(
//         FreeClassesController(),
//       );
//       bestSellerCoursesController.free.value = true;

//       Get.to(() => const FreeClassesScreen());
//     },
//   ),
//   HomeCoursesBuild(
//     courses: sharedCoursesController.freeCoursesClasses,
//   ),
// },
// TopHeadingRowBuild(
//   heading: "Top Mentor",
//   buttonText: "viewAll",
//   onTap: () => Get.toNamed(RoutePaths.allMentorScreen),
// ),
// const HomeTopMentorBuild(),
// TopHeadingRowBuild(
//   heading: "Continue Learning",
//   buttonText: "viewAll",
//   onTap:
//       () => Get.toNamed(RoutePaths.continueLearningScreen),
// ),
// const CourseInLearningBuild(),
