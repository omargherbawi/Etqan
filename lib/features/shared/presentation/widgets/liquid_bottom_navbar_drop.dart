import '../../../../config/app_colors.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class LiquidDrop extends StatelessWidget {
  const LiquidDrop({super.key});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: math.pi / 4,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: SharedColors.darkRedColor,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
