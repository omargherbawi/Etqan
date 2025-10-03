import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' hide Trans;
import 'package:open_file/open_file.dart';
import 'package:tedreeb_edu_app/core/core.dart';
import 'package:tedreeb_edu_app/features/home/data/models/filter_shared_model.dart';

import '../controllers/files_controller.dart';

class FilesScreen extends StatelessWidget {
  const FilesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FilesController());

    Widget buildFilterField<T>(
      String label,
      RxList<T> options,
      Rx<T?> selected,
      void Function(T) onSelect,
      String Function(T) displayText, {
      String? prerequisiteName,
      bool prerequisiteSelected = true,
    }) {
      return GestureDetector(
        onTap: () {
          if (!prerequisiteSelected) {
            Get.snackbar(
              'تنبيه',
              'يرجى اختيار ${prerequisiteName ?? 'المتطلب'} أولاً',
              snackPosition: SnackPosition.BOTTOM,
            );
            return;
          }
          if (options.isEmpty) {
            Get.snackbar(
              'تنبيه',
              'لا يوجد خيارات متاحة لهذا الفلتر',
              snackPosition: SnackPosition.BOTTOM,
            );
            return;
          }
          HelperFunctions.showCustomModalBottomSheet(
            isScrollControlled: true,
            context: context,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  options.map((opt) {
                    return ListTile(
                      title: CustomTextWidget(text: displayText(opt)),
                      onTap: () {
                        onSelect(opt);
                        Get.back();
                      },
                    );
                  }).toList(),
            ),
          );
        },
        child: AbsorbPointer(
          child: TextWithTextField(
            enabled: false,

            text: label,
            suffix: const Icon(Icons.keyboard_arrow_down_sharp),
            hintText:
                selected.value == null
                    ? '${"select".tr(context: context)} ${label.tr(context: context)}'
                    : displayText(selected.value as T),
            filled: true,
            fillColor: Get.theme.colorScheme.onSecondaryContainer,
            boldLabel: true,
            controller: TextEditingController(),
          ),
        ),
      );
    }

    Widget buildInstructorFilterField() {
      return GestureDetector(
        onTap: () {
          if (controller.selectedClass.value == null) {
            Get.snackbar(
              'تنبيه',
              'يرجى اختيار المادة أولاً',
              snackPosition: SnackPosition.BOTTOM,
            );
            return;
          }
          if (controller.instructors.isEmpty &&
              !controller.isFetchingInstructors.value) {
            Get.snackbar(
              'تنبيه',
              'لا يوجد معلمون متاحون لهذه المادة',
              snackPosition: SnackPosition.BOTTOM,
            );
            return;
          }
          HelperFunctions.showCustomModalBottomSheet(
            isScrollControlled: true,
            context: context,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    height: 400,
                    child: Obx(() {
                      if (controller.isFetchingInstructors.value &&
                          controller.instructors.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return NotificationListener<ScrollNotification>(
                        onNotification: (scrollInfo) {
                          if (!controller.isFetchingInstructors.value &&
                              controller.hasMoreInstructors.value &&
                              scrollInfo.metrics.pixels >=
                                  scrollInfo.metrics.maxScrollExtent - 200) {
                            controller.loadMoreInstructors();
                          }
                          return false;
                        },
                        child: ListView.builder(
                          itemCount:
                              controller.instructors.length +
                              (controller.hasMoreInstructors.value ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index < controller.instructors.length) {
                              final instructor = controller.instructors[index];
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundImage:
                                      instructor.avatar != null
                                          ? NetworkImage(instructor.avatar!)
                                          : null,
                                  child:
                                      instructor.avatar == null
                                          ? const Icon(Icons.person)
                                          : null,
                                ),
                                title: CustomTextWidget(
                                  text: instructor.fullName ?? 'معلم تدريب',
                                  fontWeight: FontWeight.w500,
                                ),
                                subtitle: CustomTextWidget(
                                  text: instructor.email ?? '',
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                                onTap: () {
                                  controller.selectInstructor(instructor);
                                  Get.back();
                                },
                              );
                            } else {
                              return const Padding(
                                padding: EdgeInsets.all(16),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                          },
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          );
        },
        child: AbsorbPointer(
          child: TextWithTextField(
            enabled: false,
            text: 'instructorName',
            suffix: const Icon(Icons.keyboard_arrow_down_sharp),
            hintText:
                controller.selectedInstructor.value == null
                    ? '${"select".tr(context: context)} ${"instructorName".tr(context: context)}'
                    : controller.selectedInstructor.value!.fullName ??
                        'معلم تدريب',
            filled: true,
            fillColor: Get.theme.colorScheme.onSecondaryContainer,

            boldLabel: true,
            controller: TextEditingController(),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: const CustomAppBar(title: 'الملفات'),
      body: Obx(() {
        if (controller.isLoading.value && controller.files.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        // Make the whole page scrollable
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ==== FILTER BAR ====
                Column(
                  children: [
                    Row(
                      spacing: 4.w,
                      children: [
                        Expanded(
                          child: buildFilterField<FilterSharedModel>(
                            'program',
                            controller.programs,
                            controller.selectedProgram,
                            controller.selectProgram,
                            (p) => p.title,
                          ),
                        ),
                        Expanded(
                          child: buildFilterField<FilterSharedModel>(
                            'subject',
                            controller.subCategories,
                            controller.selectedClass,
                            controller.selectSubCategory,
                            (c) => c.title,
                            prerequisiteName: 'الصف',
                            prerequisiteSelected:
                                controller.selectedProgram.value != null,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      spacing: 4.w,
                      children: [
                        Expanded(child: buildInstructorFilterField()),
                        Expanded(
                          child: buildFilterField<FilterSharedModel>(
                            'FileType',
                            controller.fileTypes,
                            controller.selectedFileType,
                            controller.selectFileType,
                            (c) => c.title,
                            prerequisiteName: 'اسم المعلم',
                            prerequisiteSelected:
                                controller.selectedInstructor.value != null,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),
                    CustomButton(
                      width: double.infinity,
                      onPressed: () => controller.fetchFiles(page: 1),
                      child: CustomTextWidget(
                        text: 'showFilesResults',
                        color: Get.theme.colorScheme.onSurface,
                        fontSize: Responsive.isTablet ? 10 : null,
                      ),
                    ),
                  ],
                ),
                // ==== FILE GRID ====
                GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 2,
                  ),
                  itemCount: controller.files.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final file = controller.files[index];

                    return Obx(() {
                      final isDownloading = controller.downloadProgress
                          .containsKey(index);
                      final progress =
                          controller.downloadProgress[index] ?? 0.0;
                      final downloadedPath = controller.downloadedFiles[index];

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.insert_drive_file,
                                size: 48,
                                color: Colors.indigo,
                              ),
                              const SizedBox(height: 12),
                              CustomTextWidget(
                                text:
                                    file.translations?[0].title ?? 'بدون عنوان',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                textAlign: TextAlign.center,
                              ),
                              const Spacer(),
                              if (downloadedPath != null)
                                CustomButton(
                                  onPressed:
                                      () => OpenFile.open(downloadedPath),
                                  borderRadius: 12,
                                  width: double.infinity,
                                  backgroundColor: Colors.green,
                                  child: const CustomTextWidget(
                                    text: "افتح الملف",
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                )
                              else if (isDownloading)
                                LinearProgressIndicator(value: progress)
                              else
                                CustomButton(
                                  onPressed: () async {
                                    if (file.file == null ||
                                        file.fileType != "pdf")
                                      return;

                                    final url =
                                        "https://tedreeb.com${file.file}";
                                    final fileName =
                                        (file.translations?[0].title ?? 'file')
                                            .replaceAll(" ", "_");

                                    await controller.downloadFile(
                                      index,
                                      url,
                                      "$fileName.pdf",
                                    );
                                  },
                                  borderRadius: 12,
                                  width: double.infinity,
                                  backgroundColor:
                                      Get.theme.colorScheme.primary,
                                  child: CustomTextWidget(
                                    text: "تحميل",
                                    color: Get.theme.colorScheme.onPrimary,
                                    fontSize: Responsive.isTablet ? 10 : 12,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    });
                  },
                ),
                if (controller.isFetchingMore.value)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
