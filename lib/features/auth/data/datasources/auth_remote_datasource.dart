import 'dart:convert';
import 'dart:developer';

import 'package:flutter_udid/flutter_udid.dart';
import 'package:tedreeb_edu_app/core/services/notification_service.dart';
import 'package:tedreeb_edu_app/features/account/data/models/profile_model.dart';

import '../../../../core/function/get_device_name.dart';
import '../../../../core/services/analytics.service.dart';
import '../../presentation/controllers/auth_signup_controller.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import '../../../../config/api_paths.dart';
import '../../../../config/json_constants.dart';
import '../../../../core/core.dart';
import '../../../../core/network/network_mixin.dart';
import '../../../../core/services/api_response_handler.dart';
import '../../../../core/services/api_services.dart';
import '../../../../core/services/hive_services.dart';
import '../../../../core/utils/console_log_functions.dart';

import '../../../../main.dart';
import '../models/register_config_model.dart';

class AuthRemoteDatasource with NetworkMixin {
  final oneSignalService = OneSignalNotificationService();

  final _hiveService = Get.find<HiveServices>();

  Future<Either<Failure, ProfileModel>> login(
    String identifier,
    String password,
    String countryCode,
  ) async {
    if (!await isConnected) {
      return left(NetworkFailure(noInternetConnection));
    }
    try {
      final oneSignalToken = await oneSignalService.getOneSignalUserId();
      final String udid = await FlutterUdid.consistentUdid;
      final String deviceName = await getDeviceName();
      final res = await RestApiService.post(ApiPaths.login, {
        UserModelConstants.username: identifier,
        UserModelConstants.password: password,
        UserModelConstants.countryCode: countryCode,
        UserModelConstants.notificationID: oneSignalToken,
        UserModelConstants.oneSignalNotificationID: oneSignalToken,
        UserModelConstants.udid: udid,
        "device_name": deviceName,
      });
      logError("res: $res");
      if (jsonDecode(res.body)['success'] == false) {
        Get.find<AnalyticsService>().logEvent(
          functionName: 'login',
          className: 'auth_remote_datasource',
          parameters: {
            "error": jsonDecode(res.body)['message'],
            "identifier": identifier,
            "countryCode": countryCode,
            "password": password,
          },
        );
        return left(AuthFailure(jsonDecode(res.body)['message']));
      }
      final token = jsonDecode(res.body)['data']?['token'] as String?;
      _hiveService.setToken(token);

      logger.d("USER DATA: ${res.body}");
      final profileResponse = await RestApiService.get(ApiPaths.profile, {
        UserModelConstants.getUserToken: oneSignalToken,
        'udid': udid,
        'device_name': deviceName,
      });
      return ApiResponseHandler.handleSingleResponse<ProfileModel>(
        profileResponse,
        (json) => ProfileModel.fromJson(json),
        jsonPath: "data",
      );
    } catch (e, st) {
      Get.find<AnalyticsService>().logEvent(
        functionName: 'login',
        className: 'auth_remote_datasource',
        parameters: {
          "error": e.toString(),

          "identifier": identifier,
          "countryCode": countryCode,
          "password": password,
        },
        stack: st,
      );
      return left(AuthFailure(e.toString()));
    }
  }

  Future<Either<Failure, Map<String, dynamic>?>> signupWithPassword(
    String name,
    String countryCode,
    String mobile,
    String password,
    String? accountType,
    // int governorateId,
    int programId,
    // int classId,
  ) async {
    try {
      if (!await isConnected) {
        return left(NetworkFailure(noInternetConnection));
      }

      Map body = {
        "full_name": name,
        UserModelConstants.countryCode: countryCode,
        UserModelConstants.mobile: mobile,
        UserModelConstants.password: password,
        UserModelConstants.passwordConfirmation: password,
        // UserModelConstants.governorateId: governorateId,
        UserModelConstants.programId: programId,
        // UserModelConstants.classId: classId,
        "account_type": accountType,
      };

      logJSON(message: "BODY:", object: body);
      final res = await RestApiService.post(ApiPaths.signup, body);
      logError(res.statusCode);
      logJSON(object: res.body);
      final data = jsonDecode(res.body);

      const validStatuses = [200, 201];

      if (!validStatuses.contains(res.statusCode)) {
        throw data?['message'] ?? "error";
      }

      var jsonResponse = jsonDecode(res.body);
      if (jsonResponse['success'] ||
          jsonResponse['status'] == 'go_step_2' ||
          jsonResponse['status'] == 'go_step_3') {
        return Right({
          'user_id': jsonResponse['data']['user_id'],
          'step': jsonResponse['status'],
        });
      }

      return left(UnknownFailure());
    } catch (e, stackTrace) {
      log("ERROR", stackTrace: stackTrace);
      return left(AuthFailure(e.toString()));
    }
  }

  Future<void> sendOtp(String identifier, String? countryCode) async {
    try {
      final body =
          countryCode == null
              ? {"email": identifier}
              : {"mobile": identifier, "country_code": countryCode};

      logJSON(object: body, message: "SEND OTP BODY");
      await RestApiService.post("development/send-otp", body);
    } catch (e) {
      Get.find<AnalyticsService>().logEvent(
        functionName: 'sendOtp',
        className: 'auth_remote_datasource',
        parameters: {
          "error": e.toString(),
          'identifier': identifier,
          'countryCode': countryCode ?? "no country code",
        },
      );
    }
  }

  Future<Either<Failure, bool>> verifyCode({
    required String code,
    required String identifier,
    String? countryCode,
  }) async {
    try {
      String url = ApiPaths.validateUser;

      final body =
          countryCode == null
              ? {"code": code, "email": identifier, "country_code": countryCode}
              : {
                "code": code,
                "mobile": identifier,
                "country_code": countryCode,
              };
      logJSON(object: body, message: "VERIFY CODE BODY");

      final res = await RestApiService.post(
        url,
        body,
      ).timeout(const Duration(seconds: 120));

      Map jsonResponse = jsonDecode(res.body);
      if (jsonResponse.containsKey("success")) {
        if (jsonResponse['success']) {
          return const Right(true);
        } else {
          Get.find<AnalyticsService>().logEvent(
            functionName: 'verifyCode',
            className: 'auth_remote_datasource',
            parameters: {
              "error": jsonResponse['message'],
              "code": code,
              "identifier": identifier,
              "country_code": countryCode ?? "no country code",
            },
          );
          return left(AuthFailure(jsonResponse['message'].toString()));
        }
      } else {
        Get.find<AnalyticsService>().logEvent(
          functionName: 'verifyCode',
          className: 'auth_remote_datasource',
          parameters: {
            "error": jsonResponse['message'].toString(),
            "code": code,
            "identifier": identifier,
            "country_code": countryCode ?? "no country code",
          },
        );
        return left(AuthFailure(jsonResponse['message'].toString()));
      }
    } catch (e, stackTrace) {
      Get.find<AnalyticsService>().logEvent(
        functionName: 'verifyCode',
        className: 'auth_remote_datasource',
        parameters: {
          "error": e.toString(),
          "code": code,
          "identifier": identifier,
          "country_code": countryCode ?? "no country code",
        },
        stack: stackTrace,
      );
      return left(AuthFailure(e.toString()));
    }
  }

  Future<void> resetMobilePassword({
    required String identifier,
    String? countryCode,
    required String password,
    required String otp,
  }) async {
    try {
      final body = {
        "mobile": identifier,
        "country_code": countryCode,
        "password": password,
        "password_confirmation": password,
        "code": otp,
      };

      logJSON(object: body, message: "RESET PASSWORD BODY");
      final res = await RestApiService.post(
        "development/reset-password-mobile",
        body,
      ).timeout(const Duration(seconds: 120));

      if (res.statusCode != 200 && res.statusCode != 201) {
        Get.find<AnalyticsService>().logEvent(
          functionName: 'resetMobilePassword',
          className: 'auth_remote_datasource',
          parameters: {
            "error": jsonDecode(res.body)['message'].toString(),
            "mobile": identifier,
            "country_code": countryCode ?? "no country code",
            "password": password,
            "password_confirmation": password,
            "code": otp,
          },
        );
        throw jsonDecode(res.body)['message'];
      }

      return;
    } catch (e) {
      ToastUtils.showError(e.toString());
      Get.find<AnalyticsService>().logEvent(
        functionName: 'resetMobilePassword',
        className: 'auth_remote_datasource',
        parameters: {
          "error": e.toString(),
          "mobile": identifier,
          "country_code": countryCode ?? "no country code",
          "password": password,
          "password_confirmation": password,
          "code": otp,
        },
      );
    }
  }

  Future<Either<Failure, RegisterConfigModel>> getRegisterConfig(
    String role,
  ) async {
    try {
      String url = ApiPaths.getRegisterConfigByRole(role);

      final res = await RestApiService.get(url);

      return ApiResponseHandler.handleSingleResponse<RegisterConfigModel>(
        res,
        (json) => RegisterConfigModel.fromJson(json),
        jsonPath: "data",
      );
    } catch (e, st) {
      Get.find<AnalyticsService>().logEvent(
        functionName: 'resetMobilePassword',
        className: 'auth_remote_datasource',
        parameters: {"error": e.toString(), "role": role},
        stack: st,
      );
      return left(AuthFailure(e.toString()));
    }
    //   var jsonResponse = jsonDecode(res.body);
    //
    //   if (res.statusCode == 200) {
    //     return RegisterConfigModel.fromJson(jsonResponse['data']);
    //   } else {
    //     return null;
    //   }
    // } catch (e) {
    //   return null;
    // }
  }

  Future<Either<AuthFailure, SignupConfigResponse>>
  fetchSignupConfigData() async {
    try {
      final res = await RestApiService.get(ApiPaths.preSignupData);

      if (res.statusCode == 200) {
        final Map<String, dynamic> jsonMap = jsonDecode(res.body);
        final dto = SignupConfigResponse.fromJson(jsonMap);
        return right(dto);
      } else {
        Get.find<AnalyticsService>().logEvent(
          functionName: 'fetchSignupConfigData',
          className: 'auth_remote_datasource',
          parameters: {"error": "Server error: ${res.statusCode}"},
        );
        return left(AuthFailure('Server error: ${res.statusCode}'));
      }
    } catch (e, st) {
      Get.find<AnalyticsService>().logEvent(
        functionName: 'fetchSignupConfigData',
        className: 'auth_remote_datasource',
        parameters: {"error": "$e"},
        stack: st,
      );
      return left(AuthFailure(e.toString()));
    }
  }
}
