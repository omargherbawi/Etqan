import 'dart:io';

import 'package:comment_tree/widgets/comment_tree_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' hide Trans;
import 'package:image_picker/image_picker.dart';
import 'package:etqan_edu_app/config/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/routes/route_paths.dart';
import '../../../../core/widgets/custom_image.dart';
import '../../data/models/comment_tree_model.dart';
import '../../data/models/post_model.dart';
import '../controllers/course_detail_controller.dart';

class CourseForumTap extends StatefulWidget {
  const CourseForumTap({super.key});

  @override
  State<CourseForumTap> createState() => _CourseForumTapState();
}

class _CourseForumTapState extends State<CourseForumTap> {
  @override
  void initState() {
    super.initState();
    _fetchForumData();
  }

  void _fetchForumData() {
    final controller = Get.find<CourseDetailController>();
    final course = controller.singleCourseData.value;
    if (course.id != null) {
      controller.fetchCourseForum(course.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CourseDetailController>();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Obx(() {
        if (controller.isForumLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.forumPosts.isEmpty) {
          return Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('noForumPostsAvailable'.tr()),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 40.h, left: 16.w, right: 16.w),
                child: SizedBox(
                  width: double.infinity,
                  height: 40.h,
                  child: ElevatedButton(
                    onPressed: () => showAddPostBottomSheet(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'addPost'.tr(),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        return Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  _fetchForumData();
                },
                child: ListView.builder(
                  padding: EdgeInsets.all(16.w),
                  itemCount: controller.forumPosts.length,
                  itemBuilder: (context, index) {
                    final post = controller.forumPosts[index];
                    final commentTree = post.toCommentTreeModel();
                    return Padding(
                      padding: EdgeInsets.only(bottom: 16.h),
                      child: CommentTreeWidget<
                        CommentTreeModel,
                        CommentTreeModel
                      >(
                        commentTree,
                        commentTree.replies ?? [],
                        avatarRoot:
                            (context, data) => PreferredSize(
                              child: CircleAvatar(
                                radius: 20.r,
                                backgroundColor: Colors.grey[300],
                                backgroundImage:
                                    data.avatar != null &&
                                            data.avatar!.isNotEmpty
                                        ? NetworkImage(data.avatar!)
                                        : null,
                                child:
                                    data.avatar == null || data.avatar!.isEmpty
                                        ? Icon(
                                          Icons.person,
                                          color: Colors.grey[600],
                                          size: 20.r,
                                        )
                                        : null,
                              ),
                              preferredSize: Size.fromRadius(20.r),
                            ),
                        avatarChild:
                            (context, data) => PreferredSize(
                              child: CircleAvatar(
                                radius: 16.r,
                                backgroundColor: Colors.grey[300],
                                backgroundImage:
                                    data.avatar != null &&
                                            data.avatar!.isNotEmpty
                                        ? NetworkImage(data.avatar!)
                                        : null,
                                child:
                                    data.avatar == null || data.avatar!.isEmpty
                                        ? Icon(
                                          Icons.person,
                                          color: Colors.grey[600],
                                          size: 16.r,
                                        )
                                        : null,
                              ),
                              preferredSize: Size.fromRadius(16.r),
                            ),
                        contentRoot:
                            (context, data) => GestureDetector(
                              onTap: () {
                                Get.toNamed(
                                  RoutePaths.postDetailsScreen,
                                  arguments: post,
                                );
                              },
                              child: buildPostContent(data, post),
                            ),
                        contentChild:
                            (context, data) => Container(
                              margin: EdgeInsets.only(left: 8.w),
                              padding: EdgeInsets.all(12.w),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(color: Colors.grey[200]!),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        data.userName ?? 'unknownUser'.tr(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13.sp,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4.h),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          data.content ?? '',
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            color: Colors.black87,
                                            height: 1.4,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        formatFullTimestamp(data.createdAt),
                                        style: TextStyle(
                                          fontSize: 11.sp,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 40.h, left: 16.w, right: 16.w),
              child: SizedBox(
                width: double.infinity,
                height: 40.h,
                child: ElevatedButton(
                  onPressed: () => showAddPostBottomSheet(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'addPost'.tr(),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget buildPostContent(CommentTreeModel data, PostModel post) {
    return Container(
      margin: EdgeInsets.only(left: 8.w),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                data.userName ?? 'unknownUser'.tr(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              if (post.can?.update == true) ...[
                GestureDetector(
                  onTap: () {
                    showEditPostBottomSheet(context, post);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 12.sp),
                      Text(
                        'edit'.tr(),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 11.sp,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            post.title ?? '',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
          if (post.description != null && post.description!.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Row(
              children: [
                Expanded(
                  child: Text(
                    post.description!,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                  ),
                ),
                Text(
                  formatFullTimestamp(data.createdAt),
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
          // Display attachment if available
          if (post.attachment != null && post.attachment!.isNotEmpty) ...[
            SizedBox(height: 12.h),
            _buildAttachmentWidget(post.attachment!),
          ],
          SizedBox(height: 10.h),
          Row(
            children: [
              Text(
                'replay'.tr(),
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Icon(Icons.reply, color: Colors.grey),
            ],
          ),
        ],
      ),
    );
  }

  String formatFullTimestamp(int? timestamp) {
    if (timestamp == null) return 'unknownDate'.tr();
    final commentTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return _formatFullDateTime(commentTime);
  }

  String _formatFullDateTime(DateTime dateTime) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final month = months[dateTime.month - 1];
    final day = dateTime.day;
    final year = dateTime.year;
    final hour =
        dateTime.hour == 0
            ? 12
            : dateTime.hour > 12
            ? dateTime.hour - 12
            : dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour < 12 ? 'AM' : 'PM';
    return '$month $day, $year at $hour:$minute $period';
  }

  bool _isImageFile(String url) {
    final imageExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp', '.bmp'];
    final lowerUrl = url.toLowerCase();
    return imageExtensions.any((ext) => lowerUrl.contains(ext));
  }

  String _getFileName(String url) {
    try {
      final uri = Uri.parse(url);
      final path = uri.path;
      return path.split('/').last;
    } catch (e) {
      return 'attachment';
    }
  }

  String _getFileExtension(String url) {
    try {
      final fileName = _getFileName(url);
      if (fileName.contains('.')) {
        return fileName.split('.').last.toUpperCase();
      }
      return 'FILE';
    } catch (e) {
      return 'FILE';
    }
  }

  Future<void> _downloadFile(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          'error'.tr(),
          'cannotOpenFile'.tr(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'error'.tr(),
        'failedToDownloadFile'.tr(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Widget _buildAttachmentWidget(String attachmentUrl) {
    final isImage = _isImageFile(attachmentUrl);

    if (isImage) {
      // Display image using CustomImage
      return GestureDetector(
        onTap: () => _downloadFile(attachmentUrl),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.grey[300]!, width: 1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: CustomImage(
              image: attachmentUrl,
              width: double.infinity,
              height: 200.h,
              fit: BoxFit.cover,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ),
      );
    } else {
      // Display file with download button
      final fileName = _getFileName(attachmentUrl);
      final fileExtension = _getFileExtension(attachmentUrl);

      return Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.blue[200]!, width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.insert_drive_file,
                color: Colors.blue[700],
                size: 24.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fileName,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    fileExtension,
                    style: TextStyle(fontSize: 11.sp, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            InkWell(
              onTap: () => _downloadFile(attachmentUrl),
              child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.blue[600],
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.download, color: Colors.white, size: 18.sp),
                    SizedBox(width: 4.w),
                    Text(
                      'download'.tr(),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Future<File?> pickFile() async {
    return await showModalBottomSheet<File?>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(16.w),
                child: Text(
                  'selectFileSource'.tr(),
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.camera_alt,
                  color: AppLightColors.primaryColor,
                ),
                title: Text(
                  'takePhoto'.tr(),
                  style: const TextStyle(color: Colors.black),
                ),
                onTap: () async {
                  final ImagePicker picker = ImagePicker();
                  final XFile? photo = await picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 80,
                  );
                  if (photo != null) {
                    Navigator.of(context).pop(File(photo.path));
                  } else {
                    Navigator.of(context).pop();
                  }
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.photo_library,
                  color: AppLightColors.primaryColor,
                ),
                title: Text(
                  'chooseFromGallery'.tr(),
                  style: const TextStyle(color: Colors.black),
                ),
                onTap: () async {
                  final ImagePicker picker = ImagePicker();
                  final XFile? photo = await picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 80,
                  );
                  if (photo != null) {
                    Navigator.of(context).pop(File(photo.path));
                  } else {
                    Navigator.of(context).pop();
                  }
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.attach_file,
                  color: AppLightColors.primaryColor,
                ),
                title: Text(
                  'chooseFile'.tr(),
                  style: const TextStyle(color: Colors.black),
                ),
                onTap: () async {
                  FilePickerResult? result = await FilePicker.platform
                      .pickFiles(type: FileType.any, allowMultiple: false);
                  if (result != null && result.files.single.path != null) {
                    Navigator.of(context).pop(File(result.files.single.path!));
                  } else {
                    Navigator.of(context).pop();
                  }
                },
              ),
              SizedBox(height: 16.h),
            ],
          ),
        );
      },
    );
  }

  void showAddPostBottomSheet(BuildContext context) {
    final controller = Get.find<CourseDetailController>();
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    File? selectedFile;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.r),
                        topRight: Radius.circular(20.r),
                      ),
                      border: Border(
                        bottom: BorderSide(color: Colors.grey[200]!, width: 1),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'cancel'.tr(),
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        Text(
                          'addNewPost'.tr(),
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Obx(
                          () => TextButton(
                            onPressed:
                                controller.isLoading.value
                                    ? null
                                    : () async {
                                      if (formKey.currentState!.validate()) {
                                        await controller.addPost(
                                          titleController.text.trim(),
                                          descriptionController.text.trim(),
                                          file: selectedFile,
                                        );

                                        if (mounted &&
                                            Navigator.of(context).canPop()) {
                                          Navigator.of(context).pop();
                                        }
                                      }
                                    },
                            child:
                                controller.isLoading.value
                                    ? SizedBox(
                                      width: 20.w,
                                      height: 20.h,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Theme.of(context).primaryColor,
                                            ),
                                      ),
                                    )
                                    : Text(
                                      'save'.tr(),
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(16.w),
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'title'.tr(),
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            TextFormField(
                              controller: titleController,
                              decoration: InputDecoration(
                                hintText: 'enterPostTitle'.tr(),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                  borderSide: BorderSide(
                                    color: Colors.grey[300]!,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'pleaseEnterTitle'.tr();
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20.h),
                            Text(
                              'description'.tr(),
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            SizedBox(
                              height: 200.h,
                              child: TextFormField(
                                controller: descriptionController,
                                decoration: InputDecoration(
                                  hintText: 'enterPostDescription'.tr(),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                    borderSide: BorderSide(
                                      color: Colors.grey[300]!,
                                    ),
                                  ),
                                ),
                                maxLines: null,
                                expands: true,
                                textAlignVertical: TextAlignVertical.top,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'pleaseEnterDescription'.tr();
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(height: 20.h),
                            // Display selected file
                            if (selectedFile != null) ...[
                              Container(
                                padding: EdgeInsets.all(12.w),
                                decoration: BoxDecoration(
                                  color: Colors.green[50],
                                  borderRadius: BorderRadius.circular(8.r),
                                  border: Border.all(color: Colors.green[200]!),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.attach_file,
                                      color: Colors.green[600],
                                      size: 20.sp,
                                    ),
                                    SizedBox(width: 8.w),
                                    Expanded(
                                      child: Text(
                                        selectedFile!.path.split('/').last,
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          color: Colors.green[700],
                                          fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedFile = null;
                                        });
                                      },
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.green[600],
                                        size: 18.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 16.h),
                            ],
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  final file = await pickFile();
                                  if (file != null) {
                                    setState(() {
                                      selectedFile = file;
                                    });
                                  }
                                },
                                icon: Icon(
                                  Icons.upload_file,
                                  size: 18.sp,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  'uploadFile'.tr(),
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppLightColors.primaryColor,
                                  elevation: 0,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 12.h,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                    side: BorderSide(
                                      color: Colors.grey[300]!,
                                      width: 1,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 30.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void showEditPostBottomSheet(BuildContext context, PostModel post) {
    final controller = Get.find<CourseDetailController>();
    final titleController = TextEditingController(text: post.title ?? '');
    final descriptionController = TextEditingController(
      text: post.description ?? '',
    );
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.r),
                        topRight: Radius.circular(20.r),
                      ),
                      border: Border(
                        bottom: BorderSide(color: Colors.grey[200]!, width: 1),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'cancel'.tr(),
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        Text(
                          'editPost'.tr(),
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Obx(
                          () => TextButton(
                            onPressed:
                                controller.isLoading.value
                                    ? null
                                    : () async {
                                      if (formKey.currentState!.validate()) {
                                        await controller.editPost(
                                          post.id!,
                                          titleController.text.trim(),
                                          descriptionController.text.trim(),
                                        );

                                        if (mounted &&
                                            Navigator.of(context).canPop()) {
                                          Navigator.of(context).pop();
                                        }
                                      }
                                    },
                            child:
                                controller.isLoading.value
                                    ? SizedBox(
                                      width: 20.w,
                                      height: 20.h,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Theme.of(context).primaryColor,
                                            ),
                                      ),
                                    )
                                    : Text(
                                      'save'.tr(),
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(16.w),
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'title'.tr(),
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            TextFormField(
                              controller: titleController,
                              decoration: InputDecoration(
                                hintText: 'enterPostTitle'.tr(),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                  borderSide: BorderSide(
                                    color: Colors.grey[300]!,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'pleaseEnterTitle'.tr();
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20.h),
                            Text(
                              'description'.tr(),
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            SizedBox(
                              height: 200.h,
                              child: TextFormField(
                                controller: descriptionController,
                                decoration: InputDecoration(
                                  hintText: 'enterPostDescription'.tr(),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                    borderSide: BorderSide(
                                      color: Colors.grey[300]!,
                                    ),
                                  ),
                                ),
                                maxLines: null,
                                expands: true,
                                textAlignVertical: TextAlignVertical.top,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'pleaseEnterDescription'.tr();
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
