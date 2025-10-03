class FilterSharedModel {
  final int id;
  final String title;

  FilterSharedModel({required this.id, required this.title});

  factory FilterSharedModel.fromJson(Map<String, dynamic> json) {
    String? title = json['title'];
    if (title == null &&
        json['translations'] != null &&
        json['translations'] is List &&
        (json['translations'] as List).isNotEmpty) {
      final translations = json['translations'] as List;
      final firstTranslation = translations.firstWhere(
        (t) => t['title'] != null,
        orElse: () => null,
      );
      title =
          firstTranslation != null ? firstTranslation['title'] as String : '';
    }
    return FilterSharedModel(id: json['id'] as int, title: title ?? '');
  }
}
