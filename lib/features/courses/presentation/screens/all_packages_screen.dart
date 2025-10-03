import '../../../../core/widgets/custom_appbar.dart';
import '../widgets/package_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/presentation/controllers/shared_courses_controller.dart';

class AllPackagesScreen extends StatelessWidget {
  const AllPackagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SharedCoursesController controller = Get.find();

    return Scaffold(
      appBar: const CustomAppBar(title: 'pakages'),
      body: Obx(() {
        final packages = controller.packages;

        if (packages.isEmpty) {
          return Center(child: Text(tr('noPackagesYet')));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: packages.length,
          itemBuilder: (context, index) {
            final pkg = packages[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: PackageCard(package: pkg),
            );
          },
        );
      }),
    );
  }
}
