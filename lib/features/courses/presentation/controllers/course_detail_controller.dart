import 'dart:developer';
import 'dart:io';

import '../../../../config/api_paths.dart';
import '../../../../core/services/api_services.dart';
import '../../../../core/utils/console_log_functions.dart';
import '../../../../core/utils/toast_utils.dart';
import '../../data/data_sources/course_remote_datasourse.dart';
import '../../data/models/quiz.dart';
import '../../data/models/quiz_detail_model.dart';
import '../../data/models/quiz_result_model.dart';
import '../../data/models/quiz_results_list_model.dart';
import '../../data/models/post_model.dart';
import '../../data/models/forum_answer_model.dart';
import '../../data/models/content_model.dart';
import '../../data/models/single_course_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CourseDetailController extends GetxController {
  final courseDataSource = Get.find<CourseRemoteDataSource>();
  final userAnswers = <int, dynamic>{}.obs;
  final singleCourseData = SingleCourseModel().obs;
  final courseContent = <ContentModel>[].obs;
  final forumPosts = <PostModel>[].obs;
  final quizDetailData = Rxn<QuizDetailData>();
  final quizResults = Rxn<QuizResultsListResponse>();
  final isQuizResultsLoading = false.obs;

  void selectAnswer(int questionId, dynamic answer) {
    userAnswers[questionId] = answer;
    update(); // Trigger UI update
  }

  // Add this method to get the selected answer for a question
  dynamic getSelectedAnswer(int questionId) {
    return userAnswers[questionId];
  }

  final lessonsCount = 0.obs;

  final isLoading = false.obs;
  final isForumLoading = false.obs;

  final scrollController = ScrollController().obs;
  final isExpanded = true.obs;

  // Add currentQuestionIndex for quiz navigation
  RxInt currentQuestionIndex = 0.obs;

  Future<void> fetchCourseData(int id, bool isBundle) async {
    isLoading(true);
    final res = await courseDataSource.getSingleCourseData(id, isBundle);
    res.fold(
      (l) {
        Get.back();
        ToastUtils.showError(l.message);
      },
      (r) async {
        singleCourseData(r);
        if (r.id != null) {
          await fetchCourseContent(r.id!);
          // await fetchCourseQuizzes(r.id!);
        }
      },
    );
  }

  Future<void> fetchCourseContent(int id) async {
    final res = await courseDataSource.fetchCourseContent(id.toString());

    log("response: $res");

    res.fold(
      (l) {
        ToastUtils.showError(l.message);
        Get.back();
      },
      (r) {
        courseContent(r);
        lessonsCount(fetchLessonsCount(r));
      },
    );
    isLoading(false);
  }

  Future<void> fetchCourseForum(int id) async {
    isForumLoading(true);

    final res = await courseDataSource.fetchCourseForum(id);

    res.fold(
      (l) {
        ToastUtils.showError("couldn'tfetchForm");
        isForumLoading(false);
      },
      (r) {
        forumPosts(r);
        isForumLoading(false);
      },
    );
  }

  Future<void> addPost(String title, String description, {File? file}) async {
    if (singleCourseData.value.id == null) {
      ToastUtils.showError("Course ID not available");
      return;
    }

    isLoading(true);
    log("Adding post: title=$title, description=$description, file=${file?.path}");

    final res = await courseDataSource.addPost(
      title,
      description,
      file,
      singleCourseData.value.id!,
    );

    res.fold(
      (l) {
        log("Addposterror");
        ToastUtils.showError("Failed to add post: ${l.message}");
        isLoading(false);
      },
      (r) {
        log("Addpostsuccess");
        ToastUtils.showSuccess("Addpostsuccess");

        final currentPosts = List<PostModel>.from(forumPosts);
        currentPosts.insert(0, r);
        forumPosts(currentPosts);
        forumPosts.refresh();
        isLoading(false);
      },
    );
  }

  Future<void> editPost(int postId, String title, String description) async {
    isLoading(true);
    log("Editing post: id=$postId, title=$title, description=$description");

    final res = await courseDataSource.editPost(title, description, postId);

    res.fold(
      (l) {
        log("Editposterror");
        ToastUtils.showError("Editposterror");
        isLoading(false);
      },
      (r) {
        log("Editpostsuccess");
        ToastUtils.showSuccess("Editpostsuccess");

        // Update the post in the list
        final currentPosts = List<PostModel>.from(forumPosts);
        final index = currentPosts.indexWhere((post) => post.id == postId);
        if (index != -1) {
          currentPosts[index] = r;
          forumPosts(currentPosts);
          forumPosts.refresh();
        }
        isLoading(false);
      },
    );
  }

  // Future<void> fetchCourseQuizzes(int id) async {
  //   final res = await courseDataSource.fetchCourseQuizzes(id);
  //
  //   log("response: $res");
  //
  //   res.fold(
  //     (l) {
  //       ToastUtils.showError(l.message);
  //       Get.back();
  //     },
  //     (r) {
  //       quiz(r);
  //       quizCount(fetchQuizCount(r));
  //     },
  //   );
  //   isLoading(false);
  // }

  Future<void> startQuiz(int quizId) async {
    isLoading(true);
    final res = await courseDataSource.startQuiz(quizId);
    res.fold(
      (l) {
        ToastUtils.showError(l.message);
      },
      (r) {
        quizDetailData.value = r;
        // Reset quiz state when starting a new quiz
        resetQuizState();
      },
    );
    isLoading(false);
  }

  /// Resets the quiz state - clears all answers and resets to first question
  void resetQuizState() {
    userAnswers.clear();
    currentQuestionIndex.value = 0;
  }

  int fetchLessonsCount(List<ContentModel> chapters) {
    return chapters.fold<int>(0, (total, chapter) {
      if (chapter.items == null) return total;
      return total +
          chapter.items!.fold<int>(
            0,
            (itemTotal, item) => itemTotal + 1 + (item.subLessons?.length ?? 0),
          );
    });
  }

  int fetchQuizCount(List<Quiz> quizzes) {
    return quizzes.length;
  }

  Future<void> purchaseCourseUsingIAP(int courseId) async {
    try {
      await RestApiService.post(ApiPaths.purchaseCourseViaPayment, {
        "course_id": courseId.toString(),
      });
      ToastUtils.showSuccess("تم شراء الدوره بنجاح");
    } catch (e) {
      ToastUtils.showSuccess("حدث خطا ما $e");
      logError(e);
    }
  }

  Future<QuizResultResponse?> submitQuiz() async {
    isLoading(true);
    if (quizDetailData.value == null) {
      ToastUtils.showError("Quiz data not available.");
      isLoading(false);
      return null;
    }

    final List<Map<String, dynamic>> answersPayload = [];

    for (final question in quizDetailData.value!.quiz.questions) {
      final questionId = question.id;
      final selectedAnswer = userAnswers[questionId];

      dynamic formattedAnswer;

      switch (question.type) {
        case 'multiple':
        case 'true_false':
          if (selectedAnswer != null) {
            formattedAnswer = selectedAnswer;
          }
          break;
        case 'drag_drop':
          if (selectedAnswer != null && selectedAnswer is Map<String, String>) {
            formattedAnswer = selectedAnswer;
          }
          break;
        case 'descriptive':
          if (selectedAnswer != null && selectedAnswer is String) {
            formattedAnswer = selectedAnswer;
          }
          break;
        default:
          formattedAnswer = null;
          break;
      }

      if (formattedAnswer != null) {
        answersPayload.add({
          "question_id": questionId,
          "answer": formattedAnswer,
        });
      }
    }

    // Get the quiz result ID from the quiz detail data
    final quizResultId = quizDetailData.value!.quizResultId;
    final quizId = quizDetailData.value!.quiz.id;

    final res = await courseDataSource.submitQuizResult(
      quizId,
      quizResultId,
      answersPayload,
    );

    isLoading(false);

    return res.fold(
      (l) {
        ToastUtils.showError(l.message);
        return null;
      },
      (r) {
        // ToastUtils.showSuccess(r.message);
        log('Quiz submission response: ${r.toJson()}');
        return r;
      },
    );
  }

  void updatePostLastAnswer(int postId, ForumAnswerModel updatedAnswer) {
    final currentPosts = List<PostModel>.from(forumPosts);
    final postIndex = currentPosts.indexWhere((post) => post.id == postId);

    if (postIndex != -1) {
      final post = currentPosts[postIndex];
      final updatedPost = PostModel(
        id: post.id,
        title: post.title,
        description: post.description,
        avatar: post.avatar,
        userName: post.userName,
        createdAt: post.createdAt,
        lastActivity: post.lastActivity,
        answersCount: post.answersCount,
        resolved: post.resolved,
        pin: post.pin,
        user: post.user,
        lastAnswer: PostLastAnswer(
          description: updatedAnswer.description,
          user: PostUser(
            id: updatedAnswer.user?.id,
            avatar: updatedAnswer.user?.avatar,
            fullName: updatedAnswer.user?.fullName,
          ),
        ),
        // activeUsers: post.activeUsers,
        more: post.more,
        can: post.can,
        attachment: post.attachment,
      );

      currentPosts[postIndex] = updatedPost;
      forumPosts(currentPosts);
      forumPosts.refresh();
    }
  }

  Future<void> fetchAllQuizResults(int quizId) async {
    isQuizResultsLoading(true);

    log("Fetching quiz results for quiz ID: $quizId");

    final res = await courseDataSource.allresult(quizId);

    res.fold(
      (failure) {
        log("fetchAllQuizResults error: ${failure.message}");
        ToastUtils.showError(
          "Failed to fetch quiz results: ${failure.message}",
        );
        isQuizResultsLoading(false);
      },
      (response) {
        log(
          "fetchAllQuizResults success: ${response.data.length} results found",
        );
        quizResults(response);
        isQuizResultsLoading(false);
      },
    );
  }

  // Helper method to get quiz results data
  List<QuizResultItem> get quizResultsList {
    return quizResults.value?.data ?? [];
  }

  // Helper method to check if quiz results are available
  bool get hasQuizResults {
    return quizResults.value != null && quizResults.value!.success;
  }

  // Helper method to get quiz results count
  int get quizResultsCount {
    return quizResultsList.length;
  }

  @override
  void onClose() {
    courseContent.clear();
    forumPosts.clear();
    singleCourseData.close();
    lessonsCount.close();
    isLoading.close();
    isForumLoading.close();
    isQuizResultsLoading.close();
    quizResults.close();
    scrollController.close();
    isExpanded.close();
    currentQuestionIndex.value = 0;
    super.onClose();
  }
}
