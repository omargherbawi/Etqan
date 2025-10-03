import 'package:comment_tree/data/comment.dart';
import 'comment_tree_model.dart';

class PostModel extends Comment {
  final int? id;
  final String? title;
  final String? description;
  final String? avatar;
  final String? userName;
  final int? createdAt;
  final int? lastActivity;
  final int? answersCount;
  final bool? resolved;
  final bool? pin;
  final PostUser? user;
  final PostLastAnswer? lastAnswer;
  // final List<String>? activeUsers;
  final int? more;
  final PostCan? can;
  final String? attachment;

  PostModel({
    this.id,
    this.title,
    this.description,
    this.avatar,
    this.userName,
    this.createdAt,
    this.lastActivity,
    this.answersCount,
    this.resolved,
    this.pin,
    this.user,
    this.lastAnswer,
    // this.activeUsers,
    this.more,
    this.can,
    this.attachment,
  }) : super(
         avatar: avatar ?? '',
         userName: userName ?? '',
         content: description ?? '',
       );

  PostModel.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      title = json['title'],
      description = json['description'],
      avatar = json['user']?['avatar'],
      userName = json['user']?['full_name'],
      createdAt = json['created_at'],
      lastActivity = json['last_activity'],
      answersCount = json['answers_count'],
      resolved = json['resolved'],
      pin = json['pin'],
      user = json['user'] != null ? PostUser.fromJson(json['user']) : null,
      lastAnswer =
          json['last_answer'] != null
              ? PostLastAnswer.fromJson(json['last_answer'])
              : null,
      // activeUsers = json['active_users'] != null ? List<String>.from(json['active_users'].values) : null,
      more = json['more'],
      can = json['can'] != null ? PostCan.fromJson(json['can']) : null,
      attachment = json['attachment'],
      super(
        avatar: json['user']?['avatar'] ?? '',
        userName: json['user']?['full_name'] ?? '',
        content: json['description'] ?? '',
      );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'avatar': avatar,
      'userName': userName,
      'created_at': createdAt,
      'last_activity': lastActivity,
      'answers_count': answersCount,
      'resolved': resolved,
      'pin': pin,
      'user': user?.toJson(),
      'last_answer': lastAnswer?.toJson(),
      // 'active_users': activeUsers,
      'more': more,
      'can': can?.toJson(),
      'attachment': attachment,
    };
  }

  // Convert to CommentTreeModel for display (with only last answer as reply)
  CommentTreeModel toCommentTreeModel() {
    return CommentTreeModel(
      id: id?.toString(),
      content: title, // Use title as the main content
      avatar: avatar,
      userName: userName,
      createdAt: createdAt,
      replies:
          lastAnswer != null
              ? [
                CommentTreeModel(
                  id: 'last_answer',
                  content: lastAnswer!.description,
                  avatar: lastAnswer!.user?.avatar,
                  userName: lastAnswer!.user?.fullName,
                  createdAt: lastActivity,
                ),
              ]
              : null,
    );
  }

  // Get the full content (title + description) for display
  String get fullContent {
    if (title != null && description != null) {
      return '$title\n\n$description';
    } else if (title != null) {
      return title!;
    } else if (description != null) {
      return description!;
    }
    return '';
  }
}

class PostUser {
  final int? id;
  final String? avatar;
  final String? fullName;

  PostUser({this.id, this.avatar, this.fullName});

  PostUser.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      avatar = json['avatar'],
      fullName = json['full_name'];

  Map<String, dynamic> toJson() {
    return {'id': id, 'avatar': avatar, 'full_name': fullName};
  }
}

class PostLastAnswer {
  final String? description;
  final PostUser? user;

  PostLastAnswer({this.description, this.user});

  PostLastAnswer.fromJson(Map<String, dynamic> json)
    : description = json['description'],
      user = json['user'] != null ? PostUser.fromJson(json['user']) : null;

  Map<String, dynamic> toJson() {
    return {'description': description, 'user': user?.toJson()};
  }
}

class PostCan {
  final bool? pin;
  final bool? update;

  PostCan({this.pin, this.update});

  PostCan.fromJson(Map<String, dynamic> json)
    : pin = json['pin'],
      update = json['update'];

  Map<String, dynamic> toJson() {
    return {'pin': pin, 'update': update};
  }
}
