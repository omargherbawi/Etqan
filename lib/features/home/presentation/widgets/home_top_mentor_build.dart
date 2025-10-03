import '../../../../core/utils/instructor_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../../config/asset_paths.dart';
import '../../../../core/core.dart';

import '../controllers/refresh_home_data_controller.dart';

class HomeTopMentorBuild extends StatelessWidget {
  const HomeTopMentorBuild({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeDataController>(
      builder: (controller) {
        return controller.isFetchingInstructors
            ? const LoadingAnimation()
            : controller.instructors.isEmpty
            ? const Center(
              child: CustomTextWidget(
                text: "No instructors found",
                textThemeStyle: TextThemeStyleEnum.labelLarge,
              ),
            )
            : SizedBox(
              height: 95.h,
              child: ListView.separated(
                separatorBuilder: (context, index) => SizedBox(width: 24.w),
                scrollDirection: Axis.horizontal,
                cacheExtent: 8 * 95,
                itemCount:
                    controller.instructors.length > 8
                        ? 8
                        : controller.instructors.length,
                itemBuilder: (context, index) {
                  final instructor = controller.instructors[index];
                  return GestureDetector(
                    onTap: () {
                      InstructorUtils.showInstructorDialog(context, instructor);
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                        right: UIConstants.horizontalPaddingValue / 2.5,
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 60.w,
                            height: 60.w,
                            padding: EdgeInsets.all(5.w),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Get.theme.colorScheme.inversePrimary,
                            ),
                            child:
                                instructor.avatar != null &&
                                        instructor.avatar!.isNotEmpty
                                    ? ClipOval(
                                      child: CustomCachedImage(
                                        image: instructor.avatar!,
                                        fit: BoxFit.cover,
                                        width: 50.w,
                                        height: 50.w,
                                      ),
                                    )
                                    : Image.asset(
                                      AssetPaths.personFilled,
                                      fit: BoxFit.contain,
                                      color: Get.theme.primaryColor.withAlpha(
                                        55,
                                      ),
                                    ),
                          ),
                          Gap(5.h),
                          CustomTextWidget(
                            text: instructor.fullName ?? "-",
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            textThemeStyle: TextThemeStyleEnum.labelLarge,
                            fontWeight: FontWeight.w600,
                            color: Get.textTheme.displayMedium!.color,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
      },
    );
  }
}
