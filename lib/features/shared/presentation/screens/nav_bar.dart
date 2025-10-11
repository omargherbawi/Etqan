import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart' hide Trans;
import 'package:google_fonts/google_fonts.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/asset_paths.dart';
import '../controllers/bottom_nav_bar_controller.dart';
import '../controllers/current_user_controller.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserController = Get.find<CurrentUserController>();

    return GetBuilder<BottomNavController>(
      builder: (controller) {
        return Scaffold(
          body: IndexedStack(
            index: controller.currentIndex.value,
            children: controller.screens,
          ),
          bottomNavigationBar: _buildBottomNavBar(
            context,
            controller,
            currentUserController,
          ),
        );
      },
    );
  }

  Widget _buildBottomNavBar(
    BuildContext context,
    BottomNavController controller,
    CurrentUserController currentUserController,
  ) {
    final List<BottomNavigationBarItem> items = [
      BottomNavigationBarItem(
        icon: _buildNavItemIcon(
          controller,
          context,
          index: 0,
          asset: AssetPaths.homeSvg,
        ),
        label: "home".tr(context: context),
      ),
      BottomNavigationBarItem(
        icon: _buildNavItemIcon(
          controller,
          context,
          index: 1,
          asset: AssetPaths.myClassesSvg,
        ),
        label: "myCourses".tr(context: context),
      ),
      BottomNavigationBarItem(
        icon: _buildNavItemIcon(
          controller,
          context,
          index: 2,
          asset: AssetPaths.profileSvg,
        ),
        label: "myProfile".tr(context: context),
      ),
    ];
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16.r),
        topRight: Radius.circular(16.r),
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Theme(
              data: Theme.of(context).copyWith(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                splashFactory: NoSplash.splashFactory,
              ),
              child: BottomNavigationBar(
                backgroundColor: Get.theme.colorScheme.onSurface,
                showUnselectedLabels: true,
                selectedItemColor: Theme.of(context).colorScheme.inverseSurface,
                unselectedItemColor: SharedColors.greyTextColor,
                selectedLabelStyle: GoogleFonts.cairo(
                  fontSize: 10.sp,
                  color: SharedColors.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: GoogleFonts.cairo(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                ),
                type: BottomNavigationBarType.fixed,
                currentIndex: controller.currentIndex.value,
                onTap: (index) {
                  controller.setIndex(index);
                },
                items: items,
              ),
            ),
          ),
          // Positioned(
          //   top: -15.h,
          //   left: _calculateLiquidPosition(
          //     context,
          //     controller.currentIndex.value,
          //     controller.screens.length,
          //   ),
          //   child: const LiquidDrop(),
          // ),
        ],
      ),
    );
  }

  // double _calculateLiquidPosition(
  //   BuildContext context,
  //   int selectedIndex,
  //   int screenLength,
  // ) {
  //   final screenWidth = MediaQuery.sizeOf(context).width;
  //   final itemWidth = screenWidth / 3; // Fixed to 3 items
  //   final isRTL = Directionality.of(context) == TextDirection.rtl;

  //   // Invert the index calculation for RTL
  //   return isRTL
  //       ? screenWidth - ((selectedIndex + 1) * itemWidth) + (itemWidth / 2) - 12
  //       : (selectedIndex * itemWidth) + (itemWidth / 2) - 12;
  // }

  Widget _buildNavItemIcon(
    BottomNavController controller,
    BuildContext context, {
    required int index,
    required Object asset,
  }) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child:
          asset is String && asset.contains("svg")
              ? SvgPicture.asset(
                asset,
                width: 28.w,
                height: 28.w,

                colorFilter: ColorFilter.mode(
                  controller.currentIndex.value == index
                      ? SharedColors.primaryColor
                      : SharedColors.greyTextColor,
                  BlendMode.srcIn,
                ),
                key: ValueKey<int>(controller.currentIndex.value),
              )
              : Icon(
                asset as IconData,
                color:
                    controller.currentIndex.value == index
                        ? SharedColors.darkRedColor
                        : SharedColors.greyTextColor,
                size: 28.w,
                key: ValueKey<int>(controller.currentIndex.value),
              ),
    );
  }
}
