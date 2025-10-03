class Quiz {
  int? id;
  String? title;
  String? image;
  int? time;
  int? questionCount;
  int? totalMark;

  String? questionTypes;

  Quiz({
    this.id,
    this.title,
    this.time,
    this.questionCount,
    this.totalMark,
    this.questionTypes,
    this.image,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) => Quiz(
    id: json['id'] as int?,
    title: json['title'] as String?,
    image: json['image'] as String?,
    time: json['time'] as int?,
    questionCount: json['question_count'] as int?,
    totalMark: json['total_mark'] as int?,
    questionTypes: json['question_types'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'time': time,
    'image': image,
    'question_count': questionCount,
    'total_mark': totalMark,
    'question_types': questionTypes,
  };
}
