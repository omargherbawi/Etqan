import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../../config/asset_paths.dart';
import '../../../../core/core.dart';
import '../../data/models/blog_model.dart';
import '../controllers/blogs_controller.dart';
import 'blog_details_screen.dart';
import '../../shimmer/blog_item_shimmer.dart';

class BlogScreen extends GetView<BlogsController> {
  final bool? canPop;
  const BlogScreen(this.canPop, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "blog",
        // leading: canPop == true ? null : const SizedBox.shrink(),
        // actions: [
        //   GestureDetector(
        //     onTap: () async {
        //       BasicModel? cat = await BlogWidget.showCategoriesDialog(
        //         controller.selectedCategory.value,
        //         controller.categories,
        //       );
        //       if (cat != null) {
        //         controller.updateCategory(cat);
        //       }
        //     },
        //     child: SvgPicture.asset(AssetPaths.filter),
        //   ),
        // ],
      ),
      body: Obx(() {
        if (!controller.isLoading.value && controller.blogData.isEmpty) {
          return Center(
            child: emptyState(
              AssetPaths.blogEmptyStateSvg,
              "لا توجد مقالات",
              "",
            ),
          );
        }
        // Otherwise, show the list with a scroll view.
        return SingleChildScrollView(
          controller: controller.scrollController,
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              ...List.generate(
                // When initial load and loading is true, show a few shimmers.
                (controller.isLoading.value && controller.blogData.isEmpty)
                    ? 3
                    : controller.blogData.length,
                (index) {
                  if (controller.isLoading.value &&
                      controller.blogData.isEmpty) {
                    return const BlogItemShimmer();
                  } else {
                    final BlogModel blog = controller.blogData[index];
                    return blogItem(blog, () {
                      Get.to(() => const BlogDetailsScreen(), arguments: blog);
                    });
                  }
                },
              ),
              const Gap(100),
            ],
          ),
        );
      }),
    );
  }
}
