import 'package:get/get.dart';
import '../presentation/controllers/notifications_controller.dart';

class NotificationsBindings extends Bindings {
  @override
  void dependencies() => [
    Get.lazyPut<NotificationsController>(() => NotificationsController()),
  ];
}
