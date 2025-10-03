import '../presentation/controllers/settings_controller.dart';
import 'package:get/get.dart';

class AccountBindings extends Bindings {
  @override
  void dependencies() => [
    Get.lazyPut<SettingsController>(() => SettingsController()),
  ];
}
