import 'dart:developer';

import 'package:etqan_edu_app/features/auth/data/models/governorate_model.dart';
import 'package:etqan_edu_app/features/auth/data/models/major_model.dart';
import 'package:etqan_edu_app/features/auth/data/models/province_model.dart';
import 'package:etqan_edu_app/features/auth/data/models/subject_model.dart';
import 'package:country_picker/country_picker.dart' as country_picker;
import 'package:get/get.dart';
import 'package:etqan_edu_app/config/notification.dart';
import 'package:etqan_edu_app/core/routes/route_paths.dart';
// import 'package:etqan_edu_app/core/services/hive_services.dart';
import 'package:etqan_edu_app/core/utils/toast_utils.dart';
import 'package:etqan_edu_app/features/auth/data/datasources/auth_remote_datasource.dart';
// import 'package:etqan_edu_app/features/shared/presentation/controllers/current_user_controller.dart';

class AuthSignupController extends GetxController {
  final isLoading = false.obs;
  final isSignupLoading = false.obs;
  final agreeWithTerms = false.obs;
  final profileImage = RxnString(null);
  final _authRemoteDatasource = Get.find<AuthRemoteDatasource>();

  final governorateList = <GovernorateModel>[].obs;
  final programList = <ProgramModel>[].obs;
  final classList = <ClassModel>[].obs;
  final selectedGovernorate = Rxn<GovernorateModel>();
  final selectedProgram = Rxn<ProgramModel>();
  final selectedClass = Rxn<ClassModel>();

  final selectedCountry =
      country_picker.Country(
        phoneCode: '962',
        countryCode: 'JO',
        e164Sc: 0,
        geographic: true,
        level: 1,
        name: 'Jordan',
        example: 'Jordan',
        displayName: 'Jordan (الأردن)',
        displayNameNoCountryCode: 'Jordan (الأردن)',
        e164Key: '962-JO-0',
      ).obs;

  void updateLoginLoading(bool val) {
    isLoading.value = val;
  }

  void updateSignupLoading(bool val) {
    isSignupLoading.value = val;
  }

  void updateSelectedCountry(country_picker.Country country) {
    selectedCountry.value = country;
  }

  void updateProfileImage(String? newUrl) {
    profileImage.value = newUrl;
  }

  @override
  onReady() {
    fetchSignupConfigData();
    super.onReady();
  }

  void fetchSignupConfigData() async {
    updateSignupLoading(true);

    final result = await _authRemoteDatasource.fetchSignupConfigData();

    result.fold(
      (failure) {
        ToastUtils.showError(failure.message);
      },
      (response) {
        // response is SignupConfigResponse
        final data = response.data;

        // Map provinces to governorates
        governorateList.assignAll(
          data.provinces.map(
            (p) => GovernorateModel(
              id: p.id ?? 0,
              arName: p.arTitle,
              enName: p.title,
            ),
          ),
        );

        // Programs are root categories (parentId == null)
        programList.assignAll(
          data.programsClasses
              .where((c) => c.parentId == null)
              .map(
                (c) => ProgramModel(
                  id: c.id,
                  arName: c.getName('ar'),
                  enName: c.getName('en'),
                ),
              )
              .toList(),
        );

        // Classes flatten all subcategories with parentId
        classList.assignAll(
          data.programsClasses
              .expand((c) => c.subCategories)
              .map(
                (sub) => ClassModel(
                  id: sub.id,
                  arName: sub.getName('ar'),
                  enName: sub.getName('en'),
                  majorId: sub.parentId!,
                ),
              )
              .toList(),
        );
      },
    );

    updateSignupLoading(false);
  }

  Future<void> signupWithPhone({
    required String fullName,
    required String dialCode,
    required String phone,
    required String password,
    // required String registerMethod,
    required String accountType,
    // required List<Fields>? fields,
  }) async {
    if (selectedProgram.value?.id == null) {
      ToastUtils.showError("pleaseFillAllFields");
      return;
    }

    updateSignupLoading(true);

    final response = await _authRemoteDatasource.signupWithPassword(
      fullName,
      dialCode,
      phone,
      password,
      accountType,
      selectedProgram.value!.id,
    );
    response.fold(
      (l) {
        ToastUtils.showError(l.message);
        log(l.message);
      },
      (r) {
        Map<String, dynamic>? res = r;
        if (res != null) {
          if (res['step'] == 'stored' || res['step'] == 'go_step_2') {
            NotificationService().notificationInitializer();
            ToastUtils.showSuccess("accountCreatedSuccessfully");
            Get.offAllNamed(RoutePaths.login);
          } else if (res['step'] == 'go_step_3') {
            NotificationService().notificationInitializer();
            Get.toNamed(RoutePaths.navScreen);
            // nextRoute(MainPage.pageName, arguments: res['user_id']);
          }
        }
      },
    );
    updateSignupLoading(false);
  }

  void updateSelectedGovernorate(GovernorateModel? gov) {
    selectedGovernorate.value = gov;
  }

  void updateSelectedMajor(ProgramModel? major) {
    selectedProgram.value = major;
    selectedClass.value = null;
  }

  void updateSelectedSubject(ClassModel? subject) {
    selectedClass.value = subject;
  }

  List<ClassModel> get filteredClasses {
    if (selectedProgram.value == null) return [];
    return classList
        .where((c) => c.majorId == selectedProgram.value!.id)
        .toList();
  }
}

// GENERATED MODELS FOR SIGNUP CONFIG RESPONSE

// translation_model.dart
class TranslationModel {
  final int id;
  final int categoryId;
  final String locale;
  final String title;

  TranslationModel({
    required this.id,
    required this.categoryId,
    required this.locale,
    required this.title,
  });

  factory TranslationModel.fromJson(Map<String, dynamic> json) =>
      TranslationModel(
        id: json['id'] as int,
        categoryId: json['category_id'] as int,
        locale: json['locale'] as String,
        title: json['title'] as String,
      );
}

// category_model.dart (for programs & classes)
class CategoryModel {
  final int id;
  final String slug;
  final int? parentId;
  final String icon;
  final int order;
  final String color;
  final int? regionId;
  final String? defaultTitle;
  final List<CategoryModel> subCategories;
  final List<TranslationModel> translations;

  CategoryModel({
    required this.id,
    required this.slug,
    required this.parentId,
    required this.icon,
    required this.order,
    required this.color,

    this.regionId,
    required this.defaultTitle,
    required this.subCategories,
    required this.translations,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    final subs =
        (json['sub_categories'] as List<dynamic>?)
            ?.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    final trans =
        (json['translations'] as List<dynamic>?)
            ?.map((e) => TranslationModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    return CategoryModel(
      id: json['id'] as int,
      slug: json['slug'] as String,
      parentId: json['parent_id'] as int?,
      icon: json['icon'] as String? ?? '',
      order: json['order'] as int,
      color: json['color'] as String? ?? '',
      regionId: json['region_id'] ?? 0,
      defaultTitle: json['title'] as String?,
      subCategories: subs,
      translations: trans,
    );
  }

  /// Get localized name by locale code (e.g. 'en' or 'ar')
  String getName(String locale) {
    final match = translations.firstWhere(
      (t) => t.locale == locale,
      orElse:
          () =>
              translations.isNotEmpty
                  ? translations.first
                  : TranslationModel(
                    id: 0,
                    categoryId: id,
                    locale: locale,
                    title: defaultTitle ?? '',
                  ),
    );
    return match.title;
  }
}

// province_model.dart (for governorates)

// signup_config_response.dart (top-level response)
class SignupConfigResponse {
  final bool success;
  final String status;
  final String message;
  final SignupConfigData data;

  SignupConfigResponse({
    required this.success,
    required this.status,
    required this.message,
    required this.data,
  });

  factory SignupConfigResponse.fromJson(Map<String, dynamic> json) =>
      SignupConfigResponse(
        success: json['success'] as bool,
        status: json['status'] as String,
        message: json['message'] as String,
        data: SignupConfigData.fromJson(json['data'] as Map<String, dynamic>),
      );
}

class SignupConfigData {
  final List<CategoryModel> programsClasses;
  final List<ProvinceModel> provinces;

  SignupConfigData({required this.programsClasses, required this.provinces});

  factory SignupConfigData.fromJson(Map<String, dynamic> json) =>
      SignupConfigData(
        programsClasses:
            (json['programs_classes'] as List<dynamic>)
                .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
                .toList(),
        provinces:
            (json['provinces'] as List<dynamic>)
                .map((e) => ProvinceModel.fromJson(e as Map<String, dynamic>))
                .toList(),
      );
}
