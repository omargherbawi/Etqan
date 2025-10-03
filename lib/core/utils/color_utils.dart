import 'dart:ui';

import 'package:get/get.dart';

class ColorUtils {
  static const Color primaryColor = Color.fromARGB(255, 255, 0, 191);

  Color hexToColor(String hexColor) {
    // Remove the '#' if present
    hexColor = hexColor.replaceAll('#', '');

    // Add 'FF' for full opacity if only RGB values are provided
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }

    // Parse the color value and use Color.fromARGB
    try {
      final int colorInt = int.parse(hexColor, radix: 16);
      return Color(colorInt);
    } catch (e) {
      // Return a default color if parsing fails
      return primaryColor;
    }
  }

  Color getColorFromRGBString(String rgbString) {
    if (rgbString.isEmpty) {
      return Get.theme.colorScheme.primary;
    }

    // Remove "rgb(" and ")" and split by comma
    List<String> values = rgbString
        .replaceAll("rgb(", "")
        .replaceAll(")", "")
        .split(",");
    // Parse each value and create a Color object
    int red = int.parse(values[0].trim());
    int green = int.parse(values[1].trim());
    int blue = int.parse(values[2].trim());
    return Color.fromRGBO(red, green, blue, 1.0);
  }
}
