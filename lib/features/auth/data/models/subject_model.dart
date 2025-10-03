import 'signup_base_fields_model.dart';

class ClassModel extends SignupBaseFields {
  final int? majorId;

  ClassModel({required super.id, super.arName, super.enName, this.majorId});

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['id'] as int,
      arName: json['ar_name'] ?? "",
      enName: json['en_name'] ?? "",
      majorId: json['major_id'],
    );
  }
}
