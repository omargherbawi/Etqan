import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Loader extends StatelessWidget {
  final Color? color;
  const Loader({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator.adaptive(
        backgroundColor: color ?? Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: Stack(
              children: [
                // Blur effect (optional)
                Container(
                  color: Colors.black.withValues(
                    alpha: 0.5,
                  ), // Overlay color with opacity
                  child: const Center(
                    child: LoadingAnimation(), // Loading indicator
                  ),
                ),
                // Uncomment below if you want a blur effect (requires flutter_blurhash package)
                // BlurHash(
                //   hash: 'LEHV6nWB9YUn5pD4s;0t5xX6fRkD6X6Q0', // Example hash, replace with your own
                //   imageFit: BoxFit.cover,
                // ),
              ],
            ),
          ),
      ],
    );
  }
}

class LoadingAnimation extends StatelessWidget {
  final Color? color;
  const LoadingAnimation({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    final spinkit = LoadingAnimationWidget.threeArchedCircle(
      color: color ?? Theme.of(context).colorScheme.primary,
      size: 30.w,
      // itemBuilder: (BuildContext context, int index) {
      //   return DecoratedBox(
      //     decoration: BoxDecoration(
      //       color: index.isEven ? SharedColors.primaryColor : Colors.black,
      //     ),
      //   );
      // },
    );
    return SizedBox(width: 30.w, child: spinkit);
  }
}
