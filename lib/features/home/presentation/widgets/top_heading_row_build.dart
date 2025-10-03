import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/enums/text_style_enum.dart';
import '../../../../core/utils/shared.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_widget.dart';

class TopHeadingRowBuild extends StatelessWidget {
  final String heading;
  final String buttonText;

  final void Function()? onTap;

  const TopHeadingRowBuild({
    super.key,
    required this.heading,
    required this.buttonText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: UIConstants.horizontalPaddingValue,
        right: UIConstants.horizontalPaddingValue,
        top: 16.h,
        bottom: 8.h,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTextWidget(
                text: heading,
                maxLines: 1,
                textThemeStyle: TextThemeStyleEnum.displayLarge,
              ),
              CustomTextButton(
                text: buttonText,
                onTap: onTap,
                textThemeStyle: TextThemeStyleEnum.titleSmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
