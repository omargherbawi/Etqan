import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:etqan_edu_app/config/app_colors.dart';
import 'package:etqan_edu_app/core/enums/text_style_enum.dart';
import 'package:etqan_edu_app/core/utils/utils.dart';
import 'package:etqan_edu_app/core/widgets/custom_button.dart';
import 'package:etqan_edu_app/core/widgets/custom_text_widget.dart';

class CustomModalBottomSheet extends StatelessWidget {
  final String title;
  final String description;
  final String? confirmButtonText;
  final String? cancelButtonText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const CustomModalBottomSheet({
    super.key,
    required this.title,
    required this.description,
    this.confirmButtonText,
    this.cancelButtonText,
    this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomTextWidget(text: title),
        // Row(
        //   children: [
        //     CustomTextWidget(
        //       text: title,
        //     ),
        //     const Spacer(),
        //     IconButton(
        //       highlightColor: Colors.transparent,
        //       onPressed: () {
        //         Navigator.pop(context);
        //       },
        //       icon: Icon(
        //         Icons.close,
        //         size: 30.r,
        //       ),
        //     ),
        //   ],
        // ),
        SizedBox(height: 10.h),
        Divider(
          color: AppLightColors.grayColor,
          thickness: 0.5,
          endIndent: 20.w,
          indent: 20.w,
        ),
        Gap(20.h),
        CustomTextWidget(
          text: description,
          textThemeStyle: TextThemeStyleEnum.titleSmall,
          maxLines: 9999999,
        ),
        SizedBox(height: 30.h),
        Row(
          children: [
            Expanded(
              child:
                  cancelButtonText != null
                      ? CustomButton(
                        borderRadius: UIConstants.radius25,
                        backgroundColor: SharedColors.blueGreyColor,
                        borderColor: Theme.of(context).colorScheme.primary,
                        width: double.infinity,
                        onPressed:
                            onCancel ??
                            () {
                              Navigator.pop(context);
                            },
                        child: CustomTextWidget(
                          text: cancelButtonText!,
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: Responsive.isTablet ? 10 : null,
                        ),
                      )
                      : const SizedBox.shrink(),
            ),
            const SizedBox(width: 10),
            Expanded(
              child:
                  confirmButtonText != null
                      ? CustomButton(
                        borderRadius: UIConstants.radius25,
                        width: double.infinity,
                        onPressed: onConfirm ?? () {},
                        child: CustomTextWidget(
                          fontSize: Responsive.isTablet ? 10 : null,

                          text: confirmButtonText!,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      )
                      : const SizedBox.shrink(),
            ),
          ],
        ),
      ],
    );
  }
}
