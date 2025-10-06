import 'package:etqan_edu_app/features/home/presentation/screens/point_of_sale_country_selection_screen.dart';
import 'package:get/get.dart';
import 'package:etqan_edu_app/core/routes/route_paths.dart';
import 'package:etqan_edu_app/features/account/bindings/account_edit_bindings.dart';
import 'package:etqan_edu_app/features/account/bindings/account_reset_password_binding.dart';
import 'package:etqan_edu_app/features/account/bindings/account_settings_bindings.dart';
import 'package:etqan_edu_app/features/account/bindings/categories_bindings.dart';
import 'package:etqan_edu_app/features/account/bindings/help_center_bindings.dart';
import 'package:etqan_edu_app/features/account/presentation/screens/account_categories_screen.dart';
import 'package:etqan_edu_app/features/account/presentation/screens/account_edit_screen.dart';
import 'package:etqan_edu_app/features/account/presentation/screens/account_reset_password_screen.dart';
import 'package:etqan_edu_app/features/account/presentation/screens/account_settings_screen.dart';
import 'package:etqan_edu_app/features/account/presentation/screens/help_center_screen.dart';
import 'package:etqan_edu_app/features/account/presentation/screens/privacy_policy_screen.dart';
import 'package:etqan_edu_app/features/auth/bindings/auth_binding.dart';
import 'package:etqan_edu_app/features/auth/presentation/screens/auth_signup_screen.dart';
import 'package:etqan_edu_app/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:etqan_edu_app/features/auth/presentation/screens/verify_otp_screen.dart';
import 'package:etqan_edu_app/features/courses/bindings/course_binding.dart';
import 'package:etqan_edu_app/features/courses/bindings/post_details_binding.dart';
import 'package:etqan_edu_app/features/courses/presentation/screens/best_rated_course_screen.dart';
import 'package:etqan_edu_app/features/courses/presentation/screens/continue_learning_screen.dart';
import 'package:etqan_edu_app/features/courses/presentation/screens/course_detail_screen.dart';
import 'package:etqan_edu_app/features/courses/presentation/screens/post_details_screen.dart';

import 'package:etqan_edu_app/features/home/bindings/home_bindings.dart';
import 'package:etqan_edu_app/features/home/presentation/screens/visitor_home_screen.dart';
import 'package:etqan_edu_app/features/home/presentation/widgets/all_mentore_screen.dart';

import 'package:etqan_edu_app/features/shared/bindings/notifications_bindings.dart';
import 'package:etqan_edu_app/features/shared/presentation/screens/nav_bar.dart';
import 'package:etqan_edu_app/features/shared/presentation/screens/notifications_screen.dart';
import 'package:etqan_edu_app/features/shared/presentation/screens/user_state_screen.dart';

import '../../features/auth/presentation/screens/auth_signin_screen.dart';

class AppRouter {
  static final List<GetPage> routes = [
    GetPage(name: RoutePaths.userState, page: () => const UserState()),
    GetPage(
      name: RoutePaths.visitor,
      page: () => const VisitorHomeScreen(),
      binding: HomeBindings(),
    ),
    GetPage(
      name: RoutePaths.navScreen,
      page: () => NavBar(),
      binding: HomeBindings(),
    ),
    GetPage(
      name: RoutePaths.allMentorScreen,
      page: () => const AllMentorScreen(),
    ),
    GetPage(
      name: RoutePaths.login,
      page: () => const AuthSigninScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: RoutePaths.signup,
      page: () => const AuthSignupScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: RoutePaths.verifyOtpScreen,
      page: () => const VerifyOtpScreen(),
    ),
    GetPage(
      name: RoutePaths.resetPasswordScreen,
      page: () => const ResetPasswordScreen(),
    ),
    GetPage(
      name: RoutePaths.settings,
      page: () => const AccountSettingsScreen(),
      binding: AccountBindings(),
    ),
    GetPage(
      name: RoutePaths.accountEdit,
      page: () => const AccountEditScreen(),
      binding: AccountEditBindings(),
    ),
    GetPage(
      name: RoutePaths.categories,
      page: () => const AccountCategoriesScreen(),
      binding: CategoriesBinding(),
    ),
    GetPage(
      name: RoutePaths.accountResetPassword,
      page: () => const AccountResetPasswordScreen(),
      binding: AccountResetPasswordBinding(),
    ),
    GetPage(
      name: RoutePaths.notifications,
      page: () => const NotificationsScreen(),
      binding: NotificationsBindings(),
    ),

    GetPage(
      name: RoutePaths.helpCenterSearch,
      page: () => const HelpCenterSearch(),
      binding: HelpCenterBinding(),
    ),
    GetPage(
      name: RoutePaths.privacyPolicyScreen,
      page: () => const PrivacyPolicyScreen(),
    ),
    GetPage(
      name: RoutePaths.courseDetailScreen,
      page: () => const CourseDetailScreen(),
      binding: CourseBindings(),
    ),
    GetPage(
      name: RoutePaths.bestRatedCourseScreen,
      page: () => const BestRatedCourseScreen(),
      binding: CourseBindings(),
    ),
    GetPage(
      name: RoutePaths.continueLearningScreen,
      page: () => const ContinueLearningScreen(),
      binding: CourseBindings(),
    ),
    GetPage(
      name: RoutePaths.postDetailsScreen,
      page: () => PostDetailsScreen(post: Get.arguments),
      binding: PostDetailsBinding(),
    ),

    GetPage(
      name: RoutePaths.chooseCountryPos,
      page: () => const PointOfSaleCountrySelectionScreen(),
    ),
  ];
}
