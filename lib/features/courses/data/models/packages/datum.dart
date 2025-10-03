class Datum {
  int? id;
  String? description;
  double? price;
  String? stringPrice;
  String? image;
  String? status;
  String? name;
  String? link;
  int? howMuchWebinarCanSelect;
  String? type;

  Datum({
    this.id,
    this.description,
    this.price,
    this.stringPrice,
    this.image,
    this.status,
    this.name,
    this.howMuchWebinarCanSelect,
    this.type,
    this.link,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json['id'] as int?,
    description: json['description'] as String?,
    price: (json['price'] as num?)?.toDouble(),
    image: json['image'] as String?,
    stringPrice: json['string_price'] as String?,
    status: json['status'] as String?,
    name: json['name'] as String?,
    howMuchWebinarCanSelect: json['how_much_webinar_can_select'] as int?,
    type: json['type'] as String?,
    link: json['link'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'description': description,
    'price': price,
    'image': image,
    'string_price': stringPrice,
    'status': status,
    'name': name,
    'how_much_webinar_can_select': howMuchWebinarCanSelect,
    'type': type,
    'link': link,
  };
}
