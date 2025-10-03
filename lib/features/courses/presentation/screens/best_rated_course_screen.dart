import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/core.dart';

import '../controllers/popular_course_controller.dart';
import '../widgets/view_all_page_body.dart';

class BestRatedCourseScreen extends StatefulWidget {
  const BestRatedCourseScreen({super.key});

  @override
  State<BestRatedCourseScreen> createState() => _BestRatedCourseScreenState();
}

class _BestRatedCourseScreenState extends State<BestRatedCourseScreen> {
  final BestRatedCourseController controller =
      Get.find<BestRatedCourseController>();

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
    return Scaffold(
      appBar: const CustomAppBar(title: "bestRatedCourses"),
      body: ViewAllPageBody(
        controller: controller,
        scrollController: scrollController,
        sliderPageController: sliderPageController,
        currentSliderIndex: currentSliderIndex,
        onPageChanged: (value) async {
          await Future.delayed(const Duration(milliseconds: 500));
          setState(() {
            currentSliderIndex = value;
          });
        },
      ),
    );
  }
}

// class PopularCoursesScreen extends StatelessWidget {
//   const PopularCoursesScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<PopularCourseController>();
//
//     return Scaffold(
//       appBar: CustomAppBar(
//         title: "popularCourses",
//         onBack: () => Get.back(),
//       ),
//       body: SafeArea(
//           top: false,
//           child: Padding(
//               padding: UIConstants.horizontalPadding,
//               child: Obx(
//                 () {
//                   return controller.isLoading.value
//                       ? LoadingAnimation(
//                           color: Get.theme.primaryColor,
//                         )
//                       : Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Gap(10.h),
//                             // Expanded(
//                             //   child: ListView.separated(
//                             //     separatorBuilder: (context, index) {
//                             //       return SizedBox(height: 8.h);
//                             //     },
//                             //     shrinkWrap: true,
//                             //     itemCount: userCourseController.allCourses.length,
//                             //     itemBuilder: (BuildContext context, int index) {
//                             //       CourseModel course = userCourseController.allCourses[index];
//
//                             //       return CourseContainerDesign(
//                             //         child: CustomCourseContainer(
//                             //           course: course,
//                             //           isOngoing: false,
//                             //           isFavorite: index % 2 == 1,
//                             //           onFavoriteBtnTap: () {
//                             //             favoriteConfirmationDialog(context, course);
//                             //           },
//                             //         ),
//                             //       );
//                             //     },
//                             //   ),
//                             // ),
//                           ],
//                         );
//                 },
//               ))),
//     );
//   }
//
//   void favoriteConfirmationDialog(BuildContext context, CourseModel course) async {
//     return HelperFunctions.showCustomModalBottomSheet(
//       context: context,
//       showDragHandler: true,
//       child: SavedConfirmationBottomSheet(
//         title: (course.isFavorite ?? false) ? "removeFromFavorite" : "addToFavorite",
//         confirmButtonText: "yesConfirm",
//         onCancel: () => Get.back(),
//         onConfirm: () => Get.back(),
//         cancelButtonText: "cancel",
//         children: [
//           CustomCourseContainer(
//             course: course,
//             isFavorite: false,
//             isOngoing: false,
//             showRating: false,
//             showBorder: false,
//           ),
//         ],
//       ),
//     );
//   }
// }
