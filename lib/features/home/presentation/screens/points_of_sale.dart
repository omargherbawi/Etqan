import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/app_colors.dart';
import '../../../../core/utils/helper_functions.dart';
import '../../../../core/utils/shared.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets/custom_text_widget.dart';
import '../../../../core/widgets/loader.dart';
import '../../../../core/widgets/text_with_text_field.dart';
import '../controllers/points_of_sale_controller.dart';
import '../widgets/point_of_sale_widget.dart';

class PointsOfSale extends StatefulWidget {
  const PointsOfSale({super.key});

  @override
  State<PointsOfSale> createState() => _PointsOfSaleState();
}

class _PointsOfSaleState extends State<PointsOfSale> {
  final pointsOfSaleController = Get.put(PointsOfSaleController());
  final provinceTextController = TextEditingController();

  @override
  void dispose() {
    provinceTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "sellPlaces"),
      body: Padding(
        padding: UIConstants.mobileBodyPadding,
        child: Obx(() {
          return Column(
            children: [
              // if (pointsOfSaleController.pointsOfSale.isNotEmpty)
              GestureDetector(
                onTap: () {
                  HelperFunctions.showCustomModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        pointsOfSaleController.provinces.length,
                            (index) {
                          final province =
                          pointsOfSaleController.provinces[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0.h),
                            child: GestureDetector(
                              onTap: () {
                                pointsOfSaleController.updateSelectedProvince(
                                  province,
                                );
                                Get.close(1);
                              },
                              child: CustomTextWidget(
                                text: province.arTitle ?? "",
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
                child: AbsorbPointer(
                  absorbing: true,
                  child: TextWithTextField(
                    enabled: false,
                    text: "governorate",
                    suffix: const Icon(
                      Icons.keyboard_arrow_down_sharp,
                      color: Colors.black,
                    ),
                    hintText: "selectGovernorate",
                    filled: true,
                    fillColor: Get.theme.colorScheme.onSecondaryContainer,
                    boldLabel: true,
                    controller: TextEditingController(
                      text:
                      pointsOfSaleController
                          .selectedProvince
                          .value
                          ?.arTitle ??
                          "",
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12.h),

              Expanded(
                child:
                pointsOfSaleController.isLoading.value &&
                    pointsOfSaleController.pointsOfSale.isEmpty
                    ? const Center(child: LoadingAnimation())
                    : RefreshIndicator(
                  onRefresh:
                      () =>
                      pointsOfSaleController.refreshPointsOfSale(),
                  child:
                  NotificationListener<ScrollNotification>(
                    onNotification: (scrollInfo) {
                      if (!pointsOfSaleController
                          .isFetchingPOS &&
                          pointsOfSaleController.hasMore &&
                          scrollInfo.metrics.pixels >=
                              scrollInfo
                                  .metrics
                                  .maxScrollExtent -
                                  200) {
                        pointsOfSaleController
                            .fetchPointsOfSaleByCountryId(
                          loadMore: true,
                        );
                      }
                      return false;
                    },
                    child: ListView.separated(
                      physics:
                      const AlwaysScrollableScrollPhysics(),
                      itemCount:
                      pointsOfSaleController
                          .pointsOfSale
                          .length +
                          (pointsOfSaleController.hasMore
                              ? 1
                              : 0),
                      separatorBuilder:
                          (context, index) => Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 8.h,
                        ),
                        child: const Divider(
                          color: SharedColors.grayColor,
                          thickness: 0.5,
                        ),
                      ),
                      itemBuilder: (context, index) {
                        if (index <
                            pointsOfSaleController
                                .pointsOfSale
                                .length) {
                          return PointOfSaleWidget(
                            pointOfSale:
                            pointsOfSaleController
                                .pointsOfSale[index],
                          );
                        } else {
                          // loader at bottom
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
      ),
    );
  }
}
