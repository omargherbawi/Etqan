import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../config/app_colors.dart';
import '../../../../core/enums/text_style_enum.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_form_field.dart';
import '../../../../core/widgets/custom_text_widget.dart';
import '../../data/models/countries_model.dart';
import '../../../../config/countries_list.dart';
import '../controllers/edit_account_controller.dart';

class CountryScreen extends StatefulWidget {
  const CountryScreen({super.key});

  @override
  State<CountryScreen> createState() => _CountryScreenState();
}

class _CountryScreenState extends State<CountryScreen> {
  List<Country> filteredCountries = countriesList;
  TextEditingController searchController = TextEditingController();
  Country? selectedCountry;

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    String searchText = searchController.text.trim().toLowerCase();
    setState(() {
      filteredCountries =
          countriesList.where((country) {
            return country.name!.toLowerCase().contains(searchText) ||
                country.name_ar!.toLowerCase().contains(searchText);
          }).toList();
    });
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "countryList"),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: CustomFormField(
              controller: searchController,
              hintText: 'searchByCountryName',
              prefix: const Icon(Icons.search, color: SharedColors.grayColor),
            ),
          ),
          Expanded(
            child:
                filteredCountries.isEmpty
                    ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 60,
                          color: SharedColors.grayColor,
                        ),
                        SizedBox(height: 10),
                        CustomTextWidget(text: "noMatchingCountriesFound"),
                      ],
                    )
                    : ListView.builder(
                      itemCount: filteredCountries.length,
                      itemBuilder: (context, index) {
                        final country = filteredCountries[index];
                        final isSelected = selectedCountry == country;
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          elevation: 2,
                          child: ListTile(
                            splashColor: Colors.transparent,
                            leading: CustomTextWidget(
                              text: country.flag ?? "",
                              fontSize: 38.sp,
                            ),
                            title:
                                Get.locale?.languageCode == "ar"
                                    ? CustomTextWidget(
                                      text: country.name_ar ?? "",
                                      textThemeStyle:
                                          TextThemeStyleEnum.displayLarge,
                                    )
                                    : CustomTextWidget(
                                      text: country.name ?? "",
                                      textThemeStyle:
                                          TextThemeStyleEnum.displayLarge,
                                    ),
                            subtitle: CustomTextWidget(
                              text: country.dial_code ?? "",
                            ),
                            trailing:
                                isSelected
                                    ? Icon(
                                      CupertinoIcons.check_mark_circled,
                                      color: Theme.of(context).primaryColor,
                                    )
                                    : null,
                            onTap: () {
                              if (selectedCountry?.iso2 == country.iso2) {
                                setState(() {
                                  selectedCountry = null;
                                });
                              } else {
                                setState(() {
                                  selectedCountry = country;
                                });
                              }
                            },
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
      extendBody: true,
      bottomNavigationBar:
          selectedCountry != null
              ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
                child: CustomButton(
                  onPressed: () {
                    if (selectedCountry != null &&
                        selectedCountry?.dial_code != null) {
                      Get.find<EditAccountController>().updateTempCountry(
                        selectedCountry!.iso2!,
                      );
                      Get.back();
                    }
                  },
                  child: CustomTextWidget(
                    text: "confirmSelection",
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              )
              : null,
    );
  }
}
