import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/enums/text_style_enum.dart';
import '../../../../core/utils/shared.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_widget.dart';
import '../../../../core/widgets/loader.dart';
import '../../../categories/presentation/controllers/category_controller.dart';

class AccountCategoriesScreen extends StatelessWidget {
  const AccountCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryController = Get.find<CategoryController>();

    return Scaffold(
      appBar: const CustomAppBar(title: "favCategories"),
      bottomNavigationBar: Obx(() {
        if (categoryController.isLoading.value) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
          child: CustomButton(
            onPressed: () {},
            child: CustomTextWidget(
              text: "saveFav",
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        );
      }),
      body: Obx(() {
        if (categoryController.isLoading.value == true) {
          return Center(
            child: LoadingAnimation(
              color: Theme.of(context).colorScheme.primary,
            ),
          );
        }

        return SingleChildScrollView(
          padding: UIConstants.mobileBodyPadding.copyWith(top: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomTextWidget(
                text: "chooseFavoriteCategories",
                textThemeStyle: TextThemeStyleEnum.titleSmall,
                maxLines: 2,
              ),
              const CustomTextWidget(
                text: "helpUsChoose",
                textThemeStyle: TextThemeStyleEnum.titleSmall,
                maxLines: 2,
              ),
              SizedBox(height: 50.h),
            ],
          ),
        );
      }),
    );
  }
}
