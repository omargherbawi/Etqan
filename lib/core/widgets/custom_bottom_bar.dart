import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core.dart';

class CustomBottomBar extends StatelessWidget {
  final Widget child;

  const CustomBottomBar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.only(
              left: UIConstants.horizontalPaddingValue,
              right: UIConstants.horizontalPaddingValue,
              bottom: UIConstants.horizontalPaddingValue,
              top: UIConstants.horizontalPaddingValue / 1.5),
          decoration: BoxDecoration(
              color: Get.theme.colorScheme.onSurface,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(UIConstants.radius12),
                topLeft: Radius.circular(UIConstants.radius12),
              ),
              boxShadow: [
                BoxShadow(
                  color: Get.theme.colorScheme.tertiaryContainer.withAlpha(100),
                  offset: const Offset(0, -1),
                  blurRadius: 10,
                )
              ]),

          // shape: RoundedRectangleBorder(
          //
          //   borderRadius: BorderRadius.only(
          //     topRight: Radius.circular(UIConstants.radius25),
          //     topLeft: Radius.circular(UIConstants.radius25),
          //   ),
          // ), //
          child: child, // d
        ),
      ],
    );
  }
}
