class CountryModel {
  final int id;
  final String title;
  final String arTitle;
  final String code;

  CountryModel({
    required this.id,
    required this.title,
    required this.arTitle,
    required this.code,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      id: json['id'],
      title: json['title'],
      arTitle: json['ar_title'],
      code: json['code'],
    );
  }
}
