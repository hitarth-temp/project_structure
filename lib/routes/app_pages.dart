import 'package:get/get.dart';

import '../pages/onboarding/onboarding_bindings.dart';
import '../pages/onboarding/onboarding_page.dart';
import '../pages/splash/splash_bindings.dart';
import '../pages/splash/splash_page.dart';

part 'app_routes.dart';

class AppPages {
  // initial route
  static String initialRoute = _Path.splash;
  static Bindings initialBinding = SplashBindings();

  static final List<GetPage<dynamic>> pages = [
    /// splash page
    GetPage(
      name: _Path.splash,
      page: () => const SplashPage(),
      binding: SplashBindings(),
    ),

    /// onboarding page
    GetPage(
      name: _Path.onboarding,
      page: () => const OnboardingPage(),
      binding: OnboardingBindings(),
    ),
  ];
}
