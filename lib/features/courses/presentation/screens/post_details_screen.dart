import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' hide Trans;
import 'package:etqan_edu_app/features/courses/presentation/controllers/course_detail_controller.dart';
import '../../data/models/post_model.dart';
import '../../data/models/forum_answer_model.dart';
import '../controllers/post_details_controller.dart';

class PostDetailsScreen extends StatefulWidget {
  final PostModel post;

  const PostDetailsScreen({super.key, required this.post});

  @override
  State<PostDetailsScreen> createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
  late PostDetailsController postDetailsController;
  late CourseDetailController courseDetailController;
  late TextEditingController answerController;

  @override
  void initState() {
    super.initState();
    postDetailsController = Get.put(PostDetailsController(post: widget.post));
    courseDetailController = Get.find<CourseDetailController>();
    answerController = TextEditingController();
  }

  @override
  void dispose() {
    answerController.dispose();
    super.dispose();
  }

  PostModel get currentPost {
    // Try to get the updated post from the course controller first
    final updatedPost = courseDetailController.forumPosts.firstWhereOrNull(
      (post) => post.id == widget.post.id,
    );
    return updatedPost ?? widget.post;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final post = currentPost;
      return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black87,
              size: 20.sp,
            ),
            onPressed: () => Get.back(),
          ),
          title: Text(
            'postDetails'.tr(),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: postDetailsController.refreshAnswers,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 25.r,
                            backgroundColor: Colors.grey[300],
                            backgroundImage:
                                post.avatar != null && post.avatar!.isNotEmpty
                                    ? NetworkImage(post.avatar!)
                                    : null,
                            child:
                                post.avatar == null || post.avatar!.isEmpty
                                    ? Icon(
                                      Icons.person,
                                      color: Colors.grey[600],
                                      size: 25.r,
                                    )
                                    : null,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  post.userName ?? 'unknownUser'.tr(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  formatFullTimestamp(post.createdAt),
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (post.can?.update == true) ...[
                            GestureDetector(
                              onTap: () {
                                showEditPostBottomSheet(context, post);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(8.r),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.edit,
                                      size: 14.sp,
                                      color: Colors.grey[700],
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      'edit'.tr(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12.sp,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 20.h),

                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.w),
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
                            if (post.title != null &&
                                post.title!.isNotEmpty) ...[
                              Text(
                                post.title!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.sp,
                                  color: Colors.black87,
                                  height: 1.3,
                                ),
                              ),
                              SizedBox(height: 12.h),
                            ],

                            if (post.description != null &&
                                post.description!.isNotEmpty) ...[
                              Text(
                                post.description!,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: Colors.grey[700],
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      SizedBox(height: 24.h),
                      Row(
                        children: [
                          Text(
                            'answers'.tr(),
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const Spacer(),
                          Obx(
                            () => Text(
                              '${postDetailsController.answers.length} ${'answers'.tr()}',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),

                      Obx(() {
                        if (postDetailsController.isLoading.value) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(32.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        if (postDetailsController.answers.isEmpty) {
                          return Container(
                            padding: EdgeInsets.all(32.w),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.chat_bubble_outline,
                                  size: 48.sp,
                                  color: Colors.grey[400],
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  'noAnswersYet'.tr(),
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  'beFirstToAnswer'.tr(),
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: postDetailsController.answers.length,
                          separatorBuilder:
                              (context, index) => SizedBox(height: 12.h),
                          itemBuilder: (context, index) {
                            final answer = postDetailsController.answers[index];
                            return buildAnswerCard(answer, post);
                          },
                        );
                      }),

                      Obx(() {
                        if (postDetailsController.hasMore &&
                            postDetailsController.answers.isNotEmpty) {
                          return Padding(
                            padding: EdgeInsets.only(top: 16.h),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed:
                                    postDetailsController
                                            .isFetchingAnswers
                                            .value
                                        ? null
                                        : () => postDetailsController
                                            .fetchForumAnswers(loadMore: true),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[100],
                                  foregroundColor: Colors.grey[700],
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                ),
                                child:
                                    postDetailsController
                                            .isFetchingAnswers
                                            .value
                                        ? SizedBox(
                                          height: 20.h,
                                          width: 20.w,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.grey[600]!,
                                                ),
                                          ),
                                        )
                                        : Text(
                                          'loadMoreAnswers'.tr(),
                                          style: TextStyle(fontSize: 14.sp),
                                        ),
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      }),

                      // Add bottom padding to account for fixed input
                      SizedBox(height: 100.h),
                    ],
                  ),
                ),
              ),
            ),
            // Fixed bottom input
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, -1),
                    ),
                  ],
                ),
                child: buildAddAnswerInput(),
              ),
            ),
          ],
        ),
      );
    });
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

  Widget buildAnswerCard(ForumAnswerModel answer, PostModel post) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18.r,
                backgroundColor: Colors.grey[300],
                backgroundImage:
                    answer.user?.avatar != null &&
                            answer.user!.avatar!.isNotEmpty
                        ? NetworkImage(answer.user!.avatar!)
                        : null,
                child:
                    answer.user?.avatar == null || answer.user!.avatar!.isEmpty
                        ? Icon(
                          Icons.person,
                          color: Colors.grey[600],
                          size: 18.r,
                        )
                        : null,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      answer.user?.fullName ?? 'unknownUser'.tr(),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      formatFullTimestamp(answer.createdAt),
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  if (answer.can?.update == true) ...[
                    GestureDetector(
                      onTap: () {
                        showEditAnswerBottomSheet(context, answer);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.edit,
                              size: 14.sp,
                              color: Colors.grey[700],
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'edit'.tr(),
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12.sp,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),

          Text(
            answer.description ?? '',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black87,
              height: 1.5,
            ),
          ),

          if (answer.pin == true || answer.resolved == true) ...[
            SizedBox(height: 12.h),
            Row(
              children: [
                if (answer.pin == true) ...[
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.push_pin,
                          size: 12.sp,
                          color: Colors.orange[700],
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'pinned'.tr(),
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: Colors.orange[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                ],
                if (answer.resolved == true) ...[
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 12.sp,
                          color: Colors.green[700],
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'resolved'.tr(),
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: Colors.green[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  void showEditPostBottomSheet(BuildContext context, PostModel post) {
    final controller = courseDetailController;

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
                            'Cancel',
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

  Widget buildAddAnswerInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'addYourAnswer'.tr(),
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: answerController,
                decoration: InputDecoration(
                  hintText: 'writeYourAnswerHere'.tr(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                ),
                maxLines: 3,
                minLines: 1,
              ),
            ),
            SizedBox(width: 8.w),
            Obx(
              () => GestureDetector(
                onTap:
                    postDetailsController.isLoading.value
                        ? null
                        : () async {
                          if (answerController.text.trim().isNotEmpty) {
                            await postDetailsController.addAnswer(
                              answerController.text.trim(),
                            );
                            answerController.clear();
                          }
                        },
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color:
                        postDetailsController.isLoading.value
                            ? Colors.grey[300]
                            : Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child:
                      postDetailsController.isLoading.value
                          ? SizedBox(
                            width: 20.w,
                            height: 20.h,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                          : Icon(Icons.send, color: Colors.white, size: 20.sp),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void showEditAnswerBottomSheet(
    BuildContext context,
    ForumAnswerModel answer,
  ) {
    final controller = postDetailsController;
    final descriptionController = TextEditingController(
      text: answer.description ?? '',
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
              height: MediaQuery.of(context).size.height * 0.6,
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
                            'Cancel',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        Text(
                          'editAnswer'.tr(),
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
                                        await controller.editAnswer(
                                          answer.id!,
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
                              'enterAnswerDescription'.tr(),
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
                                  hintText: 'enterAnswerDescription'.tr(),
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
