import 'package:flutter/material.dart';
import '../../../../config/config.dart';
import '../../../../core/utils/color_utils.dart';

class CategoryModel {
  int? id;
  String? title;
  Color? color;
  String? icon;
  List<CategoryModel>? subCategories;
  int? webinarsCount;
  bool isOpen = false;

  CategoryModel({
    this.id,
    this.title,
    this.color,
    this.icon,
    this.subCategories,
    this.webinarsCount,
  });

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    color =
        json['color'] != null
            ? ColorUtils().hexToColor(json['color'])
            : AppLightColors.green77;
    icon = json['icon'];
    if (json['sub_categories'] != null) {
      subCategories = <CategoryModel>[];
      json['sub_categories'].forEach((v) {
        subCategories!.add(CategoryModel.fromJson(v));
      });
    }
    webinarsCount = json['webinars_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['color'] = color;
    data['icon'] = icon;
    if (subCategories != null) {
      data['sub_categories'] = subCategories!.map((v) => v.toJson()).toList();
    }
    data['webinars_count'] = webinarsCount;
    return data;
  }
}

List<CategoryModel> categories = <CategoryModel>[
  CategoryModel(
    id: 1,
    title: 'Art',
    color: AppLightColors.green77,
    icon: 'assets/icons/art_icon.svg',
    subCategories: <CategoryModel>[
      CategoryModel(
        id: 11,
        title: 'Painting',
        color: AppLightColors.green77,
        icon: 'assets/icons/painting_icon.svg',
      ),
      CategoryModel(
        id: 12,
        title: 'Drawing',
        color: AppLightColors.green77,
        icon: 'assets/icons/drawing_icon.svg',
      ),
      CategoryModel(
        id: 13,
        title: 'Sculpture',
        color: AppLightColors.green77,
        icon: 'assets/icons/sculpture_icon.svg',
      ),
    ],
  ),
  CategoryModel(
    id: 2,
    title: 'Coding',
    color: AppLightColors.green77,
    icon: 'assets/icons/coding_icon.svg',
    subCategories: <CategoryModel>[
      CategoryModel(
        id: 21,
        title: 'Web Development',
        color: AppLightColors.green77,
        icon: 'assets/icons/web_development_icon.svg',
      ),
      CategoryModel(
        id: 22,
        title: 'Mobile Development',
        color: AppLightColors.green77,
        icon: 'assets/icons/mobile_development_icon.svg',
      ),
      CategoryModel(
        id: 23,
        title: 'Game Development',
        color: AppLightColors.green77,
        icon: 'assets/icons/game_development_icon.svg',
      ),
    ],
  ),
  CategoryModel(
    id: 3,
    title: 'Marketing',
    color: AppLightColors.green77,
    icon: 'assets/icons/marketing_icon.svg',
    subCategories: <CategoryModel>[
      CategoryModel(
        id: 31,
        title: 'Digital Marketing',
        color: AppLightColors.green77,
        icon: 'assets/icons/digital_marketing_icon.svg',
      ),
      CategoryModel(
        id: 32,
        title: 'Content Marketing',
        color: AppLightColors.green77,
        icon: 'assets/icons/content_marketing_icon.svg',
      ),
      CategoryModel(
        id: 33,
        title: 'Social Media Marketing',
        color: AppLightColors.green77,
        icon: 'assets/icons/social_media_marketing_icon.svg',
      ),
    ],
  ),
  CategoryModel(
    id: 4,
    title: 'Business',
    color: AppLightColors.green77,
    icon: 'assets/icons/business_icon.svg',
    subCategories: <CategoryModel>[
      CategoryModel(
        id: 41,
        title: 'Entrepreneurship',
        color: AppLightColors.green77,
        icon: 'assets/icons/entrepreneurship_icon.svg',
      ),
      CategoryModel(
        id: 42,
        title: 'Finance',
        color: AppLightColors.green77,
        icon: 'assets/icons/finance_icon.svg',
      ),
      CategoryModel(
        id: 43,
        title: 'Management',
        color: AppLightColors.green77,
        icon: 'assets/icons/management_icon.svg',
      ),
    ],
  ),
  CategoryModel(
    id: 5,
    title: 'Photography',
    color: AppLightColors.green77,
    icon: 'assets/icons/photography_icon.svg',
    subCategories: <CategoryModel>[
      CategoryModel(
        id: 51,
        title: 'Portrait',
        color: AppLightColors.green77,
        icon: 'assets/icons/portrait_icon.svg',
      ),
      CategoryModel(
        id: 52,
        title: 'Landscape',
        color: AppLightColors.green77,
        icon: 'assets/icons/landscape_icon.svg',
      ),
      CategoryModel(
        id: 53,
        title: 'Wildlife',
        color: AppLightColors.green77,
        icon: 'assets/icons/wildlife_icon.svg',
      ),
    ],
  ),
  CategoryModel(
    id: 6,
    title: 'Design',
    color: AppLightColors.green77,
    icon: 'assets/icons/design_icon.svg',
    subCategories: <CategoryModel>[
      CategoryModel(
        id: 61,
        title: 'Graphic Design',
        color: AppLightColors.green77,
        icon: 'assets/icons/graphic_design_icon.svg',
      ),
      CategoryModel(
        id: 62,
        title: 'UI/UX Design',
        color: AppLightColors.green77,
        icon: 'assets/icons/ui_ux_design_icon.svg',
      ),
      CategoryModel(
        id: 63,
        title: 'Product Design',
        color: AppLightColors.green77,
        icon: 'assets/icons/product_design_icon.svg',
      ),
    ],
  ),
  CategoryModel(
    id: 7,
    title: 'Music',
    color: AppLightColors.green77,
    icon: 'assets/icons/music_icon.svg',
    subCategories: <CategoryModel>[
      CategoryModel(
        id: 71,
        title: 'Singing',
        color: AppLightColors.green77,
        icon: 'assets/icons/singing_icon.svg',
      ),
      CategoryModel(
        id: 72,
        title: 'Instrument',
        color: AppLightColors.green77,
        icon: 'assets/icons/instrument_icon.svg',
      ),
      CategoryModel(
        id: 73,
        title: 'Production',
        color: AppLightColors.green77,
        icon: 'assets/icons/production_icon.svg',
      ),
    ],
  ),
  CategoryModel(
    id: 8,
    title: 'Writing',
    color: AppLightColors.green77,
    icon: 'assets/icons/writing_icon.svg',
    subCategories: <CategoryModel>[
      CategoryModel(
        id: 81,
        title: 'Copywriting',
        color: AppLightColors.green77,
        icon: 'assets/icons/copywriting_icon.svg',
      ),
      CategoryModel(
        id: 82,
        title: 'Content Writing',
        color: AppLightColors.green77,
        icon: 'assets/icons/content_writing_icon.svg',
      ),
      CategoryModel(
        id: 83,
        title: 'Creative Writing',
        color: AppLightColors.green77,
        icon: 'assets/icons/creative_writing_icon.svg',
      ),
    ],
  ),
  CategoryModel(
    id: 9,
    title: 'Health & Fitness',
    color: AppLightColors.green77,
    icon: 'assets/icons/health_fitness_icon.svg',
    subCategories: <CategoryModel>[
      CategoryModel(
        id: 91,
        title: 'Yoga',
        color: AppLightColors.green77,
        icon: 'assets/icons/yoga_icon.svg',
      ),
      CategoryModel(
        id: 92,
        title: 'Gym',
        color: AppLightColors.green77,
        icon: 'assets/icons/gym_icon.svg',
      ),
      CategoryModel(
        id: 93,
        title: 'Nutrition',
        color: AppLightColors.green77,
        icon: 'assets/icons/nutrition_icon.svg',
      ),
    ],
  ),
  CategoryModel(
    id: 10,
    title: 'Cooking',
    color: AppLightColors.green77,
    icon: 'assets/icons/cooking_icon.svg',
    subCategories: <CategoryModel>[
      CategoryModel(
        id: 101,
        title: 'Baking',
        color: AppLightColors.green77,
        icon: 'assets/icons/baking_icon.svg',
      ),
      CategoryModel(
        id: 102,
        title: 'Cooking',
        color: AppLightColors.green77,
        icon: 'assets/icons/cooking_icon.svg',
      ),
      CategoryModel(
        id: 103,
        title: 'Beverages',
        color: AppLightColors.green77,
        icon: 'assets/icons/beverages_icon.svg',
      ),
    ],
  ),
];
