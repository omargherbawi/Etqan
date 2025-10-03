import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../../core/core.dart';
import '../controllers/help_center_controller.dart';

class FaqsHelpCenterBuild extends StatelessWidget {
  const FaqsHelpCenterBuild({super.key});

  @override
  Widget build(BuildContext context) {
    final helpCenterController = Get.find<HelpCenterController>();

    return Obx(() {
      return helpCenterController.isLoading.value
          ? LoadingAnimation(color: Get.theme.primaryColor)
          : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Gap(10.h),

              //
              // ********** Faqs title row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    helpCenterController.faqTypes.length,
                    (index) {
                      return Container(
                        margin: EdgeInsets.only(right: 12.w),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(
                            UIConstants.radius25,
                          ),
                          onTap: () {
                            helpCenterController.selectedFaq = index;
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 15.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                UIConstants.radius25,
                              ),
                              color:
                                  index == helpCenterController.selectedFaq
                                      ? Get.theme.primaryColor
                                      : Get
                                          .theme
                                          .colorScheme
                                          .onSecondaryContainer,
                              border: Border.all(
                                color:
                                    Get.theme.colorScheme.onSecondaryContainer,
                                width: 1.5,
                              ),
                            ),
                            child: CustomTextWidget(
                              text:
                                  helpCenterController.faqTypes[index].value
                                      .toString(),
                              textThemeStyle: TextThemeStyleEnum.displayLarge,
                              fontWeight: FontWeight.w400,
                              color:
                                  index == helpCenterController.selectedFaq
                                      ? Get.theme.colorScheme.onSurface
                                      : Get.theme.colorScheme.tertiaryContainer,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Gap(10.h),

              //
              //
              // ********** Faqs question and answers
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: helpCenterController.allFaqs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return buildQuestion(context, index, helpCenterController);
                  },
                ),
              ),
            ],
          );
    });
  }

  Container buildQuestion(
    BuildContext context,
    int index,
    HelpCenterController helpCenterController,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
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
        child: ExpansionTile(
          showTrailingIcon: true,
          iconColor: Get.theme.primaryColor,
          collapsedIconColor: Get.theme.primaryColor,

          // trailing:
          //
          //
          // Icon(
          //   Icons.keyboard_arrow_down_rounded,
          //   size: 25,
          //   color: Get.theme.primaryColor,
          // ),
          title: CustomTextWidget(
            text: helpCenterController.allFaqs[index].question,
            textThemeStyle: TextThemeStyleEnum.bodyMedium,
            fontWeight: FontWeight.w600,
            color: Get.theme.colorScheme.inverseSurface,
          ),

          children: [
            Container(
              margin: const EdgeInsets.only(),
              child: Divider(
                endIndent: 12.w,
                indent: 12.w,
                height: 3.h,
                thickness: 0.5.h,
                color: Get.theme.colorScheme.primaryContainer,
              ),
            ),
            Container(
              margin: EdgeInsets.all(10.w),
              child: CustomTextWidget(
                text: helpCenterController.allFaqs[index].description,
                textThemeStyle: TextThemeStyleEnum.bodyMedium,
                maxLines: 5,
                fontWeight: FontWeight.w400,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
