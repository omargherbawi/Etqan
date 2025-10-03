import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' hide Trans;
import 'package:tedreeb_edu_app/core/core.dart';

class CustomTabbarWidget extends StatelessWidget {
  final TabController? controller;
  final List<String> tabs;
  final bool allowPadding;

  const CustomTabbarWidget({
    super.key,
    this.controller,
    required this.tabs,
    this.allowPadding = true,
  });

  @override
  Widget build(BuildContext context) {
    return TabBar(
      isScrollable: true,
      padding:
          allowPadding
              ? EdgeInsets.symmetric(
                horizontal: UIConstants.horizontalPaddingValue,
              )
              : EdgeInsets.zero,
      indicatorColor: Get.theme.primaryColor,
      controller: controller,
      indicatorSize: TabBarIndicatorSize.tab,
      dividerColor: Get.theme.colorScheme.primaryContainer,
      indicatorWeight: 3.h,
      labelStyle: Get.textTheme.titleSmall!.copyWith(
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: Get.textTheme.titleSmall,
      labelColor: Get.theme.primaryColor,
      unselectedLabelColor: Get.theme.colorScheme.inverseSurface,
      tabAlignment: TabAlignment.start,
      tabs: List.generate(
        tabs.length,
        (index) => Tab(
          text: tabs[index].tr(context: context),
          // child: CustomTextWidget(
          //   text: "FAQ",
          //   textThemeStyle: TextThemeStyleEnum.displayMedium,
          //   color: Get.theme.primaryColor,
          // ),
        ),
      ),
    );
  }
}
