import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart' hide Trans;
import '../../../../config/asset_paths.dart';
import '../../../../core/core.dart';
import '../../../../core/utils/date_utils.dart';
import '../../data/models/blog_model.dart';
import '../widgets/blog_widget.dart';
import '../../../shared/presentation/controllers/current_user_controller.dart';

Future<BlogModel> blogCommentProcess(BlogModel blogData) async {
  BlogModel data = BlogModel.fromJson(blogData.toJson());

  for (var comment in blogData.comments ?? []) {
    for (var replay in comment.replies!) {
      data.comments!.removeWhere((element) => element.id == replay.id);
    }
  }

  return data;
}

class BlogDetailsScreen extends StatefulWidget {
  const BlogDetailsScreen({super.key});

  @override
  State<BlogDetailsScreen> createState() => _BlogDetailsScreenState();
}

class _BlogDetailsScreenState extends State<BlogDetailsScreen> {
  BlogModel? blogData;

  bool userIsLogin = false;
  bool readData = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      blogData = ModalRoute.of(context)!.settings.arguments as BlogModel;

      isLogin();

      if (blogData != null) {
        compute(blogCommentProcess, blogData!).then((value) {
          blogData = value;

          setState(() {});
        });
      }
    });
  }

  isLogin() async {
    if (Get.find<CurrentUserController>().user?.id != null) {
      setState(() {
        userIsLogin = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (readData) {
      //   blogData = ModalRoute.of(context)!.settings.arguments as BlogModel;
      readData = false;
    }
    return Scaffold(
      appBar: const CustomAppBar(title: "blogPost"),
      body:
          blogData == null
              ? const SizedBox()
              : Stack(
                children: [
                  // details
                  Positioned.fill(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Gap(6),

                          CustomTextWidget(
                            text: blogData!.title ?? '',
                            fontWeight: FontWeight.bold,
                          ),

                          const Gap(10),

                          // date
                          Row(
                            children: [
                              SvgPicture.asset(AssetPaths.calendarSvg),
                              const Gap(5),
                              Text(
                                timeStampToDate(
                                  (blogData?.createdAt ?? 0) * 1000,
                                ),
                              ),
                              const CustomTextWidget(text: "in_"),
                              Expanded(
                                child: CustomTextWidget(
                                  text: blogData!.category ?? '',
                                ),
                              ),
                            ],
                          ),

                          const Gap(20),

                          ClipRRect(
                            borderRadius: BorderRadius.circular(15.r),
                            child: CustomImage(
                              image: blogData!.image ?? '',
                              width: Get.width,
                              height: 210.w,
                            ),
                          ),

                          const Gap(20),

                          if (blogData!.author != null) ...{
                            userProfile(blogData!.author!),
                          },

                          const Gap(20),

                          HtmlWidget(
                            blogData!.content ?? '',
                            textStyle: style14Regular().copyWith(color: greyA5),
                          ),

                          const Gap(20),

                          const CustomTextWidget(
                            text: "comments",
                            fontWeight: FontWeight.bold,
                          ),

                          const Gap(16),

                          if (blogData!.comments?.isEmpty ?? true) ...{
                            Center(
                              child: emptyState(
                                AssetPaths.commentsEmptyStateSvg,
                                "noComments".tr(context: context),
                                "noCommentsDesc".tr(context: context),
                              ),
                            ),
                          } else ...{
                            // comments
                            ...List.generate(blogData!.comments?.length ?? 0, (
                              index,
                            ) {
                              return commentUi(blogData!.comments![index], () {
                                BlogWidget.showOptionDialog(
                                  blogData!.id!,
                                  blogData!.comments![index].id!,
                                  userIsLogin,
                                );
                              });
                            }),
                          },

                          const Gap(120),
                        ],
                      ),
                    ),
                  ),

                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    bottom: userIsLogin ? 0 : -150,
                    child: Container(
                      width: Get.width,
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 20,
                        bottom: 30,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          boxShadow(
                            Colors.black.withValues(alpha: .1),
                            blur: 15,
                            y: -3,
                          ),
                        ],
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(30),
                        ),
                      ),
                      child: CustomButton(
                        onPressed: () {
                          BlogWidget.showReplayDialog(blogData!.id!, null);
                        },
                        width: Get.width,
                        height: 52,
                        backgroundColor: Get.theme.colorScheme.primary,
                        child: CustomTextWidget(
                          text: "leaveAComment",
                          color: Get.theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}
