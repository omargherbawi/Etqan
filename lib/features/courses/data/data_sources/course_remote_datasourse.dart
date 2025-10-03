import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:tedreeb_edu_app/core/services/analytics.service.dart';
import 'package:tedreeb_edu_app/core/utils/console_log_functions.dart';

import '../../../../config/api_paths.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/strings.dart';
import '../../../../core/model/pagination.dart';
import '../../../../core/network/network_mixin.dart';
import '../../../../core/services/api_response_handler.dart';
import '../../../../core/services/api_services.dart';
import '../../../../main.dart';
import '../../../shared/presentation/controllers/current_user_controller.dart';
import '../models/course_model.dart';
import '../models/purchase_course_model.dart';
import '../models/quiz.dart';
import '../models/quiz_detail_model.dart';
import '../models/quiz_result_model.dart';
import '../models/quiz_results_list_model.dart';
import '../models/post_model.dart';
import '../models/forum_answer_model.dart';
import '../models/content_model.dart';
import '../models/single_course_model.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

import '../models/course_model.dart' as cm;

class CourseRemoteDataSource with NetworkMixin {
  Future<Either<Failure, SingleCourseModel>> getSingleCourseData(
    int id,
    bool isBundle, {
    bool isPrivate = false,
  }) async {
    try {
      if (!await isConnected) {
        return left(NetworkFailure(noInternetConnection));
      }
      log("isPrivate: $isPrivate, isBundle: $isBundle");
      String url =
          '${isPrivate
              ? 'development/panel/webinars'
              : isBundle
              ? 'development/bundles'
              : 'v2/development/courses'}/$id';

      final res = await RestApiService.get(url);

      log(jsonEncode(res.body));

      return ApiResponseHandler.handleSingleResponse(
        res,
        (json) => SingleCourseModel.fromJson(json),
        jsonPath: isBundle ? "data.bundle" : "data",
      );
    } catch (e, st) {
      log("getSingleCourseData Error $e", stackTrace: st);
      return left(UnknownFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<ContentModel>>> fetchCourseContent(
    String courseId,
  ) async {
    try {
      if (!await isConnected) {
        return left(NetworkFailure(noInternetConnection));
      }

      final res = await RestApiService.get(
        "development/courses/$courseId/content",
      );

      logger.i('Raw Data: ${jsonDecode(res.body)}');

      return ApiResponseHandler.handleListResponse(
        res,
        (json) => ContentModel.fromJson(json),
        jsonPath: "data",
      );
    } catch (e) {
      return left(UnknownFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<Quiz>>> fetchCourseQuizzes(int courseId) async {
    try {
      if (!await isConnected) {
        return left(NetworkFailure(noInternetConnection));
      }
      final res = await RestApiService.get(ApiPaths.fetchcoursequiz(courseId));
      debugPrint('Quiz Data: \\${res.body}');
      return ApiResponseHandler.handleListResponse(
        res,
        (json) => Quiz.fromJson(json),
        jsonPath: "data.quizzes",
      );
    } catch (e) {
      return left(UnknownFailure(e.toString()));
    }
  }

  Future<Either<Failure, QuizDetailData>> startQuiz(int quizId) async {
    try {
      if (!await isConnected) {
        return left(NetworkFailure(noInternetConnection));
      }
      final res = await RestApiService.get(ApiPaths.startQuiz(quizId), {});

      return ApiResponseHandler.handleSingleResponse(
        res,
        (json) => QuizDetailResponse.fromJson(json).data,
      );
    } catch (e) {
      return left(UnknownFailure(e.toString()));
    }
  }

  Future<Either<Failure, QuizResultResponse>> submitQuizResult(
    int quizId,
    int quizResultId,
    List<Map<String, dynamic>> answers,
  ) async {
    try {
      if (!await isConnected) {
        return left(NetworkFailure(noInternetConnection));
      }

      final res = await RestApiService.post(ApiPaths.storeQuizResult(quizId), {
        "quiz_result_id": quizResultId,
        "answer_sheet": answers,
      });

      return ApiResponseHandler.handleSingleResponse(
        res,
        (json) => QuizResultResponse.fromJson(json),
      );
    } catch (e) {
      return left(UnknownFailure(e.toString()));
    }
  }

  Future<List<Either<Failure, dynamic>>> refreshAllData() async {
    if (!await isConnected) {
      return [left(NetworkFailure(noInternetConnection))];
    }
    return Future.wait([]);
  }

  Future<Either<Failure, PaginatedResponse<PurchaseCourseModel>>>
  fetchPurchasedCourses(int page) async {
    try {
      if (!await isConnected) {
        return left(NetworkFailure(noInternetConnection));
      }
      final res = await RestApiService.get(
        "${ApiPaths.webinarsPurchases}?page=$page",
        {'page': page.toString()},
      );

      final body = jsonDecode(res.body);
      if (res.statusCode == 403) {
        Get.find<CurrentUserController>().logUserOut();
        return Left(AuthFailure('serverLogout'.tr));
      }

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final coursesJson = body['data'] as List;
        final course =
            coursesJson.map((e) => PurchaseCourseModel.fromJson(e)).toList();

        final pagination = Pagination.fromJson(body['pagination']);

        return Right(
          PaginatedResponse<PurchaseCourseModel>(
            data: course,
            pagination: pagination,
          ),
        );
      }

      return Left(ServerFailure("Failed to load webinars Purchases"));
    } catch (e, st) {
      log(e.toString(), name: 'fetchPurchasedCourses', stackTrace: st);
      return left(UnknownFailure(e.toString()));
    }
  }

  Future<Either<Failure, PaginatedResponse<CourseModel>>> fetchFreeCourses({
    int page = 1,
    int offset = 0,
  }) async {
    try {
      if (!await isConnected) {
        return left(NetworkFailure(noInternetConnection));
      }
      final res = await RestApiService.get(
        "${ApiPaths.fetchCourses}?page=$page",
        {'page': page.toString(), 'free': '1', 'offset': offset.toString()},
      );

      final body = jsonDecode(res.body);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final coursesJson = body['data'] as List;
        final course = coursesJson.map((e) => CourseModel.fromJson(e)).toList();

        final pagination = Pagination.fromJson(body['pagination']);

        return Right(
          PaginatedResponse<CourseModel>(data: course, pagination: pagination),
        );
      }

      return Left(ServerFailure("Failed to load Courses"));
    } catch (e, st) {
      log(e.toString(), name: 'fetchPurchasedCourses', stackTrace: st);
      return left(UnknownFailure(e.toString()));
    }
  }

  Future<Either<Failure, PaginatedResponse<CourseModel>>> fetchPaidCourses({
    int page = 1,
    int offset = 0,
  }) async {
    try {
      if (!await isConnected) {
        return left(NetworkFailure(noInternetConnection));
      }
      final res = await RestApiService.get(
        "${ApiPaths.fetchCourses}?page=$page",
        {'page': page.toString(), 'free': '0', 'offset': offset.toString()},
      );

      final body = jsonDecode(res.body);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final coursesJson = body['data'] as List;
        final course = coursesJson.map((e) => CourseModel.fromJson(e)).toList();

        final pagination = Pagination.fromJson(body['pagination']);

        return Right(
          PaginatedResponse<CourseModel>(data: course, pagination: pagination),
        );
      }

      return Left(ServerFailure("Failed to load Courses"));
    } catch (e, st) {
      log(e.toString(), name: 'fetchPaidCourses', stackTrace: st);
      return left(UnknownFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<PurchaseCourseModel>>>
  fetchPopularCourses() async {
    try {
      if (!await isConnected) {
        log("here");
        return left(NetworkFailure(noInternetConnection));
      }
      final res = await RestApiService.get(
        "development/panel/webinars/purchases",
      );

      log(res.body);

      return ApiResponseHandler.handleListResponse<PurchaseCourseModel>(
        res,
        (json) => PurchaseCourseModel.fromJson(json),
        jsonPath: "data.purchases",
      );
    } catch (e, st) {
      log(e.toString(), name: 'fetchPurchasedCourses', stackTrace: st);
      return left(UnknownFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<PostModel>>> fetchCourseForum(
    int courseId,
  ) async {
    try {
      if (!await isConnected) {
        return left(NetworkFailure(noInternetConnection));
      }

      final res = await RestApiService.get(ApiPaths.fetchCourseForum(courseId));

      log('Forum Raw Response: ${res.body}');
      log('Forum Status Code: ${res.statusCode}');

      final responseData = jsonDecode(res.body);
      log('Forum Parsed Response: $responseData');

      if (responseData is Map<String, dynamic> &&
          responseData['data'] != null) {
        final forumsData = responseData['data']['forums'];
        log('Forums Data: $forumsData');
        log('Forums Data Type: ${forumsData.runtimeType}');
        log(
          'Forums Data Length: ${forumsData is List ? forumsData.length : 'Not a list'}',
        );
      }

      return ApiResponseHandler.handleListResponse<PostModel>(res, (json) {
        log('Parsing PostModel from: $json');
        final postModel = PostModel.fromJson(json);
        log('Parsed PostModel: ${postModel.toJson()}');
        return postModel;
      }, jsonPath: "data.forums");
    } catch (e, st) {
      log("fetchCourseForum Error $e", stackTrace: st);
      return left(UnknownFailure(e.toString()));
    }
  }

  Future<Either<Failure, PostModel>> addPost(
    String title,
    String description,
    File? file,
    int id,
  ) async {
    if (!await isConnected) {
      return left(NetworkFailure(noInternetConnection));
    }

    try {
      final res =
          file != null
              ? await RestApiService.multipartPost(
                ApiPaths.addForum(id),
                fields: {"title": title, "description": description},
                fileKey: "attachment",
                file: file,
              )
              : await RestApiService.post(ApiPaths.addForum(id), {
                "title": title,
                "description": description,
              });

      logError("res: $res");
      logger.d("USER DATA: ${res.body}");

      return ApiResponseHandler.handleSingleResponse<PostModel>(
        res,
        (json) => PostModel.fromJson(json),
        jsonPath: "data",
      );
    } catch (e, stack) {
      logError("Exception in addPost: $e\n$stack");
      return left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, PostModel>> editPost(
    String title,
    String description,
    int id,
  ) async {
    if (!await isConnected) {
      return left(NetworkFailure(noInternetConnection));
    }

    try {
      final res = await RestApiService.post(ApiPaths.updateForum(id), {
        "title": title,
        "description": description,
      });

      logError("res: $res");
      logger.d("USER DATA: ${res.body}");

      return ApiResponseHandler.handleSingleResponse<PostModel>(
        res,
        (json) => PostModel.fromJson(json),
        jsonPath: "data",
      );
    } catch (e, stack) {
      logError("Exception in addPost: $e\n$stack");
      return left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, ForumAnswerModel>> addAnswer(
    String description,
    int postId,
  ) async {
    if (!await isConnected) {
      return left(NetworkFailure(noInternetConnection));
    }

    try {
      final res = await RestApiService.post(ApiPaths.addAnswer(postId), {
        "description": description,
      });

      logError("res: $res");
      logger.d("USER DATA: ${res.body}");

      return ApiResponseHandler.handleSingleResponse<ForumAnswerModel>(
        res,
        (json) => ForumAnswerModel.fromJson(json),
        jsonPath: "data",
      );
    } catch (e, stack) {
      logError("Exception in addAnswer: $e\n$stack");
      return left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, ForumAnswerModel>> editAnswer(
    String description,
    int id,
  ) async {
    if (!await isConnected) {
      return left(NetworkFailure(noInternetConnection));
    }

    try {
      final res = await RestApiService.post(ApiPaths.editAnswer(id), {
        "description": description,
      });

      logError("res: $res");
      logger.d("USER DATA: ${res.body}");

      return ApiResponseHandler.handleSingleResponse<ForumAnswerModel>(
        res,
        (json) => ForumAnswerModel.fromJson(json),
        jsonPath: "data",
      );
    } catch (e, stack) {
      logError("Exception in addPost: $e\n$stack");
      return left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<ForumAnswerModel>>> fetchForumAnswers(
    int id,
  ) async {
    try {
      if (!await isConnected) {
        return left(NetworkFailure(noInternetConnection));
      }

      final res = await RestApiService.get(ApiPaths.fetchAnswer(id));

      final responseData = jsonDecode(res.body);

      if (responseData is Map<String, dynamic> &&
          responseData['data'] != null) {
        final answersData = responseData['data']['answers'];
        log(
          'Answers Data Length: ${answersData is List ? answersData.length : 'Not a list'}',
        );
      }

      return ApiResponseHandler.handleListResponse<ForumAnswerModel>(res, (
        json,
      ) {
        log('Parsing ForumAnswerModel from: $json');
        final answerModel = ForumAnswerModel.fromJson(json);
        log('Parsed ForumAnswerModel: ${answerModel.toJson()}');
        return answerModel;
      }, jsonPath: "data.answers");
    } catch (e, st) {
      log("fetchForumAnswers Error $e", stackTrace: st);
      return left(UnknownFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<cm.CourseModel>>> getUserCourses(
    int userId,
  ) async {
    try {
      return Right(
        List.from([
          // dummyCourse,
          // dummyCourse,
          // dummyCourse,
          // dummyCourse,
          // dummyCourse,
        ]),
      );
    } catch (e) {
      return left(AuthFailure(e.toString()));
    }
  }

  Future<Either<Failure, QuizResultsListResponse>> allresult(int id) async {
    try {
      if (!await isConnected) {
        return left(NetworkFailure(noInternetConnection));
      }

      final res = await RestApiService.get(ApiPaths.quizResult(id));

      log('Quiz Results Response: ${res.body}');

      return ApiResponseHandler.handleSingleResponse(
        res,
        (json) => QuizResultsListResponse.fromJson(json),
      );
    } catch (e, st) {
      log("allresult Error $e", stackTrace: st);
      Get.find<AnalyticsService>().logEvent(
        functionName: 'allresult',
        className: 'CourseRemoteDataSource',
        parameters: {"error": e.toString()},
      );
      return left(UnknownFailure(e.toString()));
    }
  }
}

class CourseTypes {
  final int id;
  final String value;

  CourseTypes({required this.id, required this.value});
}

// final dummyCourse = cm.CourseModel(
//   thumbnail: "https://example.com/thumbnail.jpg",
//   // image: "https://example.com/image.jpg",
//   auth: true,
//   can: Can(pin: true),
//   // Replace with proper Can constructor values
//   canViewError: null,
//   id: 101,
//   status: "active",
//   label: "Best Course",
//   title: "Introduction to Flutter",
//   description: "Learn the basics of Flutter for building cross-platform apps.",
//   type: "online",
//   link: "https://example.com/course/flutter",
//   accessDays: 365,
//   salesCountNumber: 120,
//   liveWebinarStatus: "upcoming",
//   authHasBought: false,
//   sales: cm.Sales(amount: 1500, count: 1),
//   // Replace with proper Sales constructor values
//   isFavorite: true,
//   expired: false,
//   expireOn: 0,
//   priceString: "150",
//   bestTicketString: "120",
//   price: 180000,
//   tax: 10,
//   lessons: 36,
//   taxWithDiscount: 8,
//   bestTicketPrice: 120,
//   discountPercent: 20,
//   coursePageTax: 5,
//   priceWithDiscount: 120,
//   discountAmount: 30,
//   activeSpecialOffer: cm.ActiveSpecialOffer(
//     id: 1,
//     creatorId: 101,
//     webinarId: 201,
//     bundleId: null,
//     subscribeId: null,
//     registrationPackageId: 301,
//     name: "New Year Discount",
//     percent: 20,
//     status: "active",
//     createdAt: 1672531200,
//     // Unix timestamp
//     fromDate: 1672444800,
//     toDate: 1675123200,
//   ),
//   duration: 25,
//   // in seconds
//   teacher: UserModel(
//     id: 1,
//     fullName: "John Doe",
//     roleName: "Instructor",
//     bio: "Experienced Flutter Developer",
//     offline: "false",
//     email: "johndoe@example.com",
//     offlineMessage: "Currently offline",
//     verified: "true",
//     rate: "4.5",
//     avatar: "https://example.com/avatar.jpg",
//     meetingStatus: "available",
//     address: "123 Main St, Cityville",
//   ),
//   studentsCount: 200,
//   rate: "4.8",
//   rateType: cm.RateType(contentQuality: 1, instructorSkills: 1),
//   // Replace with proper RateType constructor values
//   createdAt: 1672444800,
//   startDate: 1672531200,
//   purchasedAt: null,
//   reviewsCount: 50,
//   points: 100,
//   progress: 18,
//   progressPercent: 0,
//   category: "1",
//
//   capacity: 500,
//   reservedMeeting: "",
//   reservedMeetingUserTimeZone: "UTC+0",
//   isPrivate: 0,
//   translations: [
//     Translations(locale: "en", title: "Introduction to Flutter"),
//     // Replace with proper Translations constructor values
//   ],
//   badges: [
//     cm.CustomBadges(
//       id: 1,
//     ), // Replace with proper CustomBadges constructor values
//   ],
// );
