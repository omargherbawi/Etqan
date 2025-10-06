import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:etqan_edu_app/core/core.dart';

class CourseContainerDesign extends StatelessWidget {
  final Widget child;

  const CourseContainerDesign({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(UIConstants.radius8),
        border: Border.all(
          color: Get.theme.colorScheme.onSecondaryContainer,
          width: 2.sp,
        ),
      ),
      margin: EdgeInsets.only(bottom: 8.h),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent, // if you want to remove the border
        ),
        child: child,
      ),
    );
  }
}
