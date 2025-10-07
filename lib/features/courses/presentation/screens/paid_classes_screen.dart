import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/core.dart';

import '../../../../core/routes/route_paths.dart';
import '../controllers/free_classes_controller.dart';
import '../controllers/user_course_controller.dart';
import '../widgets/custom_course_container.dart';

class PaidClassesScreen extends StatefulWidget {
  const PaidClassesScreen({super.key});

  @override
  State<PaidClassesScreen> createState() => _PaidClassesScreenState();
}

class _PaidClassesScreenState extends State<PaidClassesScreen> {
  final FreeClassesController controller = Get.find<FreeClassesController>();
  final userCoursesController = Get.put(UserCourseController());

  final ScrollController scrollController = ScrollController();
  final PageController sliderPageController = PageController();
  int currentSliderIndex = 0;

  @override
  void initState() {
    super.initState();

    // Get the category from the route arguments and initialize controller data.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // final CategoryModel? cat = ModalRoute.of(context)!.settings.arguments as CategoryModel?;
      // controller.sort.value = 'bestsellers';
      // if (cat != null) {
      controller.initData();
      // }
    });

    // Listen for scroll events to implement lazy-loading.
    scrollController.addListener(() {
      final min = scrollController.position.pixels;
      final max = scrollController.position.maxScrollExtent;
      if ((max - min) < 100 &&
          !controller.isFetchingMoreData.value &&
          !controller.isLoading.value) {
        controller.fetchData();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    sliderPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    userCoursesController.fetchPaidCourses();

    return Scaffold(
      appBar: const CustomAppBar(title: "paidCourses"),
      body: Obx(() {
        return userCoursesController.isLoading.value
            ? LoadingAnimation(color: Get.theme.primaryColor)
            : Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => userCoursesController.fetchPaidCourses(),
                child: NotificationListener<ScrollNotification>(
                  onNotification: (scrollInfo) {
                    if (!userCoursesController.isFetchingPaid.value &&
                        userCoursesController.hasMorePaid.value &&
                        scrollInfo.metrics.pixels >=
                            scrollInfo.metrics.maxScrollExtent - 200) {
                      userCoursesController.fetchPaidCourses(
                        loadMore: true,
                      );
                    }
                    return false;
                  },

                  child: ListView.separated(
                    separatorBuilder:
                        (context, index) => SizedBox(height: 8.h),
                    itemCount:
                    userCoursesController.allPaidCourses.length +
                        (userCoursesController.hasMorePaid.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index <
                          userCoursesController.allPaidCourses.length) {
                        final course =
                        userCoursesController.allPaidCourses[index];
                        return CustomCourseContainer(
                          showRating: false,
                          course: course,
                          isOngoing: true,
                          onCourseTap: () {
                            Get.toNamed(
                              RoutePaths.courseDetailScreen,
                              arguments: {
                                "isBundle": course.type == "bundle",
                                "id": course.id,
                                "isPrivate":
                                course.isPrivate == 1 ? true : false,
                              },
                            );
                          },
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: LoadingAnimation(
                            color: Get.theme.primaryColor,
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
