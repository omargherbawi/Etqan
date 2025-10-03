import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/core.dart';
import '../../../../core/services/url_launcher_service.dart';
import '../../data/models/point_of_sale_model.dart';

class PointOfSaleWidget extends StatelessWidget {
  final PointOfSaleModel pointOfSale;
  const PointOfSaleWidget({super.key, required this.pointOfSale});

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left: Store info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextWidget(
                  text: pointOfSale.name ?? "اسم غير متوفر",
                  textThemeStyle: TextThemeStyleEnum.titleLarge,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 4),
                CustomTextWidget(
                  text: pointOfSale.phoneNumber ?? "رقم غير متوفر",
                  textThemeStyle: TextThemeStyleEnum.bodyMedium,
                ),
                const SizedBox(height: 4),
                CustomTextWidget(
                  text: pointOfSale.address ?? "",
                  textThemeStyle: TextThemeStyleEnum.bodyMedium,
                ),
              ],
            ),
          ),

          // Right: Action icons
          Column(
            children: [
              if (pointOfSale.phoneNumber != null &&
                  pointOfSale.phoneNumber != "")
                IconButton(
                  onPressed: () {
                    LaunchUrlService.makeAPhoneCall(
                      context,
                      pointOfSale.phoneNumber!,
                    );
                  },
                  icon: Icon(
                    Icons.phone_outlined,
                    color: theme.colorScheme.primary,
                  ),
                  tooltip: 'اتصل الآن',
                ),
              if ((pointOfSale.latitude != null &&
                      pointOfSale.latitude != "") &&
                  (pointOfSale.longitude != null &&
                      pointOfSale.longitude != ""))
                IconButton(
                  onPressed: () {
                    final lat =
                        double.tryParse(pointOfSale.latitude ?? '') ?? 0.0;
                    final lng =
                        double.tryParse(pointOfSale.longitude ?? '') ?? 0.0;
                    LaunchUrlService.openMap(lat, lng);
                  },
                  icon: Icon(
                    Icons.location_on_outlined,
                    color: theme.colorScheme.primary,
                  ),
                  tooltip: 'افتح على الخريطة',
                ),
            ],
          ),
        ],
      ),
    );
  }
}
