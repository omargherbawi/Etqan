import 'package:get/get.dart';
import 'package:etqan_edu_app/core/network/network_controller.dart';
import 'package:etqan_edu_app/core/services/analytics.service.dart';
import 'package:etqan_edu_app/core/services/header_provider.dart';
import 'package:etqan_edu_app/core/services/hive_services.dart';
import 'package:etqan_edu_app/features/account/data/datasources/account_remote_datasource.dart';
import 'package:etqan_edu_app/features/shared/data/datasources/shared_remote_datasources.dart';
import 'package:etqan_edu_app/features/shared/presentation/controllers/app_controller.dart';
import 'package:etqan_edu_app/features/shared/presentation/controllers/app_theme_controller.dart';
import 'package:etqan_edu_app/features/shared/presentation/controllers/bottom_nav_bar_controller.dart';
import 'package:etqan_edu_app/features/shared/presentation/controllers/current_user_controller.dart';
import 'package:etqan_edu_app/features/shared/presentation/controllers/shared_courses_controller.dart';

class DependencyInjection {
  static void init() {
    Get.lazyPut<AnalyticsService>(() => AnalyticsService());
    Get.put<HiveServices>(HiveServices(), permanent: true);

    Get.put<HeadersProvider>(HeadersProvider(hive: Get.find()));

    Get.put<AppController>(AppController(), permanent: true);
    Get.lazyPut<AnalyticsService>(() => AnalyticsService());

    Get.put<BottomNavController>(BottomNavController(), permanent: true);

    Get.put<NetworkController>(NetworkController(), permanent: true);

    Get.put<SharedRemoteDatasources>(
      SharedRemoteDatasources(),
      permanent: true,
    );

    Get.put<CurrentUserController>(CurrentUserController(), permanent: true);

    Get.put<ThemeController>(ThemeController(), permanent: true);

    Get.put<AccountRemoteDatasource>(
      AccountRemoteDatasource(),
      permanent: true,
    );

    Get.put<SharedCoursesController>(
      SharedCoursesController(),
      permanent: true,
    );

    // profile

    // Get.put<InAppReviewService>(InAppReviewService(), permanent: true);
  }
}
