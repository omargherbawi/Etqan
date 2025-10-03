import 'dart:convert';

import '../../../../core/enums/text_style_enum.dart';
import '../../../../core/services/api_services.dart' show RestApiService;
import '../../../../core/utils/console_log_functions.dart';
import '../../../../core/utils/shared.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_widget.dart';
import '../controllers/current_video_controller.dart';
import '../screens/pdf_screen.dart';
import '../../data/models/content_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class CourseLessonsWidget extends StatefulWidget {
  final ContentModel content;
  final int courseId;
  const CourseLessonsWidget({
    super.key,
    required this.content,
    required this.courseId,
  });

  @override
  State<CourseLessonsWidget> createState() => _CourseLessonsWidgetState();
}

class _CourseLessonsWidgetState extends State<CourseLessonsWidget> {
  final baseUrl = "https://tedreeb.com";

  final currentVideoController = Get.find<CurrentVideoController>();

  @override
  Widget build(BuildContext context) {
    logInfo('CourseLessonsWidget build called');

    final filteredItems =
        widget.content.items?.where((item) => item.type != "quiz").toList() ??
        [];

    logInfo(
      'items type: ${widget.content.items.runtimeType}, value: ${widget.content.items}',
    );

    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Chapter Header
            Container(
              decoration: BoxDecoration(
                color: Get.theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
              child: Row(
                children: [
                  Icon(Icons.book, color: Get.theme.primaryColor, size: 28),
                  Gap(10.w),
                  Expanded(
                    child: CustomTextWidget(
                      text: widget.content.title ?? "",
                      maxLines: 2,
                      textAlign: TextAlign.start,
                      textThemeStyle: TextThemeStyleEnum.bodyLarge,
                      fontWeight: FontWeight.bold,
                      color: Get.theme.primaryColor,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 4.h,
                      horizontal: 12.w,
                    ),
                    decoration: BoxDecoration(
                      color: Get.theme.primaryColor,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.list, color: Colors.white, size: 18),
                        Gap(4.w),
                        CustomTextWidget(
                          text: widget.content.topicsCount.toString(),
                          maxLines: 1,
                          textAlign: TextAlign.start,
                          textThemeStyle: TextThemeStyleEnum.bodyMedium,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Gap(12.h),
            _buildLessonList(filteredItems),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonList(List<ContentItem> lessons, {int depth = 0}) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: lessons.length,
      separatorBuilder: (context, index) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        return _buildLessonItem(lessons[index], index, depth);
      },
    );
  }

  Widget _buildLessonItem(ContentItem item, int index, int depth) {
    final currentItemVideo = item.videoUrl;
    final indent = depth * 35.0;

    if (item.type == "text_lesson" &&
        item.subLessons != null &&
        item.subLessons!.isNotEmpty) {
      return Padding(
        padding: EdgeInsets.only(left: indent),
        child: Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: ExpansionTile(
            collapsedIconColor: Get.theme.colorScheme.primary,
            tilePadding: EdgeInsets.zero,
            title: Row(
              children: [
                Gap(3.w),
                Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Get.theme.colorScheme.onSurface,
                  ),
                  child: CustomTextWidget(
                    text: "${index + 1}",
                    maxLines: 1,
                    textAlign: TextAlign.start,
                    textThemeStyle: TextThemeStyleEnum.bodyLarge,
                    fontWeight: FontWeight.w600,
                    color: Get.theme.primaryColor,
                  ),
                ),
                Gap(8.w),
                Icon(Icons.menu_book, color: Get.theme.primaryColor),
                Gap(8.w),
                Expanded(
                  child: CustomTextWidget(
                    text: item.title ?? "تفاصيل الدرس",
                    maxLines: 2,
                    textAlign: TextAlign.start,
                    textThemeStyle: TextThemeStyleEnum.bodySmall,
                    fontWeight: FontWeight.w500,
                    color: Get.theme.primaryColor,
                  ),
                ),
              ],
            ),
            children: [_buildLessonList(item.subLessons!, depth: depth + 1)],
          ),
        ),
      );
    } else if (item.type == "text_lesson" &&
        item.subLessons != null &&
        item.subLessons!.isEmpty) {
      return const SizedBox.shrink();
    } else {
      return GestureDetector(
        onTap: () async {
          logInfo("item.type: ${item.type}");
          if (item.authHasRead == false) {
            setState(() {
              item.authHasRead = true;
            });
            toggle(
              item.type == 'text_lesson'
                  ? 'text_lesson_id'
                  : item.type == 'file'
                  ? 'file_id'
                  : 'session_id',
              item.id.toString(),
              true,
            );
          }

          if (item.fileType != "video") {
            if (currentItemVideo != null &&
                !currentItemVideo.startsWith("http")) {
              if (item.videoUrl == null) return;

              Get.to(
                () => PdfViewerScreen(
                  pdfUrl: "$baseUrl${item.videoUrl}",
                  title: item.title ?? "",
                ),
              );
            }
          } else {
            currentVideoController.changeCurrentVideoUrl(
              video: currentItemVideo ?? "",
              id: item.id,
            );
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: indent),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(UIConstants.radius25),
                color:
                    currentVideoController.currentVideoId.value == item.id
                        ? Get.theme.colorScheme.primary
                        : Colors.transparent,
                border: Border.all(
                  color: Get.theme.colorScheme.onSecondaryContainer,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Gap(3.w),
                  Container(
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Get.theme.colorScheme.onSurface,
                    ),
                    child: CustomTextWidget(
                      text: "${index + 1}",
                      maxLines: 1,
                      textAlign: TextAlign.start,
                      textThemeStyle: TextThemeStyleEnum.bodyLarge,
                      fontWeight: FontWeight.w600,
                      color: Get.theme.primaryColor,
                    ),
                  ),
                  Gap(8.w),
                  Expanded(
                    child: CustomTextWidget(
                      text: item.title ?? "",
                      maxLines: 2,
                      textAlign: TextAlign.start,
                      textThemeStyle: TextThemeStyleEnum.bodySmall,
                      fontWeight: FontWeight.w500,
                      color:
                          currentVideoController.currentVideoId.value == item.id
                              ? Get.theme.colorScheme.onSurface
                              : Get.theme.colorScheme.inverseSurface,
                    ),
                  ),
                  Gap(5.w),
                  if (item.can?.view == true)
                    switchButton("", item.authHasRead ?? false, (value) {}),
                  Gap(5.w),
                  CircleIconButton(
                    icon:
                        item.fileType != "video"
                            ? item.type == "text_lesson"
                                ? Icons.arrow_drop_down_rounded
                                : Icons.file_copy
                            : Icons.play_circle,
                    greyBackground: false,
                    greyBorder: false,
                    onPressed: () async {
                      if (item.authHasRead == false) {
                        setState(() {
                          item.authHasRead = true;
                        });
                        toggle(
                          item.type == 'text_lesson'
                              ? 'text_lesson_id'
                              : item.type == 'file'
                              ? 'file_id'
                              : 'session_id',
                          item.id.toString(),
                          true,
                        );
                      }

                      if (item.fileType != "video") {
                        if (currentItemVideo != null &&
                            !currentItemVideo.startsWith("http")) {
                          if (item.videoUrl == null) return;

                          Get.to(
                            () => PdfViewerScreen(
                              pdfUrl: "$baseUrl${item.videoUrl}",
                              title: item.title ?? "",
                            ),
                          );
                        }
                      } else {
                        currentVideoController.changeCurrentVideoUrl(
                          video: currentItemVideo ?? "",
                          id: item.id,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            if (item.type == "text_lesson" &&
                item.subLessons != null &&
                item.subLessons!.isNotEmpty) ...[
              Gap(8.h),
              Padding(
                padding: EdgeInsets.only(left: indent),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    dividerColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                  child: ExpansionTile(
                    collapsedIconColor: Get.theme.colorScheme.primary,
                    tilePadding: EdgeInsets.zero,
                    title: Row(
                      children: [
                        Icon(Icons.menu_book, color: Get.theme.primaryColor),
                        Gap(8.w),
                        Expanded(
                          child: CustomTextWidget(
                            text: "تفاصيل الدرس",
                            textAlign: TextAlign.start,
                            textThemeStyle: TextThemeStyleEnum.bodySmall,
                            fontWeight: FontWeight.w500,
                            color: Get.theme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    children: [
                      _buildLessonList(item.subLessons!, depth: depth + 1),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    }
  }

  Future<bool> toggle(String itemName, String? itemId, bool status) async {
    try {
      if (itemId == null) {
        return false;
      }
      String url = 'development/courses/${widget.courseId}/toggle';
      ;

      final res = await RestApiService.post(url, {
        "item": itemName,
        "item_id": itemId,
        "status": status,
      });

      var jsonResponse = jsonDecode(res.body);

      return jsonResponse['success'] == true;
    } catch (e) {
      return false;
    }
  }
}
