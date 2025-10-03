import '../../../../core/utils/console_log_functions.dart';
import '../../data/datasources/home_remote_datasource.dart';
import '../../data/models/file_model.dart';
import '../../../auth/data/models/user_model.dart';

import '../../data/models/filter_shared_model.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class FilesController extends GetxController {
  // loading & pagination
  RxBool isLoading = false.obs;
  RxList<FileModel> files = <FileModel>[].obs;
  RxInt currentPage = 1.obs;
  RxInt lastPage = 1.obs;
  RxBool isFetchingMore = false.obs;

  // filter state
  RxList<FilterSharedModel> programs = <FilterSharedModel>[].obs;
  RxList<FilterSharedModel> subCategories = <FilterSharedModel>[].obs;
  RxList<FilterSharedModel> classes = <FilterSharedModel>[].obs;

  RxList<FilterSharedModel> semesters = <FilterSharedModel>[].obs;
  RxList<FilterSharedModel> courses = <FilterSharedModel>[].obs;

  // instructor filter
  RxList<UserModel> instructors = <UserModel>[].obs;
  Rx<UserModel?> selectedInstructor = Rx<UserModel?>(null);
  RxBool isFetchingInstructors = false.obs;
  RxInt instructorCurrentPage = 1.obs;
  RxBool hasMoreInstructors = true.obs;

  // file type filter
  RxList<FilterSharedModel> fileTypes = <FilterSharedModel>[].obs;
  Rx<FilterSharedModel?> selectedFileType = Rx<FilterSharedModel?>(null);

  Rx<FilterSharedModel?> selectedProgram = Rx<FilterSharedModel?>(null);
  Rx<FilterSharedModel?> selectedClass = Rx<FilterSharedModel?>(null);
  Rx<FilterSharedModel?> selectedSemester = Rx<FilterSharedModel?>(null);
  Rx<FilterSharedModel?> selectedCourse = Rx<FilterSharedModel?>(null);

  // download tracking
  RxMap<int, double> downloadProgress = <int, double>{}.obs;
  RxMap<int, String> downloadedFiles = <int, String>{}.obs;

  final remoteDataSource = Get.find<HomeRemoteDatasource>();

  @override
  void onInit() {
    super.onInit();
    _loadPrograms();
    _loadFileTypes();
    fetchFiles();
  }

  /// 1. Fetch all programs
  Future<void> _loadPrograms() async {
    try {
      final resp = await remoteDataSource.fetchPrograms();
      programs.value =
          (resp)
              .map<FilterSharedModel>((e) => FilterSharedModel.fromJson(e))
              .toList();
    } catch (e, st) {
      logError('Error loading programs: $e\n$st');
    }
  }

  /// Load file types from backend
  Future<void> _loadFileTypes() async {
    try {
      final resp = await remoteDataSource.fetchFileTypes();
      fileTypes.value = resp
          .map<FilterSharedModel>((e) => FilterSharedModel(
                id: e['id'] as int,
                title: (e['name'] ?? '').toString(),
              ))
          .toList();
    } catch (e, st) {
      logError('Error loading file types: $e\n$st');
    }
  }

  /// 2/3/4. Generic loader for sub-categories (used for subCategories, classes, semesters)
  Future<List<FilterSharedModel>> _loadSubCategories(int parentId) async {
    final resp = await remoteDataSource.fetchSubCategories(parentId);
    return (resp)
        .map<FilterSharedModel>((e) => FilterSharedModel.fromJson(e))
        .toList();
  }

  void selectProgram(FilterSharedModel? program) {
    selectedProgram.value = program;
    // clear downstream
    subCategories.clear();
    classes.clear();
    semesters.clear();
    courses.clear();
    selectedClass.value = null;
    selectedSemester.value = null;
    selectedCourse.value = null;
    // Clear instructor selection when program changes
    selectedInstructor.value = null;

    // load next level
    if (program != null) {
      _loadSubCategories(program.id).then((list) => subCategories.value = list);
    }
  }

  void selectSubCategory(FilterSharedModel? subCat) {
    selectedClass.value = subCat;
    classes.clear();
    semesters.clear();
    courses.clear();
    selectedSemester.value = null;
    selectedCourse.value = null;
    // Clear instructor selection when subject changes
    selectedInstructor.value = null;

    if (subCat != null) {
      _loadSubCategories(subCat.id).then((list) => classes.value = list);
      // Fetch instructors based on the selected sub-category (class)
      fetchInstructors(subCategoryId: subCat.id);
    } else {
      // Clear instructors when no class is selected
      instructors.clear();
    }
  }

  void selectSemester(FilterSharedModel? sem) {
    selectedSemester.value = sem;
    semesters.clear();
    courses.clear();
    selectedCourse.value = null;

    if (sem != null) {
      _loadSubCategories(sem.id).then((list) => semesters.value = list);
    }
  }

  void selectCourse(FilterSharedModel? course) {
    selectedCourse.value = course;
    courses.clear();
    // no further loading
  }

  // Instructor methods
  Future<void> fetchInstructors({bool loadMore = false, int? subCategoryId}) async {
    if (isFetchingInstructors.value || !hasMoreInstructors.value) return;

    isFetchingInstructors.value = true;

    if (!loadMore) {
      instructorCurrentPage.value = 1;
      hasMoreInstructors.value = true;
      instructors.clear();
    }

    try {
      final res = await remoteDataSource.fetchAllInstructors(
        instructorCurrentPage.value,
        subCategoryId: subCategoryId,
      );
      res.fold(
        (l) {
          logError('Error fetching instructors: ${l.message}');
        },
        (r) {
          if (loadMore) {
            final newItems =
                r.data
                    .where(
                      (u) =>
                          !instructors.any((existing) => existing.id == u.id),
                    )
                    .toList();
            instructors.addAll(newItems);
          } else {
            instructors.assignAll(r.data);
          }

          if (r.pagination.nextPageUrl != null) {
            instructorCurrentPage.value++;
            hasMoreInstructors.value = true;
          } else {
            hasMoreInstructors.value = false;
          }
        },
      );
    } catch (e, st) {
      logError('Error fetching instructors: $e\n$st');
    } finally {
      isFetchingInstructors.value = false;
    }
  }

  void selectInstructor(UserModel? instructor) {
    selectedInstructor.value = instructor;
    // Clear file type when instructor changes
    selectedFileType.value = null;
  }

  void selectFileType(FilterSharedModel? fileType) {
    selectedFileType.value = fileType;
  }

  void loadMoreInstructors() {
    if (hasMoreInstructors.value && !isFetchingInstructors.value) {
      fetchInstructors(
        loadMore: true,
        subCategoryId: selectedClass.value?.id,
      );
    }
  }

  /// 5/6. Fetch files with optional filters
  Future<void> fetchFiles({int page = 1}) async {
    try {
      if (page == 1) isLoading.value = true;

      final params = <String, String>{
        'page': page.toString(),
        if (selectedProgram.value != null)
          'program_id': selectedProgram.value!.id.toString(),
        if (selectedClass.value != null)
          'class_id': selectedClass.value!.id.toString(),
        if (selectedSemester.value != null)
          'semester_id': selectedSemester.value!.id.toString(),
        if (selectedCourse.value != null)
          'course_id': selectedCourse.value!.id.toString(),
        if (selectedInstructor.value != null)
          'instructor_id': selectedInstructor.value!.id.toString(),
        if (selectedFileType.value != null) ...{
          // Prefer id when available; keep title for backward compatibility if needed
          'type_id': selectedFileType.value!.id.toString(),
        },
      };

      final response = await remoteDataSource.fetchFiles(
        page: page,
        filters: params,
      );
      final data = response['data']['webinars'];
      final filesList =
          (data['data'] as List).map((e) => FileModel.fromJson(e)).toList();

      if (page == 1) {
        files.value = filesList;
      } else {
        files.addAll(filesList);
      }
      currentPage.value = data['current_page'];
      lastPage.value = data['last_page'];
    } catch (e, st) {
      logError('Error fetching files: $e, $st');
    } finally {
      isLoading.value = false;
      isFetchingMore.value = false;
    }
  }

  void loadMore() {
    if (currentPage.value < lastPage.value && !isFetchingMore.value) {
      isFetchingMore.value = true;
      fetchFiles(page: currentPage.value + 1);
    }
  }

  Future<void> downloadFile(int index, String url, String fileName) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final filePath = "${dir.path}/$fileName";

      downloadProgress[index] = 0.0;

      final dio = Dio();
      await dio.download(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            downloadProgress[index] = received / total;
            downloadProgress.refresh();
          }
        },
      );

      downloadedFiles[index] = filePath;
      downloadedFiles.refresh();

      logSuccess("✅ File downloaded to $filePath");
    } catch (e, st) {
      logError("❌ Download failed: $e\n$st");
    } finally {
      downloadProgress.remove(index);
    }
  }
}
