class QuizDetailResponse {
  // final bool success;
  // final String status;
  // final String message;
  final QuizDetailData data;

  QuizDetailResponse({
    // required this.success,
    // required this.status,
    // required this.message,
    required this.data,
  });

  factory QuizDetailResponse.fromJson(Map<String, dynamic> json) {
    return QuizDetailResponse(
      // success: json['success'],
      // status: json['status'],
      // message: json['message'],
      data: QuizDetailData.fromJson(json['data']),
    );
  }
}

class QuizDetailData {
  final int quizResultId;
  final QuizDetail quiz;
  final int attemptNumber;
  // final String status;
  // final int userGrade;
  // final int createdAt;

  QuizDetailData({
    required this.quizResultId,
    required this.quiz,
    required this.attemptNumber,
    // required this.status,
    // required this.userGrade,
    // required this.createdAt,
  });

  factory QuizDetailData.fromJson(Map<String, dynamic> json) {
    return QuizDetailData(
      quizResultId: json['quiz_result_id'],
      quiz: QuizDetail.fromJson(json['quiz']),
      attemptNumber: json['attempt_number'],
      // status: json['status'],
      // userGrade: json['user_grade'],
      // createdAt: json['created_at'],
    );
  }
}

class QuizDetail {
  final int id;
  final String title;
  final int time;
  final String? attemptState;
  // final String authStatus;
  // final int questionCount;
  // final int totalMark;
  // final int passMark;
  // final String status;
  // final int attempt;
  // final UserModel teacher;
  // final WebinarInfo webinar;
  final List<Question> questions;
  // final List<UserModel> latestStudents;

  QuizDetail({
    required this.attemptState,
    required this.id,
    required this.title,
    required this.time,
    // required this.authStatus,
    // required this.questionCount,
    // required this.totalMark,
    // required this.passMark,
    // required this.status,
    // required this.attempt,
    // required this.teacher,
    // required this.webinar,
    required this.questions,
    // required this.latestStudents,
  });

  factory QuizDetail.fromJson(Map<String, dynamic> json) {
    return QuizDetail(
      attemptState: json['attempt_state'],
      id: json['id'],
      title: json['title'],
      time: json['time'],
      // authStatus: json['auth_status'],
      // questionCount: json['question_count'],
      // totalMark: json['total_mark'],
      // passMark: json['pass_mark'],
      // status: json['status'],
      // attempt: json['attempt'],
      // teacher: UserModel.fromJson(json['teacher']),
      // webinar: WebinarInfo.fromJson(json['webinar']),
      questions:
          (json['questions'] as List).map((q) => Question.fromJson(q)).toList(),
      // latestStudents: (json['latest_students'] as List)
      //     .map((s) => UserModel.fromJson(s))
      //     .toList(),
    );
  }
}

// class WebinarInfo {
//   final int id;
//   final String title;
//   final String? image;

//   WebinarInfo({required this.id, required this.title, this.image});

//   factory WebinarInfo.fromJson(Map<String, dynamic> json) {
//     return WebinarInfo(
//       id: json['id'],
//       title: json['title'],
//       image: json['image'],
//     );
//   }
// }

class Question {
  final int id;
  final String title;
  final String type;
  // final String grade;
  final List<Answer> answers;
  final Sentences? sentences;
  // final String? descriptiveCorrectAnswer;

  Question({
    required this.id,
    required this.title,
    required this.type,
    // required this.grade,
    required this.answers,
    this.sentences,
    // this.descriptiveCorrectAnswer,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      title: json['title'],
      type: json['type'],
      // grade: json['grade'],
      answers:
          (json['answers'] as List).map((a) => Answer.fromJson(a)).toList(),
      sentences:
          json['sentences'] != null
              ? Sentences.fromJson(json['sentences'])
              : null,
      // descriptiveCorrectAnswer: json['descriptive_correct_answer'],
    );
  }
}

class Answer {
  final int id;
  final String title;
  // final int correct;

  Answer({
    required this.id,
    required this.title,
    // required this.correct
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json['id'],
      title: json['title'],
      // correct: json['correct'],
    );
  }
}

class Sentences {
  final Map<String, SentenceDetail> sentenceMap;

  Sentences({required this.sentenceMap});

  factory Sentences.fromJson(Map<String, dynamic> json) {
    return Sentences(
      sentenceMap: json.map(
        (key, value) => MapEntry(key, SentenceDetail.fromJson(value)),
      ),
    );
  }
}

class SentenceDetail {
  final String sentence;
  final List<String?> displaySentence;

  SentenceDetail({required this.sentence, required this.displaySentence});

  factory SentenceDetail.fromJson(Map<String, dynamic> json) {
    return SentenceDetail(
      sentence: json['sentence'],
      displaySentence: List<String?>.from(
        json['display_sentence'].map((x) => x?.toString()),
      ),
    );
  }
}
