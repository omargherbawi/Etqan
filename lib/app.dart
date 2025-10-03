import 'dart:async';
import 'dart:developer';

import 'package:app_links/app_links.dart';
import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tedreeb_edu_app/config/app_themes.dart';
import 'package:tedreeb_edu_app/core/routes/route_paths.dart';
import 'package:tedreeb_edu_app/core/routes/router.dart';
import 'package:tedreeb_edu_app/core/utils/prints.dart';
import 'package:tedreeb_edu_app/features/shared/presentation/screens/user_state_screen.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        Future.delayed(Duration.zero, () async {
          log("inactive app ");
        });
        break;
      case AppLifecycleState.resumed:
        Future.delayed(Duration.zero, () {
          log("resume app");
        });
        break;
      default:
        break;
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPersistentFrameCallback((timeStamp) async {});
    WidgetsBinding.instance.addObserver(this);
    initDeepLinks();

    super.initState();
  }

  @override
  Future<void> dispose() async {
    Future.delayed(Duration.zero, () async {});
    _linkSubscription?.cancel();

    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> initDeepLinks() async {
    _appLinks = AppLinks();

    // Handle links
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      printDebug('onAppLink: $uri');
      openAppLink(uri);
    });
  }

  void openAppLink(Uri uri) {
    Get.toNamed(uri.fragment);
  }

  final appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          initialRoute: RoutePaths.userState,
          getPages: AppRouter.routes,
          onGenerateRoute: (settings) {
            Widget routeWidget = const UserState();

            final routeName = settings.name;
            if (routeName != null) {
              // if (routeName.startsWith('/quiz/')) {
              //   // Navigated to /quiz/:id
              //   routeWidget = customScreen(
              //     routeName.substring(routeName.indexOf('/quiz/')),
              //   );
              // } else if (routeName == '/quiz') {
              //   // Navigated to /quiz without other parameters
              //   routeWidget = customScreen("None");
              // }
            }
            return MaterialPageRoute(
              builder: (context) => routeWidget,
              settings: settings,
              fullscreenDialog: true,
            );
          },
          localizationsDelegates: [
            ...context.localizationDelegates,
            CountryLocalizations.delegate,
          ],
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          debugShowCheckedModeBanner: false,
          title: 'tedreeb-تدريب',
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          themeMode: ThemeMode.light,
          builder: (context, child) {
            return Overlay(
              initialEntries: <OverlayEntry>[
                if (child != null)
                  OverlayEntry(
                    builder: (BuildContext ctx) {
                      return Stack(
                        children: [
                          MediaQuery(
                            data: MediaQuery.of(context).copyWith(
                              textScaler: const TextScaler.linear(1.0),
                            ),
                            child: child,
                          ),
                        ],
                      );
                    },
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
