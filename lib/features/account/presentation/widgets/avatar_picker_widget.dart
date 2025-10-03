import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/asset_paths.dart';
import '../../../../core/services/file_picker_service.dart';
import '../../../../core/widgets/custom_cached_image.dart';
import '../controllers/edit_account_controller.dart';
import '../../../shared/presentation/controllers/current_user_controller.dart';

class AvatarPickerWidget extends StatelessWidget {
  AvatarPickerWidget({super.key, this.width, this.height});

  final double? height;
  final double? width;
  final _userController = Get.find<CurrentUserController>();
  final _editAccountController = Get.find<EditAccountController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final avatarUrl = _userController.user?.avatar;
      final tempAvatarPath = _editAccountController.tempAvatarPath.value;
      return GestureDetector(
        onTap: () async {
          final selectedImage = await FilesPickerService.pickImage(context);
          if (selectedImage != null) {
            _editAccountController.updateTempAvatarPath(selectedImage);
          }
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: width ?? 100.w,
              height: height ?? 100.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              child:
              tempAvatarPath != null
                  ? ClipOval(
                child: Image.file(
                  File(tempAvatarPath),
                  fit: BoxFit.cover,
                ),
              )
                  : avatarUrl != null
                  ? ClipOval(
                child: CustomCachedImage(
                  image: avatarUrl,
                  fit: BoxFit.cover,
                ),
              )
                  : SvgPicture.asset(
                AssetPaths.personOutline,
                width: 40.w,
                fit: BoxFit.scaleDown,
              ),
            ),
            Positioned(
              bottom: 4,
              right: 4,
              child: GestureDetector(
                onTap:
                tempAvatarPath != null
                    ? () =>
                    _editAccountController.updateTempAvatarPath(null)
                    : null,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                    tempAvatarPath != null
                        ? SharedColors.redColor
                        : Theme.of(context).colorScheme.primary,
                  ),
                  width: 27.w,
                  height: 27.w,
                  child:
                  tempAvatarPath != null
                      ? SvgPicture.asset(
                    AssetPaths.edit,
                    height: 36.h,
                    width: 36.h,
                  )
                      : Icon(
                    tempAvatarPath != null
                        ? CupertinoIcons.delete
                        : avatarUrl != null
                        ? Icons.edit
                        : Icons.add,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
