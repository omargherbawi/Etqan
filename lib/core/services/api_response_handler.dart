import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:http/http.dart';
import '../errors/failure.dart';
import '../utils/console_log_functions.dart';
import '../utils/force_update_state.dart';
import '../../features/shared/presentation/controllers/current_user_controller.dart';
import '../widgets/force_update_dialog.dart';
import 'analytics.service.dart';

class ApiResponseHandler {
  static final userController = Get.find<CurrentUserController>();

  static dynamic _getNestedJsonValue(Map<String, dynamic> json, String path) {
    return path.split('.').fold<dynamic>(json, (prev, key) {
      if (prev == null || prev is! Map<String, dynamic>) {
        return null;
      }
      return prev[key];
    });
  }

  // Handle a response for a list of items
  static Either<Failure, List<T>> handleListResponse<T>(
    Response response,
    T Function(Map<String, dynamic>) fromJson, {
    String? jsonPath,
  }) {
    final int statusCode = response.statusCode;
    final String responseBody = response.body;

    final dynamic resBody = jsonDecode(responseBody);
    if (statusCode == 403) {
      userController.logUserOut(withRemote: false);
      return Left(AuthFailure('serverLogout'.tr));
    } else if (statusCode >= 200 && statusCode < 300) {
      final data =
          jsonPath != null && resBody is Map<String, dynamic>
              ? _getNestedJsonValue(resBody, jsonPath) // Handle nested paths
              : resBody;

      if (data is List) {
        final list =
            data.map((item) => fromJson(item as Map<String, dynamic>)).toList();
        return Right(list);
      } else {
        Get.find<AnalyticsService>().logEvent(
          functionName: 'handleListResponse',
          className: 'api_response_handler',
          parameters: {"error": 'Expected a list but received something else'},
        );
        return Left(
          ParsingFailure('Expected a list but received something else'),
        );
      }
    } else if (statusCode == 426) {
      final errorMessage =
          resBody is Map<String, dynamic>
              ? resBody['message'] ?? 'App update required'
              : 'App update required';

      // Set force update flag and show non-dismissible dialog
      ForceUpdateState.setForceUpdateActive(true);
      Get.dialog(
        ForceUpdateDialog(message: errorMessage),
        barrierDismissible: false,
        barrierColor: Colors.black.withValues(alpha: 0.5),
      );
      Get.find<AnalyticsService>().logEvent(
        functionName: 'handleListResponse',
        className: 'api_response_handler',
        parameters: {"error": errorMessage},
      );
      return Left(UpgradeRequiredFailure(''));
    } else if (statusCode >= 400 && statusCode < 500) {
      final errorMessage =
          resBody is Map<String, dynamic>
              ? resBody['message'] ??
                  resBody['error'] ??
                  'Validation error occurred'
              : 'Validation error occurred';
      Get.find<AnalyticsService>().logEvent(
        functionName: 'handleListResponse',
        className: 'api_response_handler',
        parameters: {"error": errorMessage},
      );
      return Left(ValidationFailure(errorMessage));
    } else if (statusCode >= 500 && statusCode < 600) {
      final errorMessage =
          resBody is Map<String, dynamic>
              ? resBody['message'] ??
                  resBody['error'] ??
                  'Server error occurred'
              : 'Server error occurred';
      Get.find<AnalyticsService>().logEvent(
        functionName: 'handleListResponse',
        className: 'api_response_handler',
        parameters: {"error": errorMessage},
      );
      return Left(ServerFailure(errorMessage));
    } else {
      final errorMessage =
          resBody is Map<String, dynamic>
              ? resBody['message'] ??
                  resBody['error'] ??
                  'An unknown error occurred'
              : 'An unknown error occurred';
      Get.find<AnalyticsService>().logEvent(
        functionName: 'handleListResponse',
        className: 'api_response_handler',
        parameters: {"error": errorMessage},
      );
      return Left(UnknownFailure(errorMessage));
    }
  }

  static Either<Failure, T> handleSingleResponse<T>(
    Response response,
    T Function(Map<String, dynamic>)? fromJson, {
    String? jsonPath,
  }) {
    final int statusCode = response.statusCode;
    final String responseBody = response.body;

    final dynamic resBody = jsonDecode(responseBody);
    logInfo("$T $jsonPath Response Body: $resBody");
    if (statusCode == 403) {
      userController.logUserOut(withRemote: false);
      return Left(AuthFailure('serverLogout'.tr));
    } else if (statusCode >= 200 && statusCode < 300) {
      final data =
          jsonPath != null && resBody is Map<String, dynamic>
              ? _getNestedJsonValue(resBody, jsonPath) // Handle nested paths
              : resBody;

      if (T == Null || data == null) {
        return Right(null as dynamic); // Treat `void` responses as success
      }

      if (data is Map<String, dynamic> && fromJson != null) {
        final item = fromJson(data);
        return Right(item);
      } else {
        Get.find<AnalyticsService>().logEvent(
          functionName: 'handleListResponse',
          className: 'api_response_handler',
          parameters: {
            "error":
                'Expected a Map<String, dynamic> but received something else or null',
          },
        );
        return Left(
          ParsingFailure(
            'Expected a Map<String, dynamic> but received something else or null',
          ),
        );
      }
    } else if (statusCode == 426) {
      final errorMessage =
          resBody is Map<String, dynamic>
              ? resBody['message'] ?? 'App update required'
              : 'App update required';

      // Set force update flag and show non-dismissible dialog
      ForceUpdateState.setForceUpdateActive(true);
      Get.dialog(
        ForceUpdateDialog(message: errorMessage),
        barrierDismissible: false,
        barrierColor: Colors.black.withValues(alpha: 0.5),
      );

      return Left(UpgradeRequiredFailure(errorMessage));
    } else if (statusCode >= 400 && statusCode < 500) {
      final errorMessage =
          resBody is Map<String, dynamic>
              ? resBody['message'] ??
                  resBody['error'] ??
                  'Validation error occurred'
              : 'Validation error occurred';

      if (resBody['message'].contains("Unauthenticated")) {
        userController.logUserOut(withRemote: false);
        return Left(AuthFailure('serverLogout'.tr));
      }
      Get.find<AnalyticsService>().logEvent(
        functionName: 'handleListResponse',
        className: 'api_response_handler',
        parameters: {"error": errorMessage},
      );
      return Left(ValidationFailure(errorMessage));
    } else if (statusCode >= 500 && statusCode < 600) {
      final errorMessage =
          resBody is Map<String, dynamic>
              ? resBody['message'] ??
                  resBody['error'] ??
                  'Server error occurred'
              : 'Server error occurred';
      Get.find<AnalyticsService>().logEvent(
        functionName: 'handleListResponse',
        className: 'api_response_handler',
        parameters: {"error": errorMessage},
      );
      return Left(ServerFailure(errorMessage));
    } else {
      final errorMessage =
          resBody is Map<String, dynamic>
              ? resBody['message'] ??
                  resBody['error'] ??
                  'An unknown error occurred'
              : 'An unknown error occurred';
      Get.find<AnalyticsService>().logEvent(
        functionName: 'handleListResponse',
        className: 'api_response_handler',
        parameters: {"error": errorMessage},
      );
      return Left(UnknownFailure(errorMessage));
    }
  }

  // Handle a response for a map of lists
  static Either<Failure, Map<String, List<T>>> handleMapResponse<T>(
    Response response,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final int statusCode = response.statusCode;
    final String responseBody = response.body;

    final dynamic resBody = jsonDecode(responseBody);
    if (statusCode == 403) {
      userController.logUserOut(withRemote: false);
      return Left(AuthFailure('serverLogout'.tr));
    } else if (statusCode >= 200 && statusCode < 300) {
      if (resBody is Map<String, dynamic>) {
        // Convert the Map<String, dynamic> into Map<String, List<T>>
        final map = resBody.map<String, List<T>>((key, value) {
          if (value is List) {
            final list =
                value
                    .map((item) => fromJson(item as Map<String, dynamic>))
                    .toList();
            return MapEntry(key, list);
          } else {
            return MapEntry(key, []);
          }
        });

        return Right(map);
      } else {
        Get.find<AnalyticsService>().logEvent(
          functionName: 'handleListResponse',
          className: 'api_response_handler',
          parameters: {"error": "Expected a map but received something else"},
        );
        return Left(
          ParsingFailure('Expected a map but received something else'),
        );
      }
    } else if (statusCode == 426) {
      final errorMessage =
          resBody is Map<String, dynamic>
              ? resBody['message'] ?? 'App update required'
              : 'App update required';

      // Set force update flag and show non-dismissible dialog
      ForceUpdateState.setForceUpdateActive(true);
      Get.dialog(
        ForceUpdateDialog(message: errorMessage),
        barrierDismissible: false,
        barrierColor: Colors.black.withValues(alpha: 0.5),
      );

      return Left(UpgradeRequiredFailure(errorMessage));
    } else if (statusCode >= 400 && statusCode < 500) {
      final errorMessage =
          resBody is Map<String, dynamic>
              ? resBody['message'] ??
                  resBody['error'] ??
                  'Validation error occurred'
              : 'Validation error occurred';
      Get.find<AnalyticsService>().logEvent(
        functionName: 'handleListResponse',
        className: 'api_response_handler',
        parameters: {"error": errorMessage},
      );
      return Left(ValidationFailure(errorMessage));
    } else if (statusCode >= 500 && statusCode < 600) {
      final errorMessage =
          resBody is Map<String, dynamic>
              ? resBody['message'] ??
                  resBody['error'] ??
                  'Server error occurred'
              : 'Server error occurred';
      Get.find<AnalyticsService>().logEvent(
        functionName: 'handleListResponse',
        className: 'api_response_handler',
        parameters: {"error": errorMessage},
      );
      return Left(ServerFailure(errorMessage));
    } else {
      final errorMessage =
          resBody is Map<String, dynamic>
              ? resBody['message'] ??
                  resBody['error'] ??
                  'An unknown error occurred'
              : 'An unknown error occurred';
      Get.find<AnalyticsService>().logEvent(
        functionName: 'handleListResponse',
        className: 'api_response_handler',
        parameters: {"error": errorMessage},
      );
      return Left(UnknownFailure(errorMessage));
    }
  }
}
