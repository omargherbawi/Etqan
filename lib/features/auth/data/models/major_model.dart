import 'signup_base_fields_model.dart';

class ProgramModel extends SignupBaseFields {
  ProgramModel({required super.id, super.arName, super.enName});

  factory ProgramModel.fromJson(Map<String, dynamic> json) {
    return ProgramModel(
      id: json['id'] as int,
      arName: json['ar_name'] ?? "",
      enName: json['en_name'] ?? "",
    );
  }
}
