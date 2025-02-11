import 'package:get/get.dart';

import 'onboarding_controller.dart';

class OnboardingBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<OnboardingController>(OnboardingController());
  }
}
