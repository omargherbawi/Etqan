import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../config/api_paths.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/services/analytics.service.dart';
import '../../../../core/services/api_response_handler.dart';
import '../../../../core/services/api_services.dart';
import '../../../../main.dart';
import '../models/faq_questions_model.dart';

class AccountRemoteDatasource {
  Future<Either<Failure, void>> updatePassword(
    String oldPassword,
    String newPassword,
  ) async {
    try {
      final res = await RestApiService.put(ApiPaths.updatePassword, {
        "current_password": oldPassword,
        "new_password": newPassword,
      });

      return ApiResponseHandler.handleSingleResponse<Null>(res, null);
    } catch (e, stackTrace) {
      logger.e("ERROR", stackTrace: stackTrace, error: e);
      Get.find<AnalyticsService>().logEvent(
        functionName: 'updatePassword',
        className: 'account_remote_datasource',
        parameters: {
          "error": "$e",
          "oldPassword": oldPassword,
          "newPassword": newPassword,
        },
        stack: stackTrace,
      );
      return left(AuthFailure(e.toString()));
    }
  }

  Future<Either<Failure, void>> updateAccount(
    String fullName,
    bool newsletter,
  ) async {
    try {
      final res = await RestApiService.put(ApiPaths.profile, {
        "full_name": fullName,
        "newsletter": newsletter,
      });

      return ApiResponseHandler.handleSingleResponse<Null>(res, null);
    } catch (e, stackTrace) {
      Get.find<AnalyticsService>().logEvent(
        functionName: 'updateAccount',
        className: 'account_remote_datasource',
        parameters: {
          "error": "$e",
          "fullName": fullName,
          "newsletter": newsletter ? "true" : "false",
        },
        stack: stackTrace,
      );
      logger.e("ERROR", stackTrace: stackTrace, error: e);
      return left(AuthFailure(e.toString()));
    }
  }

  Future<Either<Failure, void>> updateUserImage(
    File? profile,
    File? indentity,
    File? certificate,
  ) async {
    try {
      Map<String, String> fields = {};
      List<http.MultipartFile> files = [];

      if (profile != null) {
        files.add(
          await http.MultipartFile.fromPath(
            "profile_image",
            profile.path,
            filename: profile.path.split('/').last,
          ),
        );
      }
      if (indentity != null) {
        files.add(
          await http.MultipartFile.fromPath(
            "identity_scan",
            indentity.path,
            filename: indentity.path.split('/').last,
          ),
        );
      }
      if (certificate != null) {
        files.add(
          await http.MultipartFile.fromPath(
            "certificate",
            certificate.path,
            filename: certificate.path.split('/').last,
          ),
        );
      }

      http.Response res = await RestApiService.multipartListPost(
        ApiPaths.updateImage,
        fields: fields,
        files: files,
      );

      return ApiResponseHandler.handleSingleResponse<Null>(res, null);
    } catch (e, stackTrace) {
      Get.find<AnalyticsService>().logEvent(
        functionName: 'updateUserImage',
        className: 'account_remote_datasource',
        parameters: {"error": "$e"},
        stack: stackTrace,
      );
      logger.e("ERROR", stackTrace: stackTrace, error: e);
      return left(AuthFailure(e.toString()));
    }
  }

  // static Future<bool> updateInfo(
  //     String email,
  //     String name,
  //     String phone,
  //     String timezone,
  //     bool newsletter,
  //     String iban,
  //     String accountType,
  //     String accountId,
  //     String address,
  //     int? countryId,
  //     int? provinceId,
  //     int? cityId,
  //     int? districtId) async {
  //   try {
  //     String url = '${Constants.baseUrl}panel/profile-setting';
  //
  //     Response res = await httpPutWithToken(url, {
  //       "email": email,
  //       "full_name": name,
  //       "mobile": phone,
  //       // "language": "string",
  //       if (timezone.isNotEmpty) ...{
  //         "timezone": timezone,
  //       },
  //       "newsletter": newsletter ? 1 : 0,
  //       "account_type": accountType,
  //       "iban": iban,
  //       "account_id": accountId,
  //       // "bio": "nullable|string|min:3|max:48",
  //       // "level_of_training": "array|in:beginner,middle,expert",
  //       // "meeting_type": "in:in_person,all,online",
  //       // "gender": "nullable|in:man,woman",
  //       // "location": "array|size:2",
  //       // "location.latitude": "required_with:location",
  //       // "location.longitude": "required_with:location",
  //       if (address.isNotEmpty) ...{
  //         "address": address,
  //       },
  //
  //       if (countryId != null) ...{
  //         "country_id": countryId,
  //       },
  //
  //       if (provinceId != null) ...{
  //         "province_id": provinceId,
  //       },
  //
  //       if (cityId != null) ...{
  //         "city_id": cityId,
  //       },
  //
  //       if (districtId != null) ...{
  //         "district_id": districtId,
  //       },
  //     });
  //
  //     var jsonResponse = jsonDecode(res.body);
  //
  //     if (jsonResponse['success']) {
  //       await getProfile();
  //       ErrorHandler().showError(ErrorEnum.success, jsonResponse, readMessage: true);
  //       return true;
  //     } else {
  //       ErrorHandler().showError(ErrorEnum.error, jsonResponse);
  //       return false;
  //     }
  //   } catch (e) {
  //     return false;
  //   }
  // }

  Future<Either<Failure, List<FaqQuestion>>> getFaqQuestions() async {
    try {
      // return List.from(categories);

      return Right(List.from(faqQuestion));
    } catch (e) {
      return left(AuthFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<FaqTypes>>> getFaqTypes() async {
    try {
      // return List.from(categories);

      return Right(List.from(faqTypes));
    } catch (e) {
      return left(AuthFailure(e.toString()));
    }
  }
}
