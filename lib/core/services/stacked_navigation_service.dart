import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StackedNavigationService {
  static void navigateToPush(BuildContext context, Widget route) =>
      Navigator.push(context, MaterialPageRoute(builder: (context) => route));

  static void navigateToReplacement(BuildContext context, Widget route) =>
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => route));

  static void navigatePop(BuildContext context) => Navigator.pop(context);

  static void navigateAndRemoveUntil(BuildContext context, Widget route) =>
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => route), (route) => false);

  static void navigatePopUntil(BuildContext context) =>
      Navigator.popUntil(context, (route) => false);

  static void exitApp() => SystemNavigator.pop(animated: true);
}
