import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../../core/core.dart';
import '../controllers/filter_courses_controller.dart';

class OptionsFilter extends StatefulWidget {
  const OptionsFilter({super.key});

  @override
  State<OptionsFilter> createState() => _OptionsFilterState();
}

class _OptionsFilterState extends State<OptionsFilter> {
  bool upcomingClasses = false;
  bool freeClasses = false;
  bool discountClasses = false;
  bool downloadabeClasses = false;
  bool bundleCourse = false;

  bool allSort = false;
  bool newestSort = false;
  bool highSort = false;
  bool lowSort = false;
  bool bestSellerSort = false;
  bool bestRatedSort = false;

  final filterController = Get.find<FilterCoursesController>();

  @override
  void initState() {
    super.initState();

    upcomingClasses = filterController.upcoming.value;
    freeClasses = filterController.free.value;
    discountClasses = filterController.discount.value;
    downloadabeClasses = filterController.downloadable.value;
    bundleCourse = filterController.bundleCourse.value;

    switch (filterController.sort.value) {
      case '':
        allSort = true;
        break;

      case 'newest':
        newestSort = true;
        break;

      case 'expensive':
        highSort = true;
        break;

      case 'inexpensive':
        lowSort = true;
        break;

      case 'bestsellers':
        bestSellerSort = true;
        break;

      case 'best_rates':
        bestRatedSort = true;
        break;

      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return Container(
      width: Get.width,
      constraints: BoxConstraints(minHeight: 0, maxHeight: Get.height * .8),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: UIConstants.mobileBodyPaddingWithoutBottom,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Gap(20),
            const CustomTextWidget(text: "options"),
            const Gap(12),
            switchButton("upcomingClasses", upcomingClasses, (value) {
              setState(() {
                upcomingClasses = value;
              });
            }),
            const Gap(12),
            switchButton("freeClasses", freeClasses, (value) {
              setState(() {
                freeClasses = value;
              });
            }),
            const Gap(12),
            switchButton("discountedClasses", discountClasses, (value) {
              setState(() {
                discountClasses = value;
              });
            }),
            const Gap(12),
            switchButton("downloadableContent", downloadabeClasses, (value) {
              setState(() {
                downloadabeClasses = value;
              });
            }),
            const Gap(12),
            switchButton("bundleCourse", bundleCourse, (value) {
              setState(() {
                bundleCourse = value;
              });
            }),
            const Gap(25),
            const CustomTextWidget(text: "sortBy"),
            const Gap(16),
            radioButton("all", allSort, (value) {
              sortOff();
              allSort = value;
              setState(() {});
            }),
            const Gap(16),
            radioButton("newest", newestSort, (value) {
              sortOff();
              newestSort = value;
              setState(() {});
            }),
            const Gap(16),
            radioButton("highestPrice", highSort, (value) {
              sortOff();
              highSort = value;
              setState(() {});
            }),
            const Gap(16),
            radioButton("lowestPrice", lowSort, (value) {
              sortOff();
              lowSort = value;
              setState(() {});
            }),
            const Gap(16),
            radioButton("bestSellers", bestSellerSort, (value) {
              sortOff();
              bestSellerSort = value;
              setState(() {});
            }),
            const Gap(16),
            radioButton("bestRated", bestRatedSort, (value) {
              sortOff();
              bestRatedSort = value;
              setState(() {});
            }),
            const Gap(25),
            CustomButton(
              onPressed: () {
                filterController.upcoming(upcomingClasses);
                filterController.free(freeClasses);
                filterController.discount(discountClasses);
                filterController.downloadable(downloadabeClasses);
                filterController.bundleCourse(bundleCourse);

                filterController.sort.value =
                    allSort
                        ? ''
                        : newestSort
                        ? 'newest'
                        : highSort
                        ? 'expensive'
                        : lowSort
                        ? 'inexpensive'
                        : bestSellerSort
                        ? 'bestsellers'
                        : bestRatedSort
                        ? 'best_rates'
                        : '';

                Get.back(result: true);
              },
              width: Get.width,
              height: 52,
              backgroundColor: Get.theme.colorScheme.primary,
              child: CustomTextWidget(
                text: "applyOptions",
                color: Get.theme.colorScheme.onSurface,
              ),
            ),
            const Gap(30),
          ],
        ),
      ),
    );
  }

  sortOff() {
    allSort = false;
    newestSort = false;
    highSort = false;
    lowSort = false;
    bestSellerSort = false;
    bestRatedSort = false;
  }
}
