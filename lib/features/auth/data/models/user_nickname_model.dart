import '../../../../config/json_constants.dart';

class UserNicknameModel {
  final int? id;
  final String? title;
  final String? arTitle;
  final String? description;
  final String? arDescription;
  final String? quizTypeId;
  final String? logo;
  final String? logoUrl;

  UserNicknameModel({
    this.id,
    this.title,
    this.arTitle,
    this.description,
    this.arDescription,
    this.quizTypeId,
    this.logo,
    this.logoUrl,
  });

  factory UserNicknameModel.fromJson(Map<String, dynamic> json) {
    return UserNicknameModel(
      id: json[UserNickNameModelConstants.id],
      title: json[UserNickNameModelConstants.title],
      arTitle: json[UserNickNameModelConstants.arTitle],
      description: json[UserNickNameModelConstants.description],
      arDescription: json[UserNickNameModelConstants.arDescription],
      quizTypeId: json[UserNickNameModelConstants.quizTypeId],
      logo: json[UserNickNameModelConstants.logo],
      logoUrl: json[UserNickNameModelConstants.logoUrl],
    );
  }
}
