//create data sourced like AuthRemoteDatasource

import 'package:fpdart/fpdart.dart';
import '../../../../config/api_paths.dart';
import '../../../../core/core.dart';
import '../../../../core/network/network_mixin.dart';
import '../../../../core/services/api_response_handler.dart';
import '../../../../core/services/api_services.dart';

import '../models/category_model.dart';

class CategoryRemoteDataSource with NetworkMixin {
  Future<Either<Failure, List<CategoryModel>>> getCategories() async {
    try {
      final res = await RestApiService.get(ApiPaths.fetchCategories);

      return ApiResponseHandler.handleListResponse<CategoryModel>(
        res,
        (json) => CategoryModel.fromJson(json),
        jsonPath: "data.categories",
      );
    } catch (e) {
      return left(UnknownFailure(e.toString()));
    }
  }

  // static Future<List<CategoryModel>> _categories() async {
  //   List<CategoryModel> data = [];
  //   try {
  //     String url = '${Constants.baseUrl}categories';
  //
  //     Response res = await httpGet(
  //       url,
  //     );
  //
  //     log("categories:$url");
  //     log(res.body);
  //     var jsonResponse = jsonDecode(res.body);
  //     if (jsonResponse['success']) {
  //       jsonResponse['data']['categories'].forEach((json) {
  //         data.add(CategoryModel.fromJson(json));
  //       });
  //       return data;
  //     } else {
  //       ErrorHandler().showError(ErrorEnum.error, jsonResponse);
  //       return data;
  //     }
  //   } catch (e) {
  //     return data;
  //   }
  // }
}
