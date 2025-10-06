import 'package:etqan_edu_app/core/enums/course_type_enum.dart';

import '../../features/courses/data/models/course_model.dart';

class CourseUtils {
  static CourseType checkType(CourseModel course) {
    switch (course.type) {
      case 'webinar':
        return CourseType.live;

      case 'course':
        return CourseType.video;

      case 'text_lesson':
        return CourseType.text;

      default:
        return CourseType.video;
    }
  }
}
