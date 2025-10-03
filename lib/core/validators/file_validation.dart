class FilesValidations {
  static int maxImageSize = 5 * 1024 * 1024;
  static int maxVideoSize = 25 * 1024 * 1024;

  static isImage(String? extension) {
    return extension!.toLowerCase().endsWith('png') ||
        extension.toLowerCase().endsWith('jpeg') ||
        extension.toLowerCase().endsWith('jpg') ||
        extension.toLowerCase().endsWith('bmp');
  }

  static bool isVideo(String? extension) {
    return extension!.toLowerCase().endsWith('mp4') ||
        extension.toLowerCase().endsWith('mov');
  }
}
