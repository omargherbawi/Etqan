import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tedreeb_edu_app/config/app_colors.dart';
import 'package:tedreeb_edu_app/core/core.dart';
import 'package:tedreeb_edu_app/core/validators/file_validation.dart';

class FilesPickerService {
  static final ImagePicker _imagePicker = ImagePicker();
  static final FilePicker _filePicker = FilePicker.platform;

  static Future<String?> pickImage(BuildContext context) async {
    final ImageSource? source = await _showImageSourceModal(context);
    if (source != null) {
      return await _pickImageFromSource(source);
    }
    return null;
  }

  static Future<ImageSource?> _showImageSourceModal(
    BuildContext context,
  ) async {
    if (Platform.isIOS) {
      return await showCupertinoModalPopup<ImageSource>(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: const CustomTextWidget(
                  text: 'camera',
                  textThemeStyle: TextThemeStyleEnum.displayLarge,
                ),
                onPressed: () {
                  Navigator.of(context).pop(ImageSource.camera);
                },
              ),
              CupertinoActionSheetAction(
                child: const CustomTextWidget(
                  text: 'gallery',
                  textThemeStyle: TextThemeStyleEnum.displayLarge,
                ),
                onPressed: () {
                  Navigator.of(context).pop(ImageSource.gallery);
                },
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: const CustomTextWidget(
                text: 'cancel',
                color: SharedColors.redColor,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          );
        },
      );
    } else {
      return await showModalBottomSheet<ImageSource>(
        context: context,
        builder: (BuildContext context) {
          return Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.camera_alt,
                  color: Theme.of(context).primaryColor,
                ),
                title: const CustomTextWidget(text: 'camera'),
                onTap: () {
                  Navigator.of(context).pop(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.photo_library,
                  color: Theme.of(context).primaryColor,
                ),
                title: const CustomTextWidget(text: 'gallery'),
                onTap: () {
                  Navigator.of(context).pop(ImageSource.gallery);
                },
              ),
            ],
          );
        },
      );
    }
  }

  static Future<String?> _pickImageFromSource(ImageSource source) async {
    try {
      final XFile? takenPhoto = await _imagePicker.pickImage(
        source: source,
        maxHeight: 480,
        maxWidth: 640,
        imageQuality: 50,
      );

      if (takenPhoto != null) {
        final File pickedFile = File(takenPhoto.path);
        if (pickedFile.lengthSync() <= FilesValidations.maxImageSize) {
          return takenPhoto.path;
        } else {
          throw FileMaxSizeExceededException();
        }
      }
    } on PlatformException {
      openAppSettings();
    } catch (e) {
      return null;
    }
    return null;
  }

  static Future<List<String?>?> pickMultiFiles() async {
    final List<String?> files = [];
    try {
      final result = await _filePicker.pickFiles(
        allowMultiple: true,
        type: FileType.media,
      );
      if (result == null) {
        return null;
      }
      for (PlatformFile file in result.files) {
        if (FilesValidations.isImage(file.extension) &&
            file.size <= FilesValidations.maxImageSize) {
          files.add(file.path);
        } else if (FilesValidations.isVideo(file.extension) &&
            file.size <= FilesValidations.maxVideoSize) {
          files.add(file.path);
        } else {
          throw FileMaxSizeExceededException();
        }
      }
      return files;
    } on PlatformException {
      openAppSettings();
    } on FileMaxSizeExceededException {
      rethrow;
    } catch (e) {
      return null;
    }
    return null;
  }

  static Future<DateTime?> pickCupertinoDate(BuildContext context) async {
    DateTime initialDate = DateTime.now().subtract(
      const Duration(days: 365 * 5),
    );

    DateTime selectedDate = initialDate;

    return showModalBottomSheet<DateTime>(
      backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 300.h,
          child: Column(
            children: [
              Container(
                height: 50.h,
                color: Theme.of(context).bottomSheetTheme.backgroundColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop(selectedDate);
                        },
                        child: Text(
                          'choose'.tr(),
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoTheme(
                  data: CupertinoThemeData(
                    textTheme: CupertinoTextThemeData(
                      dateTimePickerTextStyle:
                          Theme.of(context).textTheme.displayMedium,
                    ),
                    primaryColor:
                        Theme.of(context).bottomSheetTheme.backgroundColor,
                    primaryContrastingColor:
                        Theme.of(context).bottomSheetTheme.backgroundColor,
                    barBackgroundColor:
                        Theme.of(context).bottomSheetTheme.backgroundColor,
                    scaffoldBackgroundColor:
                        Theme.of(context).bottomSheetTheme.backgroundColor,
                  ),
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    dateOrder: DatePickerDateOrder.dmy,
                    initialDateTime: initialDate,
                    onDateTimeChanged: (dateTime) {
                      selectedDate = dateTime;
                    },
                    maximumYear: DateTime.now().year - 5,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
