import 'signup_base_fields_model.dart';

class GovernorateModel extends SignupBaseFields {
  GovernorateModel({required super.id, super.arName, super.enName});

  factory GovernorateModel.fromJson(Map<String, dynamic> json) {
    return GovernorateModel(
      id: json['id'] as int,
      arName: json['ar_name'] ?? "",
      enName: json['en_name'] ?? "",
    );
  }
}
