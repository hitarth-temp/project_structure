import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../repository/local_repository/local_repository.dart';
import 'onboarding_model.dart';

class OnboardingController extends GetxController {
  final _localRepository = Get.find<LocalRepository>();

  // Variables
  PageController pageController = PageController(initialPage: 0);
  RxList<OnboardingModel> onboardingModelList =
      OnboardingModel.getOnboardingList().obs;
  RxInt activeIndex = 0.obs;

  // Methods

  /// page change
  void onPageChange({required int newIndex}) {
    if (newIndex == onboardingModelList.length) {
      onGetStarted();
      return;
    }

    activeIndex.value = newIndex;

    if (pageController.hasClients) {
      pageController.animateToPage(
        newIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    }
  }

  void onGetStarted() async {}
}
