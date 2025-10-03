import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/app_colors.dart';

class CircularIconWidget extends StatelessWidget {
  final Widget widget;
  final Color? color;
  final double? size;
  const CircularIconWidget({
    super.key,
    required this.widget,
    this.color,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size?.r ?? 51.r,
      width: size?.r ?? 51.r,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color ?? SharedColors.blueGreyColor,
      ),
      child: widget,
    );
  }
}
