import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart' hide Trans;
import 'package:persian_number_utility/persian_number_utility.dart';
import '../../../../config/asset_paths.dart';
import '../../../../core/core.dart';
import '../../data/datasources/shared_remote_datasources.dart';

class UserProfileWidget {
  static final primaryColor = Get.theme.colorScheme.primary;
  static final isTablet = Get.width > 650;

  static Widget profileItem(
    String name,
    String count,
    String iconPath,
    Color color, {
    int width = 24,
  }) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withValues(alpha: .3),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: SvgPicture.asset(
            iconPath,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            width: width.toDouble(),
          ),
        ),
        const Gap(8),
        CustomTextWidget(text: count, fontWeight: FontWeight.bold),
        CustomTextWidget(text: name, color: greyB2),
      ],
    );
  }

  static Widget tabView(
    String title1,
    String title2,
    bool isOnTitle1,
    Function(bool value) onChangeTab,
  ) {
    return Container(
      width: Get.width,
      height: 52,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
      decoration: BoxDecoration(
        border: Border.all(color: greyE7),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedAlign(
            alignment:
                isOnTitle1
                    ? AlignmentDirectional.centerStart
                    : AlignmentDirectional.centerEnd,
            duration: const Duration(milliseconds: 250),
            child: Container(
              width: (Get.width - 45) / 2,
              height: 52,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(17),
              ),
            ),
          ),
          Positioned.fill(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      onChangeTab(true);
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Center(
                      child: Text(
                        title1,
                        style: style14Regular().copyWith(
                          color: isOnTitle1 ? Colors.white : greyA5,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      onChangeTab(false);
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Center(
                      child: Text(
                        title2,
                        style: style14Regular().copyWith(
                          color: !isOnTitle1 ? Colors.white : greyA5,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static showSendMessageDialog(int id) {
    TextEditingController subjectController = TextEditingController();
    FocusNode subjectNode = FocusNode();

    TextEditingController emailController = TextEditingController();
    FocusNode emailNode = FocusNode();

    TextEditingController messageController = TextEditingController();
    FocusNode messageNode = FocusNode();

    bool isLoading = false;
    final sharedRemoteDatasources = Get.find<SharedRemoteDatasources>();

    return baseBottomSheet(
      child: Builder(
        builder: (context) {
          return StatefulBuilder(
            builder: (context, state) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  right: 21,
                  left: 21,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(25),
                    const CustomTextWidget(
                      text: "newMessage",
                      fontWeight: FontWeight.bold,
                    ),
                    const Gap(20),
                    CustomFormField(
                      controller: subjectController,
                      focusNode: subjectNode,
                      hintText: "subject",
                      prefix: SvgPicture.asset(AssetPaths.profileSvg),
                      hasBorderSide: true,
                    ),
                    const Gap(16),
                    CustomFormField(
                      controller: emailController,
                      focusNode: emailNode,
                      hintText: "email",
                      prefix: SvgPicture.asset(AssetPaths.mailSvg),
                      hasBorderSide: true,
                    ),
                    const Gap(16),
                    descriptionInput(
                      messageController,
                      messageNode,
                      "messageBody",
                      isBorder: true,
                    ),
                    const Gap(20),
                    Center(
                      child: CustomButton(
                        onPressed: () async {
                          if (messageController.text.trim().isNotEmpty &&
                              emailController.text.trim().isNotEmpty &&
                              subjectController.text.trim().isNotEmpty) {
                            isLoading = true;
                            state(() {});

                            bool
                            res = await sharedRemoteDatasources.sendMessage(
                              id,

                              // subjectController.text.trim().toEnglishDigit(),
                              // emailController.text.trim().toEnglishDigit(),
                              // messageController.text.trim().toEnglishDigit(),
                              subjectController.text.trim().toEnglishDigit(),
                              emailController.text.trim().toEnglishDigit(),
                              messageController.text.trim().toEnglishDigit(),
                            );

                            isLoading = false;
                            state(() {});

                            if (res) {
                              Get.back(result: true);
                            }
                          }
                        },
                        width: Get.width,
                        height: 52,
                        backgroundColor: primaryColor,
                        child:
                            isLoading
                                ? const LoadingAnimation()
                                : CustomTextWidget(
                                  text: "send",
                                  color: Get.theme.colorScheme.onSurface,
                                ),
                      ),
                    ),
                    const Gap(20),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
