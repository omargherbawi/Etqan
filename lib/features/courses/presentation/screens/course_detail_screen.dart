import 'dart:ui';

import 'package:etqan_edu_app/features/courses/presentation/widgets/course_forum_tap.dart';

import '../../../../config/config.dart';
import '../../../../core/core.dart';
import '../../../../core/enums/course_type_enum.dart';
import '../../../../core/services/hive_services.dart';
import '../../../../core/services/url_launcher_service.dart';
import '../../../../core/utils/course_utils.dart';
import '../../../../core/widgets/badges.dart';
import '../../../../core/widgets/custom_tabbar_widget.dart';
import '../../data/models/course_model.dart';
import '../../data/models/single_course_model.dart';
import '../../../home/presentation/controllers/last_opened_course_controller.dart';
import '../controllers/course_detail_controller.dart';
import '../controllers/current_video_controller.dart';
import '../controllers/in_app_purchases_controller.dart';
import '../widgets/hls_video_player.dart';
import '../../shimmers/course_detail_shimmer.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart' hide Trans;
import 'package:no_screenshot/no_screenshot.dart';

import '../widgets/course_about_tab.dart';
import '../widgets/course_lesson_tab.dart';
import '../widgets/course_quiz_tab.dart';
import '../widgets/course_reviews_tab.dart';
import '../widgets/icon_and_value_row_build.dart';

class CourseDetailScreen extends StatefulWidget {
  const CourseDetailScreen({super.key});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  final inAppPurchaseUtils = Get.put(InAppPurchasesController());

  bool? isBundle;
  int? id;
  bool? isPrivate;

  final courseDetailsController = Get.find<CourseDetailController>();
  final currentVideoController = Get.find<CurrentVideoController>();

  // final InAppPurchaseHelper _iapHelper = InAppPurchaseHelper();
  // bool _isPurchasing = false;
  // String? _purchaseError;
  // bool _purchaseSuccess = false;
  // List<Package> availablePackages = [];

  @override
  void initState() {
    super.initState();
    final arguments = Get.arguments as Map<String, dynamic>;
    isBundle = arguments["isBundle"] as bool?;
    id = arguments["id"] as int?;
    isPrivate = arguments["isPrivate"] as bool?;
    fetchData();
    disableScreenshot();
    // if (Platform.isIOS) {
    //   _loadOffers();
    // }
    // _iapHelper.listenToPurchaseUpdates(
    //   onSuccess: () async {
    //     await courseDetailsController
    //         .purchaseCourseUsingIAP(Get.arguments["id"])
    //         .then((_) {
    //           courseDetailsController.singleCourseData.update((val) {
    //             if (val != null) val.authHasBought = true;
    //           });
    //           setState(() {
    //             _isPurchasing = false;
    //             _purchaseSuccess = true;
    //           });
    //         });
    //
    //
    //     setState(() {
    //       _isPurchasing = false;
    //     });
    //   },
    //   onError: (err) async {
    //     log("message: $err");
    //     setState(() {
    //       _isPurchasing = false;
    //       _purchaseError = err;
    //     });
    //   },
    //   onPending: () {
    //     setState(() {
    //       _isPurchasing = true;
    //     });
    //   },
    // );
  }

  void fetchData() async {
    if (id != null && isBundle != null) {
      await courseDetailsController.fetchCourseData(id!, isBundle!);

      // Save the last opened course to Hive
      final course = courseDetailsController.singleCourseData.value;
      if (course.id != null) {
        try {
          final hiveServices = Get.find<HiveServices>();
          final courseData = {
            'id': course.id,
            'title': course.title,
            'image': course.image,
            'type': isBundle == true ? "bundle" : "course",
            'isPrivate': isPrivate == true ? 1 : 0,
            'rate': course.rate,
            'students_count': course.studentsCount,
          };

          if (course.teacher != null) {
            courseData['teacher'] = course.teacher!.toJson();
          }
          if (course.rateType != null) {
            courseData['rate_type'] = course.rateType!.toJson();
          }

          hiveServices.setLastOpenedCourse(courseData);

          // Refresh the controller if it exists
          if (Get.isRegistered<LastOpenedCourseController>()) {
            Get.find<LastOpenedCourseController>().refresh();
          }
        } catch (e) {
          debugPrint('Error saving last opened course: $e');
        }
      }
    }
  }

  void disableScreenshot() async {
    final noScreenshot = NoScreenshot.instance;
    bool result = await noScreenshot.screenshotOff();

    debugPrint('Screenshot Off: $result');
  }

  @override
  void dispose() {
    // _iapHelper.dispose();
    Get.delete<CurrentVideoController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final course = courseDetailsController.singleCourseData.value;
      final isCurrentVideoNull =
          currentVideoController.currentVideoUrl.value == null;
      // _loadOffers(
      //   loadIAP:
      //       ((course.price ?? 0) > 0 && course.authHasBought == false) &&
      //       Platform.isIOS,
      // );
      return courseDetailsController.isLoading.value
          ? const CourseDetailShimmer()
          : Stack(
            children: [
              Scaffold(
                body: Obx(() {
                  return Column(
                    children: [
                      Expanded(
                        flex: 3,
                        child:
                            !isCurrentVideoNull
                                ? Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 50.0),
                                      child: HlsVideoPlayer(
                                        key: ValueKey<String?>(
                                          currentVideoController
                                              .currentVideoUrl
                                              .value,
                                        ),
                                        videoUrl:
                                            currentVideoController
                                                .currentVideoUrl
                                                .value ??
                                            "",
                                        videoIframe: '',
                                      ),
                                    ),
                                    Positioned(
                                      top: 90.h,
                                      left: 12.w,
                                      right: 12.w,
                                      child: Row(
                                        children: [
                                          CircleIconButton(
                                            icon: Icons.arrow_back,
                                            iconColor:
                                                Get
                                                    .theme
                                                    .colorScheme
                                                    .inverseSurface,
                                            onPressed: () {
                                              Get.back();
                                            },
                                            greyBackground: false,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                                : Container(
                                  width: double.infinity,
                                  color: Get.theme.cardColor,
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: CustomImage(
                                          image:
                                              course.imageCover ??
                                              course.image ??
                                              "",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        top: 45.h,
                                        left: 12.w,
                                        right: 12.w,
                                        child: Row(
                                          children: [
                                            CircleIconButton(
                                              icon: Icons.arrow_back,
                                              iconColor:
                                                  Get
                                                      .theme
                                                      .colorScheme
                                                      .inverseSurface,
                                              onPressed: () {
                                                Get.back();
                                              },
                                              greyBackground: false,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                      ),
                      Expanded(
                        flex: 7,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Get.theme.colorScheme.onSurface,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(UIConstants.radius25),
                              topLeft: Radius.circular(UIConstants.radius25),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Get.theme.colorScheme.tertiaryContainer
                                    .withAlpha(100),
                                offset: const Offset(0, -5),
                                blurRadius: 15,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              if (isCurrentVideoNull)
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: UIConstants.horizontalPaddingValue,
                                    right: UIConstants.horizontalPaddingValue,
                                    top: UIConstants.horizontalPaddingValue,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          if ((course.discountPercent ?? 0) >
                                              0) ...{
                                            Badges.off(
                                              (course.discountPercent ?? 0)
                                                  .toString(),
                                            ),
                                          } else if (CourseUtils.checkType(
                                                CourseModel(
                                                  label: course.label,
                                                ),
                                              ) ==
                                              CourseType.live) ...{
                                            Badges.liveClass(),
                                          } else if (course.label == 'Course' ||
                                              course.label == 'الدورة') ...{
                                            Badges.course(),
                                          } else if (course.label ==
                                              'Finished') ...{
                                            Badges.finished(),
                                          } else if (course.label ==
                                              'In Progress') ...{
                                            Badges.inProgress(),
                                          } else if (course.label ==
                                              'Text course') ...{
                                            Badges.textClass(),
                                          } else if (course.label ==
                                                  'Not conducted' ||
                                              course.label ==
                                                  'لم يتم إجراؤها') ...{
                                            Badges.notConducted(),
                                          },
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.star,
                                                size: 14.sp,
                                                color:
                                                    AppLightColors.orangeColor,
                                              ),
                                              Gap(5.w),
                                              CustomTextWidget(
                                                text: course.rate ?? "",
                                                textThemeStyle:
                                                    TextThemeStyleEnum
                                                        .titleSmall,
                                                color:
                                                    Get
                                                        .theme
                                                        .colorScheme
                                                        .tertiaryContainer,
                                              ),
                                              Gap(3.w),
                                              CustomTextWidget(
                                                text:
                                                    "(${course.reviewsCount?.toString() ?? ""} ${"reviews".tr(context: context)})",
                                                textThemeStyle:
                                                    TextThemeStyleEnum
                                                        .titleSmall,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Gap(12.h),
                                      CustomTextWidget(
                                        text: course.title ?? "",
                                        maxLines: 2,
                                        textThemeStyle:
                                            TextThemeStyleEnum.headlineMedium,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      Gap(12.h),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          IconAndValueRowBuild(
                                            svg: AssetPaths.personGrey,
                                            value:
                                                course.teacher?.fullName ?? "",
                                          ),
                                          IconAndValueRowBuild(
                                            svg: AssetPaths.playButton,
                                            value:
                                                "${courseDetailsController.lessonsCount.value}${"lessons".tr(context: context)}",
                                          ),
                                          // if (course.certificates.isNotEmpty)
                                          //   const IconAndValueRowBuild(
                                          //     svg: AssetPaths.certificate,
                                          //     value: "certificate",
                                          //   ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              const Expanded(child: CourseDetailTabs()),
                              Gap(10.h),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
              if (((course.price ?? 0) > 0 && course.authHasBought == false))
                Obx(() {
                  return _PaidCourseOverlay(
                    isPurchasing: inAppPurchaseUtils.isPurchasing.value,
                    purchaseSuccess: inAppPurchaseUtils.isPurchased.value,
                    purchaseError: inAppPurchaseUtils.purchaseError.value,
                    course: course,
                    onBuyPressed: () async {
                      inAppPurchaseUtils.isPurchasing.value = true;
                      inAppPurchaseUtils.update();

                      try {
                        // inAppPurchaseUtils.buyNonConsumableProduct('course_1');
                        await inAppPurchaseUtils.buyNonConsumableProduct(
                          'com.etqan.app.Lifetime',
                        );
                        // await _iapHelper.buyCourse();
                      } catch (e) {
                        inAppPurchaseUtils.isPurchasing.value = false;
                        inAppPurchaseUtils.purchaseError.value = e.toString();
                      }
                    },
                  );
                }),
            ],
          );
    });
  }
}

class CourseDetailTabs extends StatefulWidget {
  const CourseDetailTabs({super.key});

  @override
  State<CourseDetailTabs> createState() => _CourseDetailTabsState();
}

class _CourseDetailTabsState extends State<CourseDetailTabs>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final courseDetailsController = Get.find<CourseDetailController>();

  @override
  void initState() {
    super.initState();
    _initializeTabController();
  }

  void _initializeTabController() {
    final course = courseDetailsController.singleCourseData.value;
    final showForum = course.forum == true;
    final tabCount = showForum ? 5 : 4;

    _tabController = TabController(length: tabCount, vsync: this);
  }

  @override
  void didUpdateWidget(CourseDetailTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reinitialize tab controller if forum status changes
    _initializeTabController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final course = courseDetailsController.singleCourseData.value;
      final showForum = course.forum == true;

      // Reinitialize tab controller if needed
      if ((showForum && _tabController.length == 4) ||
          (!showForum && _tabController.length == 5)) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _initializeTabController();
        });
      }

      final tabs = <String>[
        'about'.tr(context: context),
        'lessons'.tr(context: context),
        if (showForum) 'forum'.tr(context: context),
        'quiz'.tr(context: context),
        'reviews'.tr(context: context),
      ];

      final tabViews = <Widget>[
        const CourseAboutTab(),
        const CourseLessonsTab(),
        if (showForum) const CourseForumTap(),
        CourseQuizTab(course: course),
        const CourseReviewsTab(),
      ];

      return Column(
        children: [
          CustomTabbarWidget(controller: _tabController, tabs: tabs),
          Gap(12.h),
          Expanded(
            child: TabBarView(
              physics: const BouncingScrollPhysics(),
              controller: _tabController,
              children: tabViews,
            ),
          ),
        ],
      );
    });
  }
}

class _PaidCourseOverlay extends StatelessWidget {
  final bool isPurchasing;
  final String purchaseError;
  final bool purchaseSuccess;
  final VoidCallback onBuyPressed;
  final SingleCourseModel course;

  const _PaidCourseOverlay({
    required this.isPurchasing,
    required this.purchaseError,
    required this.purchaseSuccess,
    required this.onBuyPressed,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
            child: Container(color: Colors.black.withValues(alpha: 0.5)),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 10),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (purchaseSuccess) ...[
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'تم الشراء بنجاح!',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ] else ...[
                    CustomTextWidget(
                      text: 'هذه الدورة مدفوعة يرجى زيارة موقعنا',
                      fontSize: 20,
                      color: AppLightColors.primaryColor,
                    ),
                    const SizedBox(height: 16),
                    if (course.priceString != null) ...[
                      Text(
                        'السعر: ${course.priceString ?? 'غير محدد'}',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black87,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                    if (purchaseError != '') ...[
                      const SizedBox(height: 16),
                      Text(
                        purchaseError,
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed:
                                isPurchasing
                                    ? null
                                    : () async {
                                      if (course.link != null &&
                                          course.link!.isNotEmpty) {
                                        await LaunchUrlService.openWeb(
                                          context,
                                          course.link!,
                                        );
                                      } else {
                                        ToastUtils.showError(
                                          "يتعذر فتح الرابط في الوقت الحالي الرجاء زيارة الموقع",
                                        );
                                      }
                                    },
                            child:
                                isPurchasing
                                    ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                    : const Text(
                                      'شراء الدورة',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: const BorderSide(color: Colors.red),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed:
                                isPurchasing
                                    ? null
                                    : () {
                                      Navigator.of(context).pop();
                                    },
                            child: const Text(
                              'إلغاء',
                              style: TextStyle(fontSize: 18, color: Colors.red),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
