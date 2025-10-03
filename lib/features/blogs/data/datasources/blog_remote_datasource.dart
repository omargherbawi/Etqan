import 'dart:convert';

import 'package:get/get.dart';
import '../../../../core/core.dart';
import '../../../../core/services/analytics.service.dart';
import '../../../../core/services/api_services.dart';
import '../models/basic_model.dart';
import '../models/blog_model.dart';

class BlogRemoteDatasource {
  static Future<List<BlogModel>> getBlog(int offset, {int? category}) async {
    List<BlogModel> data = [];
    try {
      String url = 'development/blogs?offset=$offset&limit=10';

      if (category != null) {
        url += '&cat=$category';
      }

      final res = await RestApiService.get(url);

      var jsonResponse = jsonDecode(res.body);
      if (jsonResponse['success']) {
        jsonResponse['data'].forEach((json) {
          data.add(BlogModel.fromJson(json));
        });
        return data;
      } else {
        ToastUtils.showSuccess(jsonResponse);
        return data;
      }
    } catch (e, st) {
      Get.find<AnalyticsService>().logEvent(
        functionName: 'getBlog',
        className: 'blog_remote_datasource',
        parameters: {
          "error": e.toString(),
          "offset": offset.toString(),
          "category": category.toString(),
        },
        stack: st,
      );
      return data;
    }
  }

  static Future<bool> saveComments(
    int postId,
    int? commentId,
    String itemName,
    String comment,
  ) async {
    try {
      String url = 'development/panel/comments';

      final res = await RestApiService.post(url, {
        "item_id": postId,
        "item_name": itemName,
        "comment": comment,
        "reply_id": commentId,
      });

      var jsonResponse = jsonDecode(res.body);

      if (jsonResponse['success']) {
        ToastUtils.showSuccess(jsonResponse['message']?.toString() ?? "");
        return true;
      } else {
        ToastUtils.showSuccess(jsonResponse);
        return false;
      }
    } catch (e, st) {
      Get.find<AnalyticsService>().logEvent(
        functionName: 'saveComments',
        className: 'blog_remote_datasource',
        parameters: {
          "error": e.toString(),
          "item_id": postId.toString(),
          "item_name": itemName,
          "comment": comment,
          "reply_id": commentId.toString(),
        },
        stack: st,
      );
      return false;
    }
  }

  static Future<bool> reportComments(int commentId, String message) async {
    try {
      String url = 'development/panel/comments/$commentId/report';

      final res = await RestApiService.post(url, {"message": message});

      var jsonResponse = jsonDecode(res.body);

      if (jsonResponse['success']) {
        ToastUtils.showSuccess(jsonResponse['message']?.toString() ?? "");
        return true;
      } else {
        ToastUtils.showError(jsonResponse);
        return false;
      }
    } catch (e, st) {
      Get.find<AnalyticsService>().logEvent(
        functionName: 'reportComments',
        className: 'blog_remote_datasource',
        parameters: {
          "error": e.toString(),
          "comment_id": commentId.toString(),
          "message": message,
        },
        stack: st,
      );
      return false;
    }
  }

  static Future<List<BasicModel>> categories() async {
    List<BasicModel> data = [];
    try {
      String url = 'development/blogs/categories';

      final res = await RestApiService.get(url);

      var jsonResponse = jsonDecode(res.body);
      if (jsonResponse['success']) {
        jsonResponse['data'].forEach((json) {
          data.add(BasicModel.fromJson(json));
        });
        return data;
      } else {
        ToastUtils.showError(jsonResponse);
        return data;
      }
    } catch (e, st) {
      Get.find<AnalyticsService>().logEvent(
        functionName: 'categories',
        className: 'blog_remote_datasource',
        parameters: {"error": e.toString()},
        stack: st,
      );
      return data;
    }
  }
}
