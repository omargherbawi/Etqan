import 'can_model.dart';

class ContentModel {
  String? type;
  int? id;
  String? title;
  int? topicsCount;
  int? createdAt;
  int? checkAllContentsPass;
  List<ContentItem>? items;
  bool isOpen = false;

  ContentModel({
    this.type,
    this.id,
    this.title,
    this.topicsCount,
    this.createdAt,
    this.checkAllContentsPass,
    this.items,
  });

  ContentModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    title = json['title'];
    topicsCount = json['topics_count'];
    createdAt = json['created_at'];
    checkAllContentsPass = json['check_all_contents_pass'];

    final itemsJson = json['items'];
    if (itemsJson is List) {
      items =
          itemsJson
              .whereType<Map<String, dynamic>>()
              .map((v) => ContentItem.fromJson(v))
              .toList();
    } else {
      items = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['id'] = id;
    data['title'] = title;
    data['topics_count'] = topicsCount;
    data['created_at'] = createdAt;
    data['check_all_contents_pass'] = checkAllContentsPass;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ContentItem {
  Can? can;
  dynamic canViewError;
  bool? authHasRead;
  String? type;
  int? createdAt;
  String? link;
  int? id;
  String? title;
  String? fileType;
  String? storage;
  String? volume;
  String? videoUrl;
  String? videoLinkIframe;
  String? summary;
  int? downloadable;
  int? time;
  int? questionCount;
  int? date;
  int? accessAfterDay;
  int? checkPreviousParts;
  String? status;
  List<ContentItem>? subLessons;
  bool isOpen = false;

  ContentItem({
    this.can,
    this.canViewError,
    this.authHasRead,
    this.type,
    this.createdAt,
    this.link,
    this.id,
    this.title,
    this.fileType,
    this.storage,
    this.volume,
    this.videoUrl,
    this.downloadable,
    this.time,
    this.questionCount,
    this.date,
    this.accessAfterDay,
    this.checkPreviousParts,
    this.status,
    this.subLessons,
    this.isOpen = false,
  });

  ContentItem.fromJson(Map<String, dynamic> json) {
    can = json['can'] != null ? Can.fromJson(json['can']) : null;
    canViewError = json['can_view_error'];
    authHasRead = json['auth_has_read'] ?? false;
    type = json['type'];
    createdAt = json['created_at'];
    link = json['link'];
    id = json['id'];
    title = json['title'];
    fileType = json['file_type'];
    storage = json['storage'];
    volume = json['volume'];
    videoUrl = json['video_link'] ?? "";
    downloadable = json['downloadable'];
    time = json['time'];
    questionCount = json['question_count'];
    date = json['date'];
    summary = json['summary'];
    accessAfterDay = json['access_after_day'];
    checkPreviousParts = json['check_previous_parts'];
    status = json['status'];
    videoLinkIframe = json['video_link_iframe'];
    isOpen = false;

    final subItemsJson = json['sub_items'];
    if (subItemsJson is List) {
      subLessons =
          subItemsJson
              .whereType<Map<String, dynamic>>()
              .map((v) => ContentItem.fromJson(v))
              .toList();
    } else {
      subLessons = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (can != null) {
      data['can'] = can!.toJson();
    }
    data['can_view_error'] = canViewError;
    data['auth_has_read'] = authHasRead;
    data['type'] = type;
    data['created_at'] = createdAt;
    data['link'] = link;
    data['id'] = id;
    data['title'] = title;
    data['file_type'] = fileType;
    data['storage'] = storage;
    data['volume'] = volume;
    data['video_link'] = videoUrl;
    data['downloadable'] = downloadable;
    data['time'] = time;
    data['question_count'] = questionCount;
    data['date'] = date;
    data['summary'] = summary;
    data['access_after_day'] = accessAfterDay;
    data['check_previous_parts'] = checkPreviousParts;
    data['status'] = status;
    data['video_link_iframe'] = videoLinkIframe;
    data['isOpen'] = isOpen;
    if (subLessons != null) {
      data['sub_items'] = subLessons!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return 'ContentItem(title: $title, '
        'videoUrl: $videoUrl, '
        'videoLinkIframe: $videoLinkIframe, '
        'isOpen: $isOpen , '
        'subLessons: $subLessons, '
        'fileType: $fileType, '
        'id: $id, )';
  }
}
