import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../../config/asset_paths.dart';
import '../../../../core/core.dart';
import '../../data/datasources/blog_remote_datasource.dart';
import '../../data/models/basic_model.dart';

class BlogWidget {
  static showOptionDialog(
    int postId,
    int? commentId,
    bool isLogin, {
    String itemName = 'blog',
  }) {
    return baseBottomSheet(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(25),
            const CustomTextWidget(text: "commentOptions"),
            const Gap(16),
            if (isLogin) ...{
              GestureDetector(
                onTap: () {
                  Get.back(result: true);
                  showReplayDialog(postId, commentId, itemName: itemName);
                },
                behavior: HitTestBehavior.opaque,
                child: Row(
                  children: [
                    SvgPicture.asset(AssetPaths.replaySvg),
                    const Gap(8),
                    const CustomTextWidget(text: "reply"),
                  ],
                ),
              ),
              const Gap(20),
            },
            GestureDetector(
              onTap: () {
                Get.back(result: true);
                showReportDialog(commentId!);
              },
              behavior: HitTestBehavior.opaque,
              child: Row(
                children: [
                  SvgPicture.asset(AssetPaths.reportSvg),
                  const Gap(8),
                  const CustomTextWidget(text: "report"),
                ],
              ),
            ),
            const Gap(52),
          ],
        ),
      ),
    );
  }

  static Future<bool?> showReplayDialog(
    int postId,
    int? commentId, {
    String itemName = 'blog',
  }) async {
    TextEditingController messageController = TextEditingController();
    FocusNode messageNode = FocusNode();

    bool isLoading = false;

    return await baseBottomSheet(
      child: Builder(
        builder: (context) {
          return StatefulBuilder(
            builder: (context, state) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  right: 21,
                  left: 21,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(25),
                    CustomTextWidget(
                      text: commentId == null ? "comments" : "replyToComment",
                    ),
                    const Gap(20),
                    descriptionInput(
                      messageController,
                      messageNode,
                      "description",
                      isBorder: true,
                    ),
                    const Gap(20),
                    Center(
                      child: CustomButton(
                        onPressed: () async {
                          if (messageController.text.trim().isNotEmpty) {
                            isLoading = true;
                            state(() {});

                            await BlogRemoteDatasource.saveComments(
                              postId,
                              commentId,
                              itemName,
                              messageController.text.trim(),
                            ).then((_) {
                              Get.close(1);
                            });

                            isLoading = false;
                            state(() {});
                          }
                        },
                        width: Get.width,
                        height: 52,
                        backgroundColor: Get.theme.colorScheme.primary,
                        child:
                            isLoading
                                ? LoadingAnimation(
                                  color: Get.theme.colorScheme.onSurface,
                                )
                                : CustomTextWidget(
                                  text: "submitComment",
                                  color: Get.theme.colorScheme.onSurface,
                                ),
                      ),
                    ),
                    const Gap(20),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  static showReportDialog(int commentId) {
    TextEditingController messageController = TextEditingController();
    FocusNode messageNode = FocusNode();

    return baseBottomSheet(
      child: Builder(
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              right: 21,
              left: 21,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(25),
                const CustomTextWidget(text: "messageToReviewer"),
                const Gap(20),
                descriptionInput(
                  messageController,
                  messageNode,
                  "description",
                  isBorder: true,
                ),
                const Gap(20),
                CustomButton(
                  onPressed: () {
                    if (messageController.text.trim().isNotEmpty) {
                      BlogRemoteDatasource.reportComments(
                        commentId,
                        messageController.text.trim(),
                      );

                      Get.back(result: true);
                    }
                  },
                  width: Get.width,
                  height: 52,
                  backgroundColor: Get.theme.colorScheme.primary,
                  child: CustomTextWidget(
                    text: "report",
                    color: Get.theme.colorScheme.onSurface,
                  ),
                ),
                const Gap(20),
              ],
            ),
          );
        },
      ),
    );
  }

  static Future showCategoriesDialog(
    BasicModel? selectedCategory,
    List<BasicModel> categories,
  ) async {
    return await baseBottomSheet(
      child: Builder(
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              right: 21,
              left: 21,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(25),
                const CustomTextWidget(text: "blogCategories"),
                const Gap(20),
                ...List.generate(categories.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      Get.back(result: categories[index]);
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      alignment: AlignmentDirectional.centerStart,
                      height: 45,
                      child: Text(
                        categories[index].title ?? '',
                        style: style16Regular().copyWith(
                          color:
                              categories[index].id == selectedCategory?.id
                                  ? Get.theme.colorScheme.primary
                                  : Get.theme.colorScheme.primary.withValues(
                                    alpha: 0.5,
                                  ),
                        ),
                      ),
                    ),
                  );
                }),
                const Gap(20),
              ],
            ),
          );
        },
      ),
    );
  }
}
