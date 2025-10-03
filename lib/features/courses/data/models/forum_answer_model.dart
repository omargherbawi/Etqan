class ForumAnswerModel {
  final int? id;
  final String? description;
  final bool? pin;
  final bool? resolved;
  final ForumAnswerUser? user;
  final int? createdAt;
  final ForumAnswerCan? can;

  ForumAnswerModel({
    this.id,
    this.description,
    this.pin,
    this.resolved,
    this.user,
    this.createdAt,
    this.can,
  });

  ForumAnswerModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        description = json['description'],
        pin = json['pin'],
        resolved = json['resolved'],
        user = json['user'] != null ? ForumAnswerUser.fromJson(json['user']) : null,
        createdAt = json['created_at'],
        can = json['can'] != null ? ForumAnswerCan.fromJson(json['can']) : null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'pin': pin,
      'resolved': resolved,
      'user': user?.toJson(),
      'created_at': createdAt,
      'can': can?.toJson(),
    };
  }
}

class ForumAnswerUser {
  final int? id;
  final String? fullName;
  final String? avatar;
  final String? roleName;

  ForumAnswerUser({
    this.id,
    this.fullName,
    this.avatar,
    this.roleName,
  });

  ForumAnswerUser.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        fullName = json['full_name'],
        avatar = json['avatar'],
        roleName = json['role_name'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'avatar': avatar,
      'role_name': roleName,
    };
  }
}

class ForumAnswerCan {
  final bool? pin;
  final bool? resolve;
  final bool? update;

  ForumAnswerCan({
    this.pin,
    this.resolve,
    this.update,
  });

  ForumAnswerCan.fromJson(Map<String, dynamic> json)
      : pin = json['pin'],
        resolve = json['resolve'],
        update = json['update'];

  Map<String, dynamic> toJson() {
    return {
      'pin': pin,
      'resolve': resolve,
      'update': update,
    };
  }
}
