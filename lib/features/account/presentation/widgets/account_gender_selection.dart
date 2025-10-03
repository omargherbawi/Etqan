import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' hide Trans;
import '../../../../core/core.dart';

class AccountGenderSelection extends StatelessWidget {
  final ValueNotifier<String> selectedGender;
  final ValueChanged<String> onChanged;

  const AccountGenderSelection({
    super.key,
    required this.selectedGender,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: selectedGender,
      builder: (context, gender, _) {
        return GestureDetector(
          onTap: () {
            // Pass the current selected gender into the modal to pre-select it
            HelperFunctions.showCustomModalBottomSheet(
              showDragHandler: true,
              context: context,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CustomTextWidget(
                    text: "selectGender",
                    textThemeStyle: TextThemeStyleEnum.displayLarge,
                  ),
                  SizedBox(height: 10.h),
                  // Male option
                  GestureDetector(
                    onTap: () {
                      onChanged("male");
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomTextWidget(
                          text: "male",
                          textThemeStyle: TextThemeStyleEnum.titleSmall,
                          color: Get.theme.colorScheme.inverseSurface,
                        ),
                        Icon(
                          gender == "male"
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.h),
                  // Female option
                  GestureDetector(
                    onTap: () {
                      onChanged("female");
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomTextWidget(
                          text: "female",
                          textThemeStyle: TextThemeStyleEnum.titleSmall,
                          color: Get.theme.colorScheme.inverseSurface,
                        ),
                        Icon(
                          gender == "female"
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          child: AbsorbPointer(
            absorbing: true,
            child: TextWithTextField(
              filled: true,
              fillColor: Get.theme.colorScheme.onSecondaryContainer,
              boldLabel: true,
              text: "gender",
              hintText: "gender",
              controller:
                  gender.isNotEmpty
                      ? TextEditingController(text: gender)
                      : TextEditingController(),
              suffix: Icon(
                Icons.arrow_forward_ios,
                size: 20.sp,
                color: Theme.of(context).colorScheme.inverseSurface,
              ),
            ),
          ),
        );
      },
    );
  }
}
