import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../../core/core.dart';
import '../../data/models/filter_model.dart';
import '../controllers/filter_courses_controller.dart';

class DynamicllyFilter extends StatefulWidget {
  const DynamicllyFilter({super.key});

  @override
  State<DynamicllyFilter> createState() => _DynamicllyFilterState();
}

class _DynamicllyFilterState extends State<DynamicllyFilter> {
  List<FilterModel> filters = [];
  List<int> filterSelected = [];

  @override
  void initState() {
    super.initState();
    // Create local copies from the controller's reactive state.
    final filterController = Get.find<FilterCoursesController>();

    // Make a local copy of the filters.
    filters = List<FilterModel>.from(filterController.filters);

    // Make a local copy of the currently selected filters.
    filterSelected = List<int>.from(filterController.filtersSelected);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 20.w),
        child: Column(
          children: [
            ...List.generate(filters.length, (index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title of the filter group.
                  CustomTextWidget(text: filters[index].title ?? ''),
                  const Gap(16),
                  // Options for the filter.
                  ...List.generate(filters[index].options?.length ?? 0, (i) {
                    final option = filters[index].options?[i];
                    final isSelected = filterSelected.contains(option?.id);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: checkButton(option?.title ?? '', isSelected, (
                        value,
                      ) {
                        setState(() {
                          if (filterSelected.contains(option?.id)) {
                            filterSelected.remove(option?.id);
                          } else {
                            filterSelected.add(option?.id ?? -1);
                          }
                        });
                      }),
                    );
                  }),
                ],
              );
            }),
            const Gap(25),
            // Button to apply filters.
            CustomButton(
              onPressed: () {
                // Update the controller with the new filters.
                Get.find<FilterCoursesController>().applyFilters(
                  filterSelected: filterSelected,
                );
                Get.back(result: true);
              },
              width: Get.width,
              height: 52,
              backgroundColor: Get.theme.colorScheme.primary,
              child: CustomTextWidget(
                text: "filterItems",
                color: Get.theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
