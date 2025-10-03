import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart' hide Trans;
import 'package:google_fonts/google_fonts.dart';
import '../../config/config.dart';
import '../core.dart';
import '../enums/course_type_enum.dart';
import '../routes/route_paths.dart';
import 'console_log_functions.dart';
import 'course_utils.dart';
import 'date_utils.dart';
import '../widgets/badges.dart';
import '../../features/account/presentation/widgets/settings_row_widget.dart';
import '../../features/auth/data/models/user_model.dart';
import '../../features/blogs/data/models/blog_model.dart';
import '../../features/courses/data/models/course_model.dart';

class UIConstants {
  // Sir kindly uses this for desktop
  static EdgeInsets desktopBody = EdgeInsets.only(
    left: 19.w,
    right: 19.w,
    bottom: 40.h,
    top: 20.h,
  );

  // This for mobile
  static double horizontalPaddingValue = 18.w;
  static EdgeInsets mobileBodyPadding = EdgeInsets.only(
    left: horizontalPaddingValue,
    right: horizontalPaddingValue,
    bottom: 40.h,
    top: 20.h,
  );
  static EdgeInsets mobileBodyPaddingWithoutBottom = EdgeInsets.only(
    left: horizontalPaddingValue,
    right: horizontalPaddingValue,
    top: 20.h,
  );

  static EdgeInsets horizontalPadding = EdgeInsets.symmetric(
    horizontal: horizontalPaddingValue,
  );

  static double radius8 = 8.r;
  static double radius10 = 10.r;
  static double radius12 = 12.r;
  static double radius25 = 25.r;
  static double radius50 = 50.r;
  static BorderRadiusGeometry? circularRadius10 = BorderRadius.circular(
    radius10,
  );
  static const Duration milliseconds500 = Duration(milliseconds: 500);
}

class ShimmerConstants {
  static const Color baseColor = Color(0xFFE0E0E0); // Light grey
  static const Color highlightColor = Color(0xFFF5F5F5); // Lighter grey
}

BoxShadow boxShadow(Color color, {int blur = 20, int y = 8, int x = 0}) {
  return BoxShadow(
    color: color,
    blurRadius: blur.toDouble(),
    offset: Offset(x.toDouble(), y.toDouble()),
  );
}

Widget tabBar(
  Function(int) onChangeTab,
  TabController tabController,
  List<Widget> tab,
) {
  return Align(
    alignment: AlignmentDirectional.centerStart,
    child: TabBar(
      onTap: onChangeTab,
      isScrollable: true,
      controller: tabController,
      physics: const BouncingScrollPhysics(),
      indicator: RoundedTabIndicator(),
      labelColor: const Color(0xff1D2D3A),
      unselectedLabelColor: Colors.grey,
      dividerColor: Colors.transparent,
      labelPadding: UIConstants.horizontalPadding,
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      tabs: tab,
    ),
  );
}

class RoundedTabIndicator extends Decoration {
  RoundedTabIndicator({
    Color color = Colors.black,
    double radius = 100.0,
    double width = 22.0,
    double height = 4.0,
    double bottomMargin = 0.0,
  }) : _painter = _RoundedRectanglePainter(
         color,
         width,
         height,
         radius,
         bottomMargin,
       );

  final BoxPainter _painter;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _painter;
  }
}

class _RoundedRectanglePainter extends BoxPainter {
  _RoundedRectanglePainter(
    Color color,
    this.width,
    this.height,
    this.radius,
    this.bottomMargin,
  ) : _paint =
          Paint()
            ..color = color
            ..isAntiAlias = true;

  final Paint _paint;
  final double radius;
  final double width;
  final double height;
  final double bottomMargin;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final centerX = (cfg.size?.width ?? 0) / 2 + offset.dx;
    final bottom = (cfg.size?.height) ?? 0 - bottomMargin;
    final halfWidth = width / 2;

    canvas.drawRRect(
      RRect.fromLTRBR(
        centerX - halfWidth,
        bottom - height,
        centerX + halfWidth,
        bottom,
        Radius.circular(radius),
      ),
      _paint,
    );
  }
}

Widget emptyState(
  String icon,
  String title,
  String desc, {
  bool isBottomPadding = true,
}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SvgPicture.asset(icon),
      const Gap(20),
      CustomTextWidget(text: title),
      const Gap(4),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: CustomTextWidget(text: desc, textAlign: TextAlign.center),
      ),
      Gap(isBottomPadding ? Get.height * .1 : 0),
    ],
  );
}

Widget getBadge(CourseModel course) {
  switch (course.label) {
    case 'Course':
    case 'الدورة':
      return Badges.course();
    case 'Finished':
      return Badges.finished();
    case 'In Progress':
      return Badges.inProgress();
    case 'Text course':
      return Badges.textClass();
    case 'Not conducted':
    case 'لم يتم إجراؤها':
      return Badges.notConducted();
    default:
      if ((course.discountPercent ?? 0) > 0) {
        return Badges.off((course.discountPercent ?? 0).toString());
      } else if (CourseUtils.checkType(course) == CourseType.live) {
        return Badges.liveClass();
      }
      return const SizedBox.shrink();
  }
}

class SwitchButton extends StatelessWidget {
  final String? iconPath;
  final IconData? icon;
  final String text;
  final Color? iconColor;
  final Function()? onTap;
  final EdgeInsetsGeometry? padding;

  final bool state;
  final Function(bool value) onChangeState;
  final bool loading;

  const SwitchButton({
    super.key,
    this.iconPath,
    this.icon,
    required this.text,
    this.iconColor,
    this.padding,
    this.onTap,
    required this.state,
    required this.onChangeState,
    this.loading = false,
  }) : assert(iconPath != null || icon != null);

  @override
  Widget build(BuildContext context) {
    return SettingsRowWidget(
      padding: padding ?? EdgeInsets.symmetric(vertical: 5.h),
      onTap: onTap,
      leadingWidget:
          iconPath != null
              ? SvgPicture.asset(
                iconPath!,
                width: 24.w,
                height: 24.h,
                color: Get.theme.colorScheme.primary,
              )
              : Icon(
                icon,
                size: 20.sp,
                color: iconColor ?? Get.theme.colorScheme.primary,
              ),
      text: text,
      trailingWidget:
          loading
              ? const LoadingAnimation()
              : GestureDetector(
                onTap:
                    loading
                        ? null
                        : () {
                          onChangeState(!state);
                        },
                onHorizontalDragUpdate: (details) {
                  if (details.delta.dx < 0) {
                    onChangeState(true);
                  } else {
                    onChangeState(false);
                  }
                },
                behavior: HitTestBehavior.opaque,
                child: Container(
                  // for touch
                  alignment: Alignment.center,
                  height: 25,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 32,
                    height: 6,
                    clipBehavior: Clip.none,
                    decoration: BoxDecoration(
                      color: state ? Get.theme.colorScheme.primary : Colors.red,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        AnimatedPositionedDirectional(
                          top: -4,
                          end: state ? -2 : 18,
                          bottom: -4,
                          duration: const Duration(milliseconds: 150),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                              color:
                                  state
                                      ? Get.theme.colorScheme.primary
                                      : Colors.red,
                              boxShadow: [
                                boxShadow(
                                  Colors.black.withValues(alpha: .4),
                                  blur: 10,
                                  y: 3,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}

Widget switchButton(
  String title,
  bool state,
  Function(bool value) onChangeState, {
  bool loading = false,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      CustomTextWidget(text: title),
      loading
          ? const LoadingAnimation()
          : GestureDetector(
            onTap:
                loading
                    ? null
                    : () {
                      onChangeState(!state);
                    },
            onHorizontalDragUpdate: (details) {
              if (details.delta.dx < 0) {
                onChangeState(true);
              } else {
                onChangeState(false);
              }
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              // for touch
              alignment: Alignment.center,
              height: 25,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 32,
                height: 6,
                clipBehavior: Clip.none,
                decoration: BoxDecoration(
                  color: state ? Get.theme.colorScheme.primary : Colors.red,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    AnimatedPositionedDirectional(
                      top: -4,
                      end: state ? -2 : 18,
                      bottom: -4,
                      duration: const Duration(milliseconds: 150),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                          color:
                              state
                                  ? Get.theme.colorScheme.primary
                                  : Colors.red,
                          boxShadow: [
                            boxShadow(
                              Colors.black.withValues(alpha: .4),
                              blur: 10,
                              y: 3,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    ],
  );
}

Widget radioButton(
  String title,
  bool state,
  Function(bool value) onChangeState,
) {
  return GestureDetector(
    onTap: () {
      onChangeState(!state);
    },
    behavior: HitTestBehavior.opaque,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 6),
            color:
                state
                    ? Get.theme.colorScheme.primary
                    : Get.theme.colorScheme.primaryContainer,
            boxShadow: [
              boxShadow(
                Get.theme.colorScheme.primaryContainer.withValues(alpha: .38),
                blur: 10,
                y: 3,
              ),
            ],
          ),
        ),
        Gap(8.w),
        CustomTextWidget(text: title),
      ],
    ),
  );
}

baseBottomSheet({required Widget child}) async {
  return await showModalBottomSheet(
    isScrollControlled: true,
    context: Get.context!,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: GestureDetector(
          onTap: () {
            Get.close(1);
          },
          behavior: HitTestBehavior.opaque,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: UIConstants.horizontalPadding,
                child: closeButton(AssetPaths.arrowClearSvg),
              ),
              Gap(16.h),
              GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Container(
                  width: Get.width,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                    color: Colors.white,
                  ),
                  child: child,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget closeButton(
  String icon, {
  Function? onTap,
  double? width,
  Color? icColor,
}) {
  return MouseRegion(
    cursor: SystemMouseCursors.click,
    child: GestureDetector(
      onTap: () {
        onTap ?? Get.close(1);
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
        ),
        alignment: Alignment.center,
        child: SvgPicture.asset(
          icon,
          colorFilter: ColorFilter.mode(
            icColor ?? Get.theme.colorScheme.primary,
            BlendMode.srcIn,
          ),
          width: width,
        ),
      ),
    ),
  );
}

Widget checkButton(
  String title,
  bool state,
  Function(bool value) onChangeState,
) {
  return GestureDetector(
    onTap: () {
      onChangeState(!state);
    },
    behavior: HitTestBehavior.opaque,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomTextWidget(text: title),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color:
                  state
                      ? Get.theme.colorScheme.primary
                      : Get.theme.colorScheme.primaryContainer,
            ),
            color: state ? Get.theme.colorScheme.primary : Colors.white,
          ),
          alignment: Alignment.center,
          child: SvgPicture.asset(AssetPaths.checkSvg),
        ),
      ],
    ),
  );
}

Widget courseItem(
  CourseModel courseData, {
  bool isSmallSize = true,
  double width = 180.0,
  height = 227.0,
  double endCardPadding = 16.0,
  bool isShowReward = false,
}) {
  if (!isSmallSize) {
    width = 220;
    height = 240;
  }

  return Container(
    margin: EdgeInsetsDirectional.only(end: endCardPadding),
    width: width,
    height: height,
    child: MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          Get.toNamed(
            RoutePaths.courseDetailScreen,
            arguments: {
              "isBundle": courseData.type == "bundle",
              "id": courseData.id,
              "isPrivate": courseData.isPrivate == 1 ? true : false,
            },
          );
        },
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // image
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Stack(
                children: [
                  CustomImage(
                    image: courseData.image ?? '',
                    width: width,
                    height: isSmallSize ? 100 : 140,
                  ),

                  // rate and notification and progress
                  Container(
                    width: width,
                    height: isSmallSize ? 100 : 140,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withValues(alpha: .4),
                          Colors.black.withValues(alpha: 0),
                          Colors.black.withValues(alpha: 0),
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    child: Column(
                      children: [
                        // rate
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // rate
                            Container(
                              margin: const EdgeInsetsDirectional.only(
                                start: 8,
                                end: 8,
                                bottom: 2,
                                top: 8,
                              ),
                              // margin: padding(horizontal: 8,vertical: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 6,
                              ),

                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: .05),
                                    offset: const Offset(0, 3),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),

                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(
                                    AssetPaths.starYellowSvg,
                                    width: 13,
                                  ),
                                  const Gap(2),
                                  CustomTextWidget(text: courseData.rate ?? ''),
                                ],
                              ),
                            ),

                            if (CourseUtils.checkType(courseData) ==
                                CourseType.live) ...{
                              GestureDetector(
                                onTap: () async {
                                  try {
                                    // DateTime start = DateTime(
                                    //   DateTime.fromMillisecondsSinceEpoch(
                                    //           (courseData.startDate ?? 0) *
                                    //               1000,
                                    //           isUtc: true)
                                    //       .year,
                                    //   DateTime.fromMillisecondsSinceEpoch(
                                    //           (courseData.startDate ?? 0) *
                                    //               1000,
                                    //           isUtc: true)
                                    //       .month,
                                    //   DateTime.fromMillisecondsSinceEpoch(
                                    //           (courseData.startDate ?? 0) *
                                    //               1000,
                                    //           isUtc: true)
                                    //       .day,
                                    //   DateTime.fromMillisecondsSinceEpoch(
                                    //           (courseData.startDate ?? 0) *
                                    //               1000,
                                    //           isUtc: true)
                                    //       .hour,
                                    //   DateTime.fromMillisecondsSinceEpoch(
                                    //           (courseData.startDate ?? 0) *
                                    //               1000,
                                    //           isUtc: true)
                                    //       .minute,
                                    // );
                                    // DateTime end = DateTime(
                                    //   DateTime.fromMillisecondsSinceEpoch(
                                    //           (courseData.startDate ?? 0) *
                                    //               1000,
                                    //           isUtc: true)
                                    //       .year,
                                    //   DateTime.fromMillisecondsSinceEpoch(
                                    //           (courseData.startDate ?? 0) *
                                    //               1000,
                                    //           isUtc: true)
                                    //       .month,
                                    //   DateTime.fromMillisecondsSinceEpoch(
                                    //           (courseData.startDate ?? 0) *
                                    //               1000,
                                    //           isUtc: true)
                                    //       .day,
                                    //   DateTime.fromMillisecondsSinceEpoch(
                                    //           (courseData.startDate ?? 0) *
                                    //               1000,
                                    //           isUtc: true)
                                    //       .hour,
                                    //   (DateTime.fromMillisecondsSinceEpoch(
                                    //               (courseData.startDate ??
                                    //                       0) *
                                    //                   1000,
                                    //               isUtc: true)
                                    //           .minute +
                                    //       (courseData.duration ?? 0)),
                                    // );

                                    // final Event event = Event(
                                    //   title: courseData.title ?? '',
                                    //   description: appText.webinar,
                                    //   startDate: start,
                                    //   endDate: end,
                                    //   iosParams: const IOSParams(),
                                    //   androidParams: const AndroidParams(),
                                    // );

                                    // Add2Calendar.addEvent2Cal(event);
                                  } catch (e) {}
                                },
                                behavior: HitTestBehavior.opaque,
                                child: Container(
                                  margin: const EdgeInsetsDirectional.only(
                                    start: 8,
                                    end: 8,
                                    bottom: 2,
                                    top: 8,
                                  ),
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: .05,
                                        ),
                                        offset: const Offset(0, 3),
                                        blurRadius: 20,
                                      ),
                                    ],
                                  ),
                                  alignment: Alignment.center,
                                  child: SvgPicture.asset(
                                    AssetPaths.notificationSvg,
                                    colorFilter: ColorFilter.mode(
                                      Get.theme.colorScheme.primary,
                                      BlendMode.srcIn,
                                    ),
                                    width: 12,
                                  ),
                                ),
                              ),
                            },
                          ],
                        ),

                        const Spacer(),

                        // if (courseData.badges?.isNotEmpty ?? false) ...{
                        //   Align(
                        //     alignment: AlignmentDirectional.centerStart,
                        //     child: Container(
                        //       margin: const EdgeInsets.symmetric(horizontal: 8),
                        //       padding: const EdgeInsets.symmetric(
                        //         horizontal: 6,
                        //         vertical: 4,
                        //       ),
                        //       decoration: BoxDecoration(
                        //         color: ColorUtils().getColorFromRGBString(
                        //           courseData.badges!.first.badge?.background ??
                        //               '',
                        //         ),
                        //         borderRadius: BorderRadius.circular(10),
                        //       ),
                        //       child: Row(
                        //         mainAxisSize: MainAxisSize.min,
                        //         children: [
                        //           if (courseData.badges!.first.badge?.icon !=
                        //               null) ...{
                        //             SvgPicture.network(
                        //               'https://qout.net${courseData.badges!.first.badge?.icon ?? ''}',
                        //               width: 16,
                        //             ),
                        //             const Gap(2),
                        //           } else ...{
                        //             const Gap(2),
                        //           },
                        //           CustomTextWidget(
                        //             text:
                        //                 courseData.badges!.first.badge?.title ??
                        //                 '',
                        //             color:
                        //                 courseData.badges!.first.badge != null
                        //                     ? Color(
                        //                       int.parse(
                        //                             courseData
                        //                                 .badges!
                        //                                 .first
                        //                                 .badge!
                        //                                 .color!
                        //                                 .substring(1, 7),
                        //                             radix: 16,
                        //                           ) +
                        //                           0xFF000000,
                        //                     )
                        //                     : null,
                        //           ),
                        //           const Gap(2),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        //   const Gap(7),
                        // } else ...{
                        //   if (CourseUtils.checkType(courseData) ==
                        //       CourseType.live) ...{
                        //     // progress
                        //     Padding(
                        //       padding: const EdgeInsets.symmetric(
                        //         horizontal: 8,
                        //         vertical: 8,
                        //       ),
                        //       child: LayoutBuilder(
                        //         builder: (context, constraints) {
                        //           return Container(
                        //             width: constraints.maxWidth,
                        //             height: 4.5,
                        //             padding: const EdgeInsets.symmetric(
                        //               horizontal: 1.5,
                        //             ),
                        //             decoration: BoxDecoration(
                        //               color: Colors.white,
                        //               borderRadius: BorderRadius.circular(10),
                        //             ),
                        //             alignment: AlignmentDirectional.centerStart,
                        //             child: Container(
                        //               width:
                        //                   constraints.maxWidth *
                        //                   ((courseData.studentsCount ?? 0) /
                        //                       (courseData.capacity ?? 0)),
                        //               height: 2,
                        //               decoration: BoxDecoration(
                        //                 color: SharedColors.yellowColor,
                        //                 borderRadius: BorderRadius.circular(10),
                        //               ),
                        //             ),
                        //           );
                        //         },
                        //       ),
                        //     ),
                        //   },
                        // },
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(10),

                    // title
                    CustomTextWidget(
                      text: courseData.title ?? '',
                      maxLines: 1,
                      textThemeStyle: TextThemeStyleEnum.bodyMedium,
                    ),

                    // name and date and time
                    // SizedBox(
                    //   width: width,
                    //   child: Row(
                    //     children: [
                    //       if (CourseUtils.checkType(courseData) ==
                    //           CourseType.live) ...{
                    //         Row(
                    //           mainAxisSize: MainAxisSize.min,
                    //           children: [
                    //             SvgPicture.asset(AssetPaths.calenderSvg),
                    //             const Gap(4),
                    //             CustomTextWidget(
                    //               textThemeStyle: TextThemeStyleEnum.bodyMedium,
                    //               text:
                    //                   DateTime.fromMillisecondsSinceEpoch(
                    //                     courseData.startDate! * 1000,
                    //                     isUtc: true,
                    //                   ).toDate(),
                    //             ),
                    //           ],
                    //         ),
                    //       } else if (CourseUtils.checkType(courseData) ==
                    //           CourseType.video) ...{
                    //         Row(
                    //           mainAxisSize: MainAxisSize.min,
                    //           children: [
                    //             if (isShowReward) ...{
                    //               CustomTextWidget(
                    //                 text: courseData.points?.toString() ?? '-',
                    //                 color: SharedColors.yellowColor,
                    //               ),
                    //             } else ...{
                    //               CustomTextWidget(
                    //                 textThemeStyle:
                    //                     TextThemeStyleEnum.bodySmall,
                    //                 text:
                    //                     (courseData.price == 0)
                    //                         ? "free"
                    //                         : courseData.priceString ?? "",
                    //                 color:
                    //                     (courseData.discountPercent ?? 0) > 0
                    //                         ? Get.theme.colorScheme.primary
                    //                             .withValues(alpha: 0.4)
                    //                         : Get.theme.colorScheme.primary,
                    //                 decoration:
                    //                     (courseData.discountPercent ?? 0) > 0
                    //                         ? TextDecoration.lineThrough
                    //                         : TextDecoration.none,
                    //                 decorationColor:
                    //                     (courseData.discountPercent ?? 0) > 0
                    //                         ? Get.theme.colorScheme.primary
                    //                             .withValues(alpha: 0.4)
                    //                         : Get.theme.colorScheme.primary,
                    //               ),
                    //             },
                    //             if ((courseData.discountPercent ?? 0) > 0) ...{
                    //               const Gap(8),
                    //               CustomTextWidget(
                    //                 text: courseData.priceString ?? "",
                    //                 color: Get.theme.colorScheme.primary,
                    //                 textThemeStyle:
                    //                     TextThemeStyleEnum.bodyMedium,
                    //               ),
                    //             },
                    //             CustomTextWidget(
                    //               textThemeStyle: TextThemeStyleEnum.bodySmall,
                    //               text:
                    //                   '${durationToString(courseData.duration ?? 0)} ${"hours".tr()}',
                    //               overflow: TextOverflow.ellipsis,
                    //               maxLines: 1,
                    //             ),
                    //           ],
                    //         ),
                    //       },
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget descriptionInput(
  TextEditingController controller,
  FocusNode node,
  String hint, {
  String? iconPathLeft,
  bool isNumber = false,
  bool isCenter = false,
  int letterSpacing = 1,
  bool isReadOnly = false,
  Function? onTap,
  int height = 52,
  bool isPassword = false,
  Function? onTapLeftIcon,
  Function? obscureText,
  int leftIconSize = 14,
  String? Function(String?)? validator,
  bool isError = false,
  Function(String)? onChange,
  int fontSize = 16,
  Color leftIconColor = const Color(0xff6E6E6E),
  double radius = 20,
  int? maxLength,
  bool isBorder = false,
  Color fillColor = Colors.white,
  int maxLine = 8,
}) {
  return Theme(
    data: Theme.of(
      Get.context!,
    ).copyWith(colorScheme: const ColorScheme.light(error: Colors.red)),
    child: TextFormField(
      controller: controller,
      focusNode: node,
      cursorColor: Get.theme.colorScheme.primary,
      maxLines: maxLine,
      readOnly: isReadOnly,
      onTap: () {
        if (onTap != null) {
          onTap();
        }
      },
      onChanged: (text) {
        if (onChange != null) {
          onChange(text);
        }
      },
      validator: validator,
      obscureText: isPassword,
      style: style14Regular().copyWith(
        letterSpacing: letterSpacing.toDouble(),
        fontSize: fontSize.toDouble(),
        height: 1,
        color: greyB2,
      ),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      textAlign:
          isCenter
              ? TextAlign.center
              : isNumber
              ? TextAlign.end
              : TextAlign.start,
      inputFormatters: [LengthLimitingTextInputFormatter(maxLength)],
      decoration: InputDecoration(
        hintText: hint.tr(),
        hintStyle: style14Regular().copyWith(
          letterSpacing: 0,
          fontSize: 14,
          color: greyA5,
          height: 1.3,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        fillColor: fillColor,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(
            color: isBorder ? greyE7 : Colors.transparent,
            width: 1,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(color: Colors.red, width: 0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(color: Colors.red, width: 0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(
            color: isBorder ? greyE7 : Colors.transparent,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(
            color: isBorder ? greyE7 : Colors.transparent,
            width: 1,
          ),
        ),
      ),
    ),
  );
}

TextStyle style14Regular() => style16Regular().copyWith(fontSize: 14);
Color greyB2 = const Color(0xffA9AEB2);
Color grey33 = const Color(0xff2F3133);
Color greyA5 = const Color(0xffA5A5A5);
Color greyE7 = const Color(0xffE7E7E7);

TextStyle style16Regular() {
  return GoogleFonts.cairo(color: grey33, fontSize: 16);
}

Widget shimmerUi({
  required double height,
  required double width,
  double radius = 15,
}) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: grey33,
      borderRadius: BorderRadius.circular(radius),
    ),
  );
}

Widget blogItem(BlogModel blog, Function onTap) {
  logInfo("1 hero blogs_${blog.id!}");
  return GestureDetector(
    onTap: () {
      onTap();
    },
    behavior: HitTestBehavior.opaque,
    child: Container(
      width: Get.width,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // image
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: Stack(
              children: [
                CustomImage(
                  image: blog.image ?? '',
                  width: Get.width,
                  height: 200.h,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 12.h,
                  ),
                  width: Get.width,
                  height: 200.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withValues(alpha: .7),
                        Colors.black.withValues(alpha: .1),
                        Colors.black.withValues(alpha: 0),
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100.r),
                        child: CustomImage(
                          image: blog.author?.avatar ?? '',
                          width: 32.w,
                          height: 32.w,
                        ),
                      ),
                      const Gap(8),
                      Text(
                        blog.author?.fullName ?? '',
                        style: style14Regular().copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Gap(16),

          CustomTextWidget(text: blog.title ?? ''),

          const Gap(5),

          HtmlWidget(
            blog.description ?? '',
            textStyle: GoogleFonts.cairo().copyWith(color: greyA5, height: 1.6),
          ),

          const Gap(10),

          Row(
            children: [
              Row(
                children: [
                  SvgPicture.asset(AssetPaths.calendarSvg),
                  const Gap(5),
                  Text(
                    timeStampToDate((blog.createdAt ?? 0) * 1000).toString(),
                  ),
                ],
              ),
              const Gap(20),
              Row(
                children: [
                  SvgPicture.asset(AssetPaths.commentsSvg),
                  const Gap(5),
                  CustomTextWidget(
                    text: '${blog.commentCount} ${"comments".tr()}',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget userProfile(
  UserModel user, {
  bool showRate = false,
  String? customRate,
  String? customSubtitle,
  bool isBoldTitle = false,
  bool isBackground = false,
  bool isBoxLimited = false,
}) {
  return Container(
    padding:
        isBackground
            ? EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h)
            : null,
    decoration:
        isBackground
            ? BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
            )
            : null,
    width: isBoxLimited ? 240 : null,
    child: Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(100.r),
          child: CustomImage(
            image: user.avatar ?? '',
            width: 40.w,
            height: 40.w,
          ),
        ),
        const Gap(6),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                constraints:
                    isBoxLimited
                        ? const BoxConstraints(maxWidth: 150)
                        : const BoxConstraints(),
                child: CustomTextWidget(
                  text: user.fullName ?? '',
                  fontWeight: !isBoldTitle ? FontWeight.w600 : FontWeight.bold,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (showRate) ...{
                const Gap(3),
                ratingBar(customRate ?? user.rate.toString()),
              } else if (customSubtitle != null) ...{
                const Gap(6),
                CustomTextWidget(text: customSubtitle),
              } else ...{
                Text(
                  user.roleName ?? '',
                  style: style14Regular().copyWith(color: greyA5),
                ),
              },
            ],
          ),
        ),
      ],
    ),
  );
}

RatingBar ratingBar(
  String rate, {
  int itemSize = 12,
  Function(double)? onRatingUpdate,
}) {
  return RatingBar(
    ignoreGestures: onRatingUpdate == null,
    itemPadding: const EdgeInsets.symmetric(horizontal: 0),
    itemSize: itemSize.toDouble(),
    initialRating: double.parse(rate).round().toDouble(),
    ratingWidget: RatingWidget(
      full: SvgPicture.asset(AssetPaths.starYellowSvg),
      half: SvgPicture.asset(AssetPaths.starYellowSvg),
      empty: SvgPicture.asset(AssetPaths.starGreySvg),
    ),
    onRatingUpdate: (value) {
      if (onRatingUpdate != null) {
        onRatingUpdate(value);
      }
    },
    glow: false,
  );
}

Widget commentUi(Comments comment, Function onTapOption) {
  return Container(
    key: comment.globalKey,
    width: Get.width,
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
    margin: const EdgeInsets.only(bottom: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20.r),
      // border: Border.all()
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // user info
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: userProfile(comment.user!)),
            GestureDetector(
              onTap: () {
                onTapOption();
              },
              behavior: HitTestBehavior.opaque,
              child: SizedBox(
                width: 45,
                height: 45,
                child: Icon(Icons.more_horiz, size: 30, color: greyA5),
              ),
            ),
          ],
        ),

        const Gap(16),

        Text(
          comment.comment ?? '',
          style: style14Regular().copyWith(color: greyA5, height: 1.5),
        ),

        const Gap(16),

        Text(
          timeStampToDate((comment.createAt ?? 0) * 1000),
          style: style14Regular().copyWith(color: greyA5, height: 1.5),
        ),

        // Replies
        if (comment.replies?.isNotEmpty ?? false) ...{
          const Gap(16),
          ...List.generate(comment.replies?.length ?? 0, (i) {
            return Container(
              width: Get.width,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: greyE7),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // user info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: userProfile(comment.replies![i].user!)),
                      GestureDetector(
                        onTap: () {
                          onTapOption();
                        },
                        behavior: HitTestBehavior.opaque,
                        child: SizedBox(
                          width: 45,
                          height: 45,
                          child: Icon(
                            Icons.more_horiz,
                            size: 30,
                            color: greyA5,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Gap(16),

                  CustomTextWidget(text: comment.replies![i].comment ?? ''),

                  const Gap(14),

                  CustomTextWidget(
                    text: timeStampToDate(
                      (comment.replies![i].createAt ?? 0) * 1000,
                    ),
                  ),
                ],
              ),
            );
          }),
        },
      ],
    ),
  );
}

Widget userProfileCard(UserModel user, Function onTap) {
  return GestureDetector(
    onTap: () {
      onTap();
    },
    child: Container(
      width: 155.w,
      height: 195.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          // meet status
          // Align(
          //   alignment: AlignmentDirectional.centerEnd,
          //   child: Container(
          //     width: 22,
          //     height: 22,
          //     decoration: BoxDecoration(
          //         shape: BoxShape.circle,
          //         color: user.meetingStatus == 'no'
          //             ? Colors.red.withValues(alpha: .3)
          //             : user.meetingStatus == 'available'
          //                 ? Get.theme.colorScheme.primary.withValues(alpha: .3)
          //                 : Colors.grey.withValues(alpha: .3)),
          //     alignment: Alignment.center,
          //     child: SvgPicture.asset(
          //       AssetPaths.calendarSvg,
          //       width: 11,
          //       colorFilter: ColorFilter.mode(
          //         user.meetingStatus == 'no'
          //             ? Colors.red
          //             : user.meetingStatus == 'available'
          //                 ? Get.theme.colorScheme.primary
          //                 : Colors.grey,
          //         BlendMode.srcIn,
          //       ),
          //     ),
          //   ),
          // ),
          Expanded(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100.r),
                  child: CustomImage(
                    image: user.avatar ?? '',
                    width: 70.w,
                    height: 70.w,
                  ),
                ),
                const Spacer(flex: 1),
                CustomTextWidget(
                  text: user.fullName ?? '',
                  textThemeStyle: TextThemeStyleEnum.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const Gap(8),
                ratingBar(user.rate ?? '0'),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget helperBox(
  String icon,
  String title,
  String subTitle, {
  int iconSize = 20,
  int horizontalPadding = 21,
}) {
  return Container(
    width: Get.width,
    padding: EdgeInsets.symmetric(vertical: 9.h, horizontal: 9.w),
    margin: EdgeInsets.symmetric(horizontal: horizontalPadding.toDouble()),
    decoration: BoxDecoration(
      border: Border.all(color: greyE7),
      borderRadius: BorderRadius.circular(20.r),
    ),
    child: Row(
      children: [
        // icon
        Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: Get.theme.colorScheme.primary,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: SvgPicture.asset(icon, width: iconSize.toDouble()),
        ),

        const Gap(10),

        // title
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextWidget(text: title, fontWeight: FontWeight.bold),
              CustomTextWidget(text: subTitle, color: greyB2),
            ],
          ),
        ),
      ],
    ),
  );
}
