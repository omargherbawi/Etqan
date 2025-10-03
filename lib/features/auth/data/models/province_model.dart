class ProvinceModel {
  final int? id;
  final int? countryId;
  final int? provinceId;
  final int? cityId;
  final String? type;
  final String? title;
  final String? arTitle;
  final int? createdAt;
  final String? code;
  final String? countryCurrency;

  ProvinceModel({
    this.id,
    this.countryId,
    this.provinceId,
    this.cityId,
    this.type,
    this.title,
    this.arTitle,
    this.createdAt,
    this.code,
    this.countryCurrency,
  });

  factory ProvinceModel.fromJson(Map<String, dynamic> json) => ProvinceModel(
    id: json['id'] ?? 0,
    countryId: json['country_id'] ?? 0,
    provinceId: json['province_id'] ?? 0,
    cityId: json['city_id'] ?? 0,
    type: json['type'] ?? "",
    title: json['title'] ?? "",
    arTitle: json['ar_title'] ?? "",
    createdAt: json['created_at'] ?? 0,
    code: json['code'] ?? "",
    countryCurrency: json['country_currency'] ?? "",
  );
}
