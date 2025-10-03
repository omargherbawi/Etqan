import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/datasources/blog_remote_datasource.dart';
import '../../data/models/basic_model.dart';
import '../../data/models/blog_model.dart';

class BlogsController extends GetxController {
  final blogData = <BlogModel>[].obs;
  final RxBool isLoading = false.obs;
  final categories = <BasicModel>[].obs;
  final selectedCategory = Rxn<BasicModel>();
  final ScrollController scrollController = ScrollController();

  @override
  void onReady() {
    super.onReady();
    // getCategories();
    // getData();

    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // Check if the scroll controller is attached and has a position
    if (scrollController.hasClients && scrollController.position.hasContentDimensions) {
      final maxScroll = scrollController.position.maxScrollExtent;
      final currentScroll = scrollController.position.pixels;
      if (maxScroll - currentScroll < 200 && !isLoading.value) {
        getData();
      }
    }
  }

  /// Fetch blog posts with pagination.
  Future<void> getData({bool refresh = false}) async {
    if (refresh) blogData.clear();

    isLoading(true);
    try {
      // Offset is current length of blogData
      final newData = await BlogRemoteDatasource.getBlog(
        blogData.length,
        category: selectedCategory.value?.id,
      );
      blogData.assignAll(newData);
    } catch (e) {
      // Get.find<AnalyticsService>().logEvent(
      //   functionName: 'getData',
      //   className: 'blog_controller',
      //   parameters: {"error": e.toString()},
      // );
    } finally {
      isLoading(false);
    }
  }

  /// Fetch categories and assign them.
  Future<void> getCategories() async {
    try {
      final data = await BlogRemoteDatasource.categories();
      categories.assignAll(data);
    } catch (e) {
      // Optionally handle the error
    }
  }

  void updateCategory(BasicModel newCategory) {
    if (newCategory.id != selectedCategory.value?.id) {
      selectedCategory(newCategory);
      blogData.clear();
      getData();
    }
  }

  @override
  void onClose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.onClose();
  }
}
