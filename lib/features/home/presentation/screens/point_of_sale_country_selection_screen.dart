import 'dart:convert';
import 'dart:developer';

import '../../../../config/config.dart';
import '../../data/models/country_model.dart';
import 'points_of_sale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/core.dart';

import '../../../../core/services/api_services.dart';

class PointOfSaleCountrySelectionScreen extends StatefulWidget {
  const PointOfSaleCountrySelectionScreen({super.key});

  @override
  State<PointOfSaleCountrySelectionScreen> createState() =>
      _PointOfSaleCountrySelectionScreenState();
}

class _PointOfSaleCountrySelectionScreenState
    extends State<PointOfSaleCountrySelectionScreen> {
  List<CountryModel> countries = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCountries();
  }

  Future<void> fetchCountries() async {
    try {
      final response = await RestApiService.get(ApiPaths.fetchCountries);
      final jsonData = json.decode(response.body);
      log(
        '---------------------------------------------------------------------------------------------------------------------------',
      );

      log(jsonData.toString());
      log(
        '---------------------------------------------------------------------------------------------------------------------------',
      );

      if (jsonData['success'] == true && jsonData['data'] is List) {
        final List raw = jsonData['data'];
        countries = raw.map((e) => CountryModel.fromJson(e)).toList();
        log(
          '---------------------------------------------------------------------------------------------------------------------------',
        );
        log(countries.toString());
        log(
          '---------------------------------------------------------------------------------------------------------------------------',
        );
      }
    } catch (e) {
      log('Error fetching countries: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  String _getFlag(CountryModel country) {
    final lower = country.title.toLowerCase();
    final arLower = country.arTitle.toLowerCase();

    if (lower.contains('jordan') || arLower.contains('الأردن')) return '🇯🇴';
    if (lower.contains('iraq') || arLower.contains('العراق')) return '🇮🇶';
    return '🏳️';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "chooseCountry"),
      body: Padding(
        padding: UIConstants.mobileBodyPadding,
        child:
        isLoading
            ? const Center(child: LoadingAnimation())
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            20.verticalSpace,
            Expanded(
              child: GridView.builder(
                itemCount: countries.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 15.h,
                  crossAxisSpacing: 15.w,
                  childAspectRatio: 0.9,
                ),
                itemBuilder: (context, index) {
                  final country = countries[index];
                  final flag = _getFlag(country);

                  return InkWell(
                    borderRadius: BorderRadius.circular(16.r),
                    onTap: () {
                      Get.to(
                            () => const PointsOfSale(),
                        arguments: {"id": country.id.toString()},
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      color: Get.theme.colorScheme.primary,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              flag,
                              style: TextStyle(fontSize: 80.sp),
                            ),
                            10.verticalSpace,
                            CustomTextWidget(
                              text: country.arTitle,
                              fontSize: 16.sp,
                              color: Colors.white,
                              textAlign: TextAlign.center,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
