import 'package:get/get.dart';
import '../../../../core/services/hive_services.dart';
import '../../../courses/data/models/course_model.dart';

class LastOpenedCourseController extends GetxController {
  final hiveServices = Get.find<HiveServices>();
  
  final Rxn<CourseModel> lastOpenedCourse = Rxn<CourseModel>();

  @override
  void onInit() {
    super.onInit();
    loadLastOpenedCourse();
  }

  void loadLastOpenedCourse() {
    final lastCourseData = hiveServices.getLastOpenedCourse();
    
    if (lastCourseData != null) {
      try {
        // Deep convert all nested maps to Map<String, dynamic>
        final cleanedData = _deepConvertMap(lastCourseData);
        lastOpenedCourse.value = CourseModel.fromJson(cleanedData);
      } catch (e) {
        lastOpenedCourse.value = null;
      }
    } else {
      lastOpenedCourse.value = null;
    }
  }

  Map<String, dynamic> _deepConvertMap(Map<String, dynamic> map) {
    final result = <String, dynamic>{};
    map.forEach((key, value) {
      if (value is Map) {
        result[key] = _deepConvertMap(Map<String, dynamic>.from(value));
      } else {
        result[key] = value;
      }
    });
    return result;
  }

  void refresh() {
    loadLastOpenedCourse();
  }
}

