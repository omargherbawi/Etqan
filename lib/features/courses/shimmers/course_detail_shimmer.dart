// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../../core/utils/shared.dart';
import 'package:shimmer/shimmer.dart';

class CourseDetailShimmer extends StatelessWidget {
  const CourseDetailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Shimmer.fromColors(
                    baseColor: ShimmerConstants.baseColor,
                    highlightColor: ShimmerConstants.highlightColor,
                    child: Container(
                      width: double.infinity,
                      color: Colors.white,
                    ),
                  ),

                  // Play preview shimmer
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white.withOpacity(0.7),
                      ),
                      child: Shimmer.fromColors(
                        baseColor: ShimmerConstants.baseColor,
                        highlightColor: ShimmerConstants.highlightColor,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.play_circle,
                              color: Colors.black54,
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 100,
                              height: 16,
                              color: ShimmerConstants.baseColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Top icons shimmer
                  const Positioned(
                    top: 45,
                    left: 12,
                    right: 12,
                    child: Row(
                      children: [
                        CircleShimmer(),
                        Spacer(),
                        CircleShimmer(),
                        SizedBox(width: 5),
                        CircleShimmer(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 7,
              child: Shimmer.fromColors(
                baseColor: ShimmerConstants.baseColor,
                highlightColor: ShimmerConstants.highlightColor,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(25),
                      topLeft: Radius.circular(25),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 60,
                                  height: 20,
                                  color: ShimmerConstants.baseColor,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 16,
                                      height: 16,
                                      color: ShimmerConstants.baseColor,
                                    ),
                                    const SizedBox(width: 5),
                                    Container(
                                      width: 40,
                                      height: 16,
                                      color: ShimmerConstants.baseColor,
                                    ),
                                    const SizedBox(width: 3),
                                    Container(
                                      width: 80,
                                      height: 16,
                                      color: ShimmerConstants.baseColor,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Container(
                              width: double.infinity,
                              height: 24,
                              color: ShimmerConstants.baseColor,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: List.generate(
                                3,
                                (index) => Column(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      color: ShimmerConstants.baseColor,
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      width: 80,
                                      height: 16,
                                      color: ShimmerConstants.baseColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: 5,
                          itemBuilder:
                              (_, index) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                child: Container(
                                  width: double.infinity,
                                  height: 60,
                                  color: ShimmerConstants.baseColor,
                                ),
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Shimmer.fromColors(
        baseColor: ShimmerConstants.baseColor,
        highlightColor: ShimmerConstants.highlightColor,
        child: Container(
          height: 70,
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  width: 80,
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: ShimmerConstants.baseColor,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: ShimmerConstants.baseColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CircleShimmer extends StatelessWidget {
  const CircleShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: ShimmerConstants.baseColor,
      ),
    );
  }
}
