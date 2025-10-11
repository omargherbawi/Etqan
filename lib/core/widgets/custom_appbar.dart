import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:etqan_edu_app/config/app_colors.dart';
import 'package:etqan_edu_app/core/core.dart';
import 'package:etqan_edu_app/core/utils/console_log_functions.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.backgroundColor = Colors.transparent,
    this.leading,
    this.centerTitle = true,
    this.bottom,
    this.flexibleSpace,
    this.popPath,
    this.popOnePage,
    this.onBack,
    this.actions,
    this.systemUI,
    this.titleHeroTag,
    this.leadingWidth,
    this.toolbarHeight,
    this.isLocalize = true,
  });

  final String? title;
  final Widget? titleWidget;
  final SystemUiOverlayStyle? systemUI;
  final Color backgroundColor;
  final Widget? leading;
  final bool centerTitle;
  final PreferredSizeWidget? bottom;
  final Widget? flexibleSpace;
  final String? popPath;
  final bool? popOnePage;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final String? titleHeroTag;
  final double? leadingWidth;
  final double? toolbarHeight;
  final bool isLocalize;

  @override
  Widget build(BuildContext context) {
    logInfo(
      "MediaQuery.of(context).viewInsets.top: ${MediaQuery.of(context).viewInsets.top}",
    );
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: MediaQuery.of(context).viewInsets.top + 8,
      ),
      child: AppBar(
        scrolledUnderElevation: 0,
        toolbarHeight: toolbarHeight,
        systemOverlayStyle: systemUI ?? SystemUiOverlayStyle.dark,
        actions: actions,
        flexibleSpace: flexibleSpace,
        leadingWidth: leadingWidth ?? 40.w,
        backgroundColor: backgroundColor,
        automaticallyImplyLeading: false,
        centerTitle: centerTitle,
        leading:
            leading ??
            IconButton(
              padding: EdgeInsets.zero,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              hoverColor: Colors.transparent,
              onPressed:
                  onBack ??
                  () {
                    Get.back();
                  },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Get.theme.colorScheme.inverseSurface,
                size: Responsive.isTablet ? 20.w : 24,
              ),
            ),
        title:
            titleWidget ??
            (titleHeroTag != null
                ? Hero(
                  tag: titleHeroTag!,
                  child: CustomTextWidget(
                    color: AppLightColors.charcoalblue,
                    text: title ?? "",
                    isLocalize: isLocalize,
                    fontSize: Responsive.isTablet ? 10 : 18,
                  ),
                )
                : CustomTextWidget(
                  color: AppLightColors.charcoalblue,
                  text: title ?? "",
                  isLocalize: isLocalize,
                  textThemeStyle: TextThemeStyleEnum.titleLarge,
                  fontSize: Responsive.isTablet ? 8 : 16,
                )),
        bottom: bottom,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
