// ignore_for_file: non_constant_identifier_names

class Country {
  final String? name; // Country name in English
  final String? name_ar; // Country name in Arabic
  final String? dial_code; // Country dialing code
  final String? currency; // Country currency
  final String? iso2; // ISO2 code
  final String? iso3; // ISO3 code
  final bool? is_arabian_country; // Flag to check if the country is Arabian
  final bool? is_khaliji_country; // Flag to check if the country is Khaliji
  final String? flag; // Country flag emoji
  final int? order; // Order for sorting

  Country({
    this.name,
    this.name_ar,
    this.dial_code,
    this.currency,
    this.iso2,
    this.iso3,
    this.is_arabian_country,
    this.is_khaliji_country,
    this.flag,
    this.order,
  });

  // Factory constructor to convert from JSON to Country models
  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name'],
      name_ar: json['name_ar'],
      dial_code: json['dial_code'],
      currency: json['currency'],
      iso2: json['iso2'],
      iso3: json['iso3'],
      is_arabian_country: json['is_arabian_country'],
      is_khaliji_country: json['is_khaliji_country'],
      flag: json['flag'],
      order: json['order'],
    );
  }
}
