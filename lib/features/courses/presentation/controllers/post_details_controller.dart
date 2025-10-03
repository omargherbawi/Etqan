import 'dart:developer';

import 'package:get/get.dart';
import '../../../../core/core.dart';
import '../../data/data_sources/course_remote_datasourse.dart';
import '../../data/models/forum_answer_model.dart';
import '../../data/models/post_model.dart';
import 'course_detail_controller.dart';

class PostDetailsController extends GetxController {
  final PostModel post;
  final _courseRemoteDatasource = Get.find<CourseRemoteDataSource>();

  final answers = <ForumAnswerModel>[].obs;
  final isLoading = false.obs;
  final isFetchingAnswers = false.obs;

  int currentPage = 1;
  bool hasMore = true;

  PostDetailsController({required this.post});

  @override
  void onReady() {
    super.onReady();
    fetchForumAnswers(loadMore: false);
  }

  void updateFetchingLoading(bool isLoading) {
    isFetchingAnswers.value = isLoading;
  }

  Future<void> fetchForumAnswers({bool loadMore = false}) async {
    if (isFetchingAnswers.value || !hasMore) return;

    if (!loadMore) {
      isLoading.value = true;
      currentPage = 1;
      hasMore = true;
      answers.clear();
    } else {
      updateFetchingLoading(true);
    }

    final res = await _courseRemoteDatasource.fetchForumAnswers(post.id!);

    res.fold(
      (l) {
        ToastUtils.showError(l.message);
        if (!loadMore) {
          isLoading.value = false;
        }
      },
      (r) {
        if (loadMore) {
          final newItems =
              r
                  .where(
                    (answer) =>
                        !answers.any((existing) => existing.id == answer.id),
                  )
                  .toList();
          answers.addAll(newItems);
        } else {
          answers.assignAll(r);
          isLoading.value = false;
        }

        hasMore = false;
      },
    );

    if (loadMore) {
      updateFetchingLoading(false);
    }
  }

  Future<void> addAnswer(String description) async {
    isLoading(true);

    final res = await _courseRemoteDatasource.addAnswer(description, post.id!);

    res.fold(
      (l) {
        ToastUtils.showError("Failedtoaddanswer");
        isLoading(false);
      },
      (r) {
        ToastUtils.showSuccess("Answeraddedsuccessfully");

        // Add the new answer to the local list
        answers.insert(0, r);
        answers.refresh();

        // Update the post's last answer in CourseDetailController
        try {
          final courseDetailController = Get.find<CourseDetailController>();
          courseDetailController.updatePostLastAnswer(post.id!, r);
        } catch (e) {
          log("Could not update CourseDetailController: $e");
        }

        isLoading(false);
      },
    );
  }

  Future<void> editAnswer(int answerId, String description) async {
    isLoading(true);

    final res = await _courseRemoteDatasource.editAnswer(description, answerId);

    res.fold(
      (l) {
        ToastUtils.showError("Failedtoeditanswer");
        isLoading(false);
      },
      (r) {
        ToastUtils.showSuccess("Answereditedsuccessfully");

        // Update the answer in the local list
        final currentAnswers = List<ForumAnswerModel>.from(answers);
        final index = currentAnswers.indexWhere(
          (answers) => answers.id == answerId,
        );
        if (index != -1) {
          currentAnswers[index] = r;
          answers(currentAnswers);
          answers.refresh();
        }

        // Update the post's last answer in CourseDetailController
        try {
          final courseDetailController = Get.find<CourseDetailController>();
          courseDetailController.updatePostLastAnswer(post.id!, r);
        } catch (e) {
          log("Could not update CourseDetailController: $e");
        }

        isLoading(false);
      },
    );
  }

  Future<void> refreshAnswers() async {
    currentPage = 1;
    hasMore = true;
    isLoading.value = true;
    await fetchForumAnswers(loadMore: false);
  }

  void insertAnswer(ForumAnswerModel answer) {
    answers.insert(0, answer);
  }

  void updateAnswer(ForumAnswerModel updatedAnswer) {
    final index = answers.indexWhere((answer) => answer.id == updatedAnswer.id);
    if (index != -1) {
      answers[index] = updatedAnswer;
    }
  }

  void deleteAnswer(int answerId) {
    answers.removeWhere((answer) => answer.id == answerId);
  }
}
