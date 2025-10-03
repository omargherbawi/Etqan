class PointOfSaleModel {
  final int id;
  final String? name;
  final String? latitude;
  final String? longitude;
  final String? address;
  final String? phoneNumber;

  PointOfSaleModel({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.phoneNumber,
  });

  factory PointOfSaleModel.fromJson(Map<String, dynamic> json) {
    return PointOfSaleModel(
      id: json['id'],
      name: json['name'] ?? "",
      latitude: json['latitude'] ?? "",
      longitude: json['longitude'] ?? "",
      address: json['address'] ?? "",
      phoneNumber: json['phone_number'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'phone_number': phoneNumber,
    };
  }

  PointOfSaleModel copyWith({
    int? id,
    String? name,
    String? latitude,
    String? longitude,
    String? address,
    String? phoneNumber,
  }) {
    return PointOfSaleModel(
      id: id ?? this.id,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}
