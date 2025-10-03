import 'package:cached_network_image_plus/flutter_cached_network_image_plus.dart';

import 'package:flutter/material.dart';

class CustomCachedImage extends StatelessWidget {
  final String image;
  final double? height;
  final double? width;
  final BoxFit fit;
  final List<BoxShadow>? boxShadow;

  final BorderRadius? borderRadius;
  final Color? backgroundColor;

  const CustomCachedImage({
    super.key,
    required this.image,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.backgroundColor,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return CacheNetworkImagePlus(
      imageUrl: image,

      borderRadius: borderRadius,
      boxShadow: boxShadow,
      color: backgroundColor,
      boxFit: fit,
      errorWidget: Container(
        height: height,
        width: width,
        color: Colors.grey[200],
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.warning_rounded, color: Colors.red, size: 40),
            Text("لا يمكن عرض الصور في الوقت الحالي",textAlign: TextAlign.center,),
          ],
        ),
      ),
    );
  }
}
