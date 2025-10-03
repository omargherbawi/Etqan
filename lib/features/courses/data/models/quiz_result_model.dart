class QuizResultResponse {
  final bool success;
  final String status;
  final String message;
  final QuizResultData data;

  QuizResultResponse({
    required this.success,
    required this.status,
    required this.message,
    required this.data,
  });

  factory QuizResultResponse.fromJson(Map<String, dynamic> json) {
    return QuizResultResponse(
      success: json['success'] ?? false,
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: QuizResultData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'status': status,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class QuizResultData {
  final dynamic result; // Can be text, number, or null
  final int? userGrade;
  final String? status;
  final int? passMark;

  QuizResultData({
    required this.result,
    this.userGrade,
    this.status,
    this.passMark,
  });

  factory QuizResultData.fromJson(Map<String, dynamic> json) {
    return QuizResultData(
      result: json['result'], // Keep as dynamic to handle any type
      userGrade: json['user_grade'],
      status: json['status'],
      passMark: json['pass_mark'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'user_grade': userGrade,
      'status': status,
      'pass_mark': passMark,
    };
  }

  // Helper methods to check result type
  bool get hasResult => result != null;
  
  bool get isString => result is String;
  
  bool get isNumber => result is num;
  
  String get resultAsString => result?.toString() ?? '';
  
  num? get resultAsNumber {
    if (result is num) return result as num;
    if (result is String) return num.tryParse(result as String);
    return null;
  }

  // Helper methods for new fields
  bool get isPassed => status == 'passed';
  bool get isFailed => status == 'failed';
  bool get isWaiting => status == 'waiting';
}
