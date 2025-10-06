import 'dart:convert';

import 'package:flutter_udid/flutter_udid.dart';
import 'package:etqan_edu_app/config/json_constants.dart';
import 'package:etqan_edu_app/core/services/notification_service.dart';
import 'package:etqan_edu_app/features/account/data/models/profile_model.dart';
import 'package:etqan_edu_app/features/shared/data/models/notification_model.dart';

import '../../../../config/api_paths.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/strings.dart';
import '../../../../core/function/get_device_name.dart';
import '../../../../core/network/network_mixin.dart';
import '../../../../core/services/api_response_handler.dart';
import '../../../../core/services/api_services.dart';
import '../../../../core/utils/console_log_functions.dart';
import '../../../../core/utils/toast_utils.dart';
import '../../../categories/data/models/filter_model.dart';
import '../../../courses/data/models/course_model.dart';
import '../../../courses/data/models/packages/datum.dart';
import '../models/meetings_time_model.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../main.dart';

class SharedRemoteDatasources with NetworkMixin {
  final oneSignalService = OneSignalNotificationService();

  Future<Either<Failure, ProfileModel>> getUserData() async {
    final oneSignalToken = await oneSignalService.getOneSignalUserId();

    final String udid = await FlutterUdid.consistentUdid;
    final String deviceName = await getDeviceName();
    final res = await RestApiService.get(ApiPaths.profile, {
      UserModelConstants.getUserToken: oneSignalToken,
      'udid': udid,
      'device_name': deviceName,
    });

    try {
      if (!await isConnected) {
        return left(NetworkFailure(noInternetConnection));
      }
      return ApiResponseHandler.handleSingleResponse<ProfileModel>(
        res,
        (json) => ProfileModel.fromJson(json),
        jsonPath: "data",
      );
    } catch (e, st) {
      logger.e(e.toString(), stackTrace: st);

      return left(UnknownFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<Datum>>> fetchPackages() async {
    final res = await RestApiService.get(ApiPaths.pakages);
    try {
      if (!await isConnected) {
        return left(NetworkFailure(noInternetConnection));
      }
      return ApiResponseHandler.handleListResponse<Datum>(
        res,
        (json) => Datum.fromJson(json),
        jsonPath: "data",
      );
    } catch (e, st) {
      logger.e(e.toString(), stackTrace: st);
      return left(UnknownFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<CourseModel>>> fetchClasses({
    int offset = 0,
    bool upcoming = false,
    bool free = false,
    bool discount = false,
    bool downloadable = false,
    String? sort,
    String? type,
    String? cat,
    bool reward = false,
    bool bundle = false,
    List<int>? filterOption,
  }) async {
    try {
      if (!await isConnected) {
        return left(NetworkFailure(noInternetConnection));
      }

      // Define query parameters dynamically
      final Map<String, String> queryParams = {
        'offset': offset.toString(),
        'limit': '10',
        if (upcoming) 'upcoming': '1',
        if (free) 'free': '1',
        if (discount) 'discount': '1',
        if (downloadable) 'downloadable': '1',
        if (reward) 'reward': '1',
        if (sort != null) 'sort': sort,
        if (cat != null) 'cat': cat,
      };

      // Handle multiple `filter_option` values
      if (filterOption != null && filterOption.isNotEmpty) {
        queryParams.addAll(
          filterOption.asMap().map(
            (index, value) =>
                MapEntry('filter_option[$index]', value.toString()),
          ),
        );
      }

      // Define the endpoint path
      final path = bundle ? ApiPaths.bundles : ApiPaths.courses;

      // Make the API call
      final res = await RestApiService.get(path, queryParams);
      logger.e(res.body);
      return ApiResponseHandler.handleListResponse<CourseModel>(
        res,
        (json) => CourseModel.fromJson(json),
        jsonPath: bundle ? "data.bundles" : "data",
      );
    } catch (e, st) {
      logger.e(e.toString(), stackTrace: st);
      return left(UnknownFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<CourseModel>>> fetchFeaturedCourses({
    String? cat,
  }) async {
    try {
      if (!await isConnected) {
        return left(NetworkFailure(noInternetConnection));
      }

      String url = ApiPaths.featuredCourses;

      if (cat != null) url += '?cat=$cat';

      final res = await RestApiService.get(url);

      return ApiResponseHandler.handleListResponse<CourseModel>(
        res,
        (json) => CourseModel.fromJson(json),
        jsonPath: "data",
      );
    } catch (e, st) {
      logger.e(e.toString(), stackTrace: st);
      return left(UnknownFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<FilterModel>>> fetchFilters(int id) async {
    List<FilterModel> data = [];
    try {
      String url = 'development/categories/$id/webinars';

      final res = await RestApiService.get(url);

      var jsonResponse = jsonDecode(res.body);
      if (jsonResponse['success']) {
        jsonResponse['data']['filters'].forEach((json) {
          data.add(FilterModel.fromJson(json));
        });
        return right(data);
      } else {
        throw jsonResponse;
      }
    } catch (e, st) {
      logger.e(e.toString(), stackTrace: st);

      return left(UnknownFailure(e.toString()));
    }
  }

  Future<String?> toggleSavedCourse({
    required bool isBundle,
    required String itemId,
  }) async {
    try {
      if (!await isConnected) {
        ToastUtils.showError(noInternetConnection);
        return noInternetConnection;
      }
      final res = await RestApiService.post(
        "development/panel/favorites/toggle2",
        {"item": isBundle ? "bundle" : "webinar", "id": itemId},
      );

      final data = jsonDecode(res.body)['status'];

      logger.d("DATA: $data");
      logger.d("RES: ${res.body}");

      if (res.statusCode == 200 || res.statusCode == 201) {
        logger.e("IN 200/201");
        return data;
      }
    } catch (e, st) {
      logger.e(e.toString(), stackTrace: st);
      return e.toString();
    }
    return null;
  }

  Future<Either<Failure, List<CourseModel>>> getSavedCourses() async {
    try {
      if (!await isConnected) {
        return left(NetworkFailure(noInternetConnection));
      }

      final res = await RestApiService.get(ApiPaths.fetchSavedCourses);

      if (res.statusCode == 200) {
        final responseBody = jsonDecode(res.body);
        final favorites = responseBody['data']['favorites'] as List;

        // Map the 'webinar' objects to a list of CourseModel
        final webinars =
            favorites
                .map((favorite) => CourseModel.fromJson(favorite['webinar']))
                .toList();

        return right(webinars);
      } else {
        return left(ServerFailure('Failed to fetch courses'));
      }
    } catch (e, st) {
      logger.e(e.toString(), stackTrace: st);
      return left(UnknownFailure(e.toString()));
    }
  }

  Future<void> logout() async {
    await RestApiService.post(ApiPaths.logout);
  }

  Future<Either<Failure, List<NotificationModel>>> fetchNotifications() async {
    try {
      if (!await isConnected) {
        return left(NetworkFailure(noInternetConnection));
      }

      final res = await RestApiService.get("development/panel/notifications");

      return ApiResponseHandler.handleListResponse<NotificationModel>(
        res,
        (json) => NotificationModel.fromJson(json),
        jsonPath: "data.notifications",
      );
    } catch (e) {
      return left(UnknownFailure(e.toString()));
    }
  }

  Future<bool> readNotification(int id) async {
    try {
      if (!await isConnected) {
        return false;
      }

      final res = await RestApiService.post(
        "development/panel/notifications/$id/seen",
      );
      logInfo("jsonResponse: ${res.body}");
      var jsonResponse = jsonDecode(res.body);

      if (jsonResponse['success']) {
        return true;
      } else {
        ToastUtils.showError(jsonResponse);
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<ProfileModel?> getUserProfile(int id) async {
    try {
      String url = 'development/users/$id/profile';

      final res = await RestApiService.get(url);

      logger.e("RES BODY: ${res.body}");

      var jsonRes = jsonDecode(res.body);

      if (jsonRes['success']) {
        return ProfileModel.fromJson(
          jsonRes['data']['user'],
          cashback: jsonRes['data']['cashbackRules'],
        );
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> sendMessage(
    int userId,
    String subject,
    String email,
    String description,
  ) async {
    try {
      String url = 'development/users/$userId/send-message';

      final res = await RestApiService.post(url, {
        "title": subject,
        "email": email,
        "description": description,
      });

      var jsonRes = jsonDecode(res.body);

      if (jsonRes['success']) {
        ToastUtils.showSuccess(jsonRes['message'].toString());
        return true;
      } else {
        ToastUtils.showError(jsonRes);
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> sendFirebaseToken(String token) async {
    try {
      String url = ApiPaths.sendFirebaseToken;
      final body = {"token": token};

      logJSON(object: body, message: "sendFirebaseToken body");

      final res = await RestApiService.put(url, body);

      var jsonRes = jsonDecode(res.body);

      if (jsonRes['success']) {
        logSuccess("Firebase token sent successfully");
        // ToastUtils.showSuccess(jsonRes['message'].toString());
        return true;
      } else {
        logger.e("Failed to send Firebase token");
        ToastUtils.showError(jsonRes);
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> follow(int id, bool state) async {
    try {
      String url = 'development/panel/users/$id/follow';

      final res = await RestApiService.post(url, {'status': state ? '1' : '0'});

      var jsonRes = jsonDecode(res.body);

      if (jsonRes['success']) {
        return true;
      } else {
        ToastUtils.showError(jsonRes);
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<MeetingTimesModel?> getMeetings(int id, int date) async {
    try {
      String url = 'development/users/$id/meetings?date=$date';

      final res = await RestApiService.get(url);

      var jsonRes = jsonDecode(res.body);

      if (jsonRes['success']) {
        return MeetingTimesModel.fromJson(jsonRes['data']);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> reserveMeeting(
    int timeId,
    String date,
    String meetingType,
    int studentCount,
    String description,
  ) async {
    try {
      String url = 'development/meetings/reserve';

      final res = await RestApiService.post(url, {
        "time_id": timeId,
        "date": date,
        "meeting_type": meetingType,
        "student_count": studentCount,
        "description": description,
      });

      var jsonRes = jsonDecode(res.body);

      if (jsonRes['success']) {
        ToastUtils.showSuccess("successAddToCartDesc");
        return true;
      } else {
        ToastUtils.showError(jsonRes);

        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> isReviewing() async {
    try {
      final res = await RestApiService.get(ApiPaths.fetchIsReviewing);

      final data = jsonDecode(res.body);
      // Handle 1/0 or true/false
      final value = data?['data']['is_reviewing'];

      if (value is bool) return value;
      if (value is int) return value == 1;
      if (value is String) return value == '1' || value.toLowerCase() == 'true';
      return false;
    } catch (e) {
      return false;
    }
  }
}
