class FileModel {
  final int? id;
  final int? creatorId;
  final int? webinarId;
  final int? chapterId;
  final String? accessibility;
  final int? downloadable;
  final String? storage;
  final String? file;
  final String? volume;
  final String? fileType;
  final String? secureHostUploadType;
  final String? interactiveType;
  final String? interactiveFileName;
  final String? interactiveFilePath;
  final int? checkPreviousParts;
  final int? accessAfterDay;
  final int? onlineViewer;
  final int? order;
  final String? status;
  final int? createdAt;
  final int? updatedAt;
  final int? deletedAt;
  final String? title;
  final String? description;
  final List<FileTranslationModel>? translations;

  FileModel({
    this.id,
    this.creatorId,
    this.webinarId,
    this.chapterId,
    this.accessibility,
    this.downloadable,
    this.storage,
    this.file,
    this.volume,
    this.fileType,
    this.secureHostUploadType,
    this.interactiveType,
    this.interactiveFileName,
    this.interactiveFilePath,
    this.checkPreviousParts,
    this.accessAfterDay,
    this.onlineViewer,
    this.order,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.title,
    this.description,
    this.translations,
  });

  factory FileModel.fromJson(Map<String, dynamic> json) {
    return FileModel(
      id: json['id'],
      creatorId: json['creator_id'],
      webinarId: json['webinar_id'],
      chapterId: json['chapter_id'],
      accessibility: json['accessibility'],
      downloadable: json['downloadable'],
      storage: json['storage'],
      file: json['file'],
      volume: json['volume'],
      fileType: json['file_type'],
      secureHostUploadType: json['secure_host_upload_type'],
      interactiveType: json['interactive_type'],
      interactiveFileName: json['interactive_file_name'],
      interactiveFilePath: json['interactive_file_path'],
      checkPreviousParts: json['check_previous_parts'],
      accessAfterDay: json['access_after_day'],
      onlineViewer: json['online_viewer'],
      order: json['order'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
      title: json['title'],
      description: json['description'],
      translations:
          (json['translations'] as List<dynamic>?)
              ?.map((e) => FileTranslationModel.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'creator_id': creatorId,
      'webinar_id': webinarId,
      'chapter_id': chapterId,
      'accessibility': accessibility,
      'downloadable': downloadable,
      'storage': storage,
      'file': file,
      'volume': volume,
      'file_type': fileType,
      'secure_host_upload_type': secureHostUploadType,
      'interactive_type': interactiveType,
      'interactive_file_name': interactiveFileName,
      'interactive_file_path': interactiveFilePath,
      'check_previous_parts': checkPreviousParts,
      'access_after_day': accessAfterDay,
      'online_viewer': onlineViewer,
      'order': order,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'title': title,
      'description': description,
      'translations': translations?.map((e) => e.toJson()).toList(),
    };
  }
}

class FileTranslationModel {
  final int? id;
  final int? fileId;
  final String? locale;
  final String? title;
  final String? description;

  FileTranslationModel({
    this.id,
    this.fileId,
    this.locale,
    this.title,
    this.description,
  });

  factory FileTranslationModel.fromJson(Map<String, dynamic> json) {
    return FileTranslationModel(
      id: json['id'],
      fileId: json['file_id'],
      locale: json['locale'],
      title: json['title'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'file_id': fileId,
      'locale': locale,
      'title': title,
      'description': description,
    };
  }
}
