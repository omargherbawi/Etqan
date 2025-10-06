import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:etqan_edu_app/features/courses/presentation/widgets/mentor_tile_widget.dart';

import '../../../../core/utils/instructor_utils.dart';
import '../../../../core/utils/shared.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets/loader.dart';
import '../../../home/presentation/controllers/refresh_home_data_controller.dart';

class AllMentorScreen extends StatelessWidget {
  const AllMentorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final controller = Get.find<HomeDataController>();

    return Scaffold(
      appBar: CustomAppBar(title: "معلمونا", onBack: () => Get.back()),
      body: SafeArea(
        top: false,
        child: GetBuilder<HomeDataController>(
          builder: (controller) {
            return Padding(
              padding: UIConstants.mobileBodyPaddingWithoutBottom,
              child: Obx(() {
                return controller.isLoading.value &&
                        controller.instructors.isEmpty
                    ? LoadingAnimation(color: Get.theme.primaryColor)
                    : RefreshIndicator(
                      onRefresh: () async {
                        await controller.refreshInstructors();
                      },
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (scrollInfo) {
                          if (!controller.isFetchingInstructors &&
                              controller.hasMore &&
                              scrollInfo.metrics.pixels >=
                                  scrollInfo.metrics.maxScrollExtent - 200) {
                            controller.fetchAllInstructors(loadMore: true);
                          }
                          return false;
                        },
                        child: ListView.separated(
                          separatorBuilder:
                              (context, index) => SizedBox(height: 8.h),
                          itemCount:
                              controller.instructors.length +
                              (controller.hasMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index < controller.instructors.length) {
                              final instructor = controller.instructors[index];
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 6.h),
                                child: MentorTileWidget(
                                  mentor: instructor,
                                  onTap: () {
                                    InstructorUtils.showInstructorDialog(
                                      context,
                                      instructor,
                                    );
                                  },
                                ),
                              );
                            } else {
                              return const Padding(
                                padding: EdgeInsets.all(16),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    );
              }),
            );
          },
        ),
      ),
    );
  }
}
