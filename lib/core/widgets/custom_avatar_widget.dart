import 'package:etqan_edu_app/core/widgets/custom_cached_image.dart';
import 'package:flutter/material.dart';

import '../../config/asset_paths.dart';

class CustomAvatarWidget extends StatelessWidget {
  final String? imageUrl;
  final double height;
  final double width;

  const CustomAvatarWidget({
    super.key,
    required this.imageUrl,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child:
          imageUrl == null
              ? Image.asset(AssetPaths.student)
              : CustomCachedImage(image: imageUrl!),
    );
  }
}
