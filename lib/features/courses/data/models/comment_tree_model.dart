import 'package:comment_tree/data/comment.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../blogs/data/models/blog_model.dart';

class CommentTreeModel extends Comment {
  final String? id;
  final String? content;
  final String? avatar;
  final String? userName;
  final int? createdAt;
  final UserModel? user;
  final List<CommentTreeModel>? replies;

  CommentTreeModel({
    this.id,
    this.content,
    this.avatar,
    this.userName,
    this.createdAt,
    this.user,
    this.replies,
  }) : super(
          avatar: avatar ?? '',
          userName: userName ?? '',
          content: content ?? '',
        );

  CommentTreeModel.fromJson(Map<String, dynamic> json)
      : id = json['id']?.toString(),
        content = json['comment'] ?? json['content'],
        avatar = json['user']?['avatar'] ?? json['avatar'],
        userName = json['user']?['fullName'] ?? json['userName'],
        createdAt = json['create_at'] ?? json['createdAt'],
        user = json['user'] != null ? UserModel.fromJson(json['user']) : null,
        replies = json['replies'] != null
            ? (json['replies'] as List)
                .map((reply) => CommentTreeModel.fromJson(reply))
                .toList()
            : null,
        super(
          avatar: json['user']?['avatar'] ?? json['avatar'] ?? '',
          userName: json['user']?['fullName'] ?? json['userName'] ?? '',
          content: json['comment'] ?? json['content'] ?? '',
        );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'comment': content,
      'avatar': avatar,
      'userName': userName,
      'create_at': createdAt,
      'user': user?.toJson(),
      'replies': replies?.map((reply) => reply.toJson()).toList(),
    };
  }

  // Convert from existing Comments model
  factory CommentTreeModel.fromComments(Comments comment) {
    return CommentTreeModel(
      id: comment.id?.toString(),
      content: comment.comment,
      avatar: comment.user?.avatar,
      userName: comment.user?.fullName,
      createdAt: comment.createAt,
      user: comment.user,
      replies: comment.replies?.map((reply) => CommentTreeModel.fromReplies(reply)).toList(),
    );
  }

  // Convert from existing Replies model
  factory CommentTreeModel.fromReplies(Replies reply) {
    return CommentTreeModel(
      id: reply.id?.toString(),
      content: reply.comment,
      avatar: reply.user?.avatar,
      userName: reply.user?.fullName,
      createdAt: reply.createAt,
      user: reply.user,
    );
  }
}
