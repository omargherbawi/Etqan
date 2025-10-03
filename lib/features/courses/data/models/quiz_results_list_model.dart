class QuizResultsListResponse {
  final bool success;
  final String status;
  final String message;
  final List<QuizResultItem> data;

  QuizResultsListResponse({
    required this.success,
    required this.status,
    required this.message,
    required this.data,
  });

  factory QuizResultsListResponse.fromJson(Map<String, dynamic> json) {
    return QuizResultsListResponse(
      success: json['success'] ?? false,
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => QuizResultItem.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'status': status,
      'message': message,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class QuizResultItem {
  final int id;
  final String quizTitle;
  final int userGrade;
  final int quizMark;
  final String status;
  final int createdAt;

  QuizResultItem({
    required this.id,
    required this.quizTitle,
    required this.userGrade,
    required this.quizMark,
    required this.status,
    required this.createdAt,
  });

  factory QuizResultItem.fromJson(Map<String, dynamic> json) {
    return QuizResultItem(
      id: json['id'] ?? 0,
      quizTitle: json['quiz_title'] ?? '',
      userGrade: json['user_grade'] ?? 0,
      quizMark: json['quiz_mark'] ?? 0,
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quiz_title': quizTitle,
      'user_grade': userGrade,
      'quiz_mark': quizMark,
      'status': status,
      'created_at': createdAt,
    };
  }

  // Helper methods for status checking
  bool get isWaiting => status == 'waiting';
  bool get isPassed => status == 'passed';
  bool get isFailed => status == 'failed';

  // Helper method to get formatted date
  DateTime get createdAtDateTime => DateTime.fromMillisecondsSinceEpoch(createdAt * 1000);

  // Helper method to calculate percentage
  double get gradePercentage {
    if (quizMark == 0) return 0.0;
    return (userGrade / quizMark) * 100;
  }

  // Helper method to check if passed (assuming 50% is passing grade)
  bool get hasPassedQuiz => gradePercentage >= 50.0;
}
