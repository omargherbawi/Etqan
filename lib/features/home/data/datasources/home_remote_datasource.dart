import 'dart:convert';
import 'dart:developer';

import '../../../../config/api_paths.dart';
import '../../../../core/model/pagination.dart';
import '../../../../core/services/api_response_handler.dart';
import '../../../../core/services/api_services.dart';
import '../../../../core/utils/console_log_functions.dart';
import '../../../auth/data/models/province_model.dart';
import '../../../auth/data/models/user_model.dart';
import '../models/point_of_sale_model.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/core.dart';
import '../../../../core/network/network_mixin.dart';

class HomeRemoteDatasource with NetworkMixin {
  Future<List<Either<Failure, dynamic>>> refreshAllData() async {
    if (!await isConnected) {
      return [left(NetworkFailure(noInternetConnection))];
    }
    return Future.wait([
      // fetchTrendyQuizzes(),
    ]);
  }

  Future<Either<Failure, PaginatedResponse<PointOfSaleModel>>>
  fetchPointsOfSale(String? provinceId, int page) async {
    try {
      final Map<String, String?> queryParams = {
        "province_id": provinceId,
        "page": page.toString(),
      };

      final res = await RestApiService.get(ApiPaths.pointsOfSale, queryParams);
      final body = jsonDecode(res.body);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final usersJson = body['data'] as List;
        final pos = usersJson.map((e) => PointOfSaleModel.fromJson(e)).toList();

        final pagination = Pagination.fromJson(body['pagination']);

        return Right(
          PaginatedResponse<PointOfSaleModel>(
            data: pos,
            pagination: pagination,
          ),
        );
      }

      return Left(ServerFailure("Failed to load POS"));
    } catch (e, st) {
      log(e.toString(), stackTrace: st);
      return left(UnknownFailure(e.toString()));
    }
  }

  Future<void> fetchCountries() async {
    final res = await RestApiService.get(ApiPaths.fetchCountries);

    logJSON(object: res.body);
  }

  Future<Either<Failure, List<ProvinceModel>>> fetchProvincesByCountryId(
    String id,
  ) async {
    try {
      final res = await RestApiService.get(
        ApiPaths.fetchProvincesByCountryId(id),
      );

      return ApiResponseHandler.handleListResponse(
        res,
        (json) => ProvinceModel.fromJson(json),
        jsonPath: "data",
      );
    } catch (e, st) {
      log(e.toString(), stackTrace: st);
      return left(UnknownFailure(e.toString()));
    }
  }

  Future<Map<String, dynamic>> fetchFiles({
    required int page,
    Map<String, String>? filters,
  }) async {
    final queryParams = <String, String>{
      'page': page.toString(),
      if (filters != null) ...filters,
    };

    logInfo("Fetching files with params: $queryParams");
    final response = await RestApiService.get(
      ApiPaths.fetchFilesCourse,
      queryParams,
    );

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      return jsonBody;
    } else {
      throw Exception('Failed to load files');
    }
  }

  Future<List<dynamic>> fetchPrograms() async {
    final resp = await RestApiService.get("development/programs");
    if (resp.statusCode == 200) return jsonDecode(resp.body) as List<dynamic>;
    throw Exception("Failed to load programs");
  }

  Future<List<dynamic>> fetchFileTypes() async {
    final resp = await RestApiService.get("development/types");
    if (resp.statusCode == 200) {
      final body = jsonDecode(resp.body);
      return body['data'] as List<dynamic>;
    }
    throw Exception("Failed to load file types");
  }

  Future<List<dynamic>> fetchSubCategories(int parentId) async {
    try {
      final resp = await RestApiService.get(
        "development/sub-categories/$parentId",
      );
      if (resp.statusCode == 200) return jsonDecode(resp.body);
      throw Exception("Failed to load sub-categories");
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Either<Failure, PaginatedResponse<UserModel>>> fetchAllInstructors(
    int page, {
    int? subCategoryId,
  }) async {
    try {
      final Map<String, String> queryParams = {
        'page': page.toString(),
        if (subCategoryId != null) 'class_id': subCategoryId.toString(),
      };

      final res = await RestApiService.get(
        ApiPaths.fetchInstructors,
        queryParams,
      );
      final body = jsonDecode(res.body);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final usersJson = body['data']['users'] as List;
        final users = usersJson.map((e) => UserModel.fromJson(e)).toList();

        final pagination = Pagination.fromJson(body['pagination']);

        return Right(
          PaginatedResponse<UserModel>(data: users, pagination: pagination),
        );
      }

      return Left(ServerFailure("Failed to load instructors"));
    } catch (e) {
      logError(e.toString());
      return left(UnknownFailure(e.toString()));
    }
  }
}
