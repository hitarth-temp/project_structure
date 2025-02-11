import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../core/themes/app_colors.dart';
import '../../core/themes/text_styles.dart';
import '../../localization/app_strings.dart';
import 'onboarding_controller.dart';

class OnboardingPage extends GetView<OnboardingController> {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Expanded Skip Button and Image
            Expanded(
              child: Column(
                children: [
                  // Skip button
                  Obx(
                    () => Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Visibility(
                        visible: controller.activeIndex.value !=
                            controller.onboardingModelList.length - 1,
                        maintainState: true,
                        maintainSize: true,
                        maintainAnimation: true,
                        child: Align(
                          alignment: AlignmentDirectional.topEnd,
                          child: InkWell(
                            onTap: () => controller.onGetStarted(),
                            child: Text(
                              AppStrings.skip.tr,
                              style: TextStyles.textSmMedium,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Image or Lottie Animation
                  Expanded(
                    child: Image.asset(
                      "Assets.video.onboardingSlider.path",
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),

            // Bottom: PageView and Indicators
            _bottomContainerWithPageView(context),
          ],
        ),
      ),
    );
  }

  /// page view
  Widget _bottomContainerWithPageView(BuildContext context) {
    return Obx(
      () => Container(
        padding:
            const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 24),
        constraints: BoxConstraints(
          maxHeight:
              MediaQuery.of(context).size.height * 0.4, // Constrain height
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // PageView with constrained height
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.23, // Fixed height
              child: PageView.builder(
                controller: controller.pageController,
                itemCount: controller.onboardingModelList.length,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        controller.onboardingModelList[index].title,
                        style: TextStyles.displayXsMedium,
                      ),

                      const SizedBox(height: 16),

                      // Description
                      Text(
                        controller.onboardingModelList[index].description,
                        style: TextStyles.textLgRegular.copyWith(
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  );
                },
                onPageChanged: (value) {
                  controller.onPageChange(newIndex: value);
                },
              ),
            ),

            const SizedBox(height: 16),

            // Indicators and Button Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Indicators
                Row(
                  children: _indicatorList(
                    indicatorLength: controller.onboardingModelList.length,
                    activeIndex: controller.activeIndex.value,
                  ),
                ),

                // Next or Get Started Button
                InkWell(
                  onTap: () {
                    controller.onPageChange(
                      newIndex: controller.activeIndex.value + 1,
                    );
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Ink(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: controller.activeIndex.value ==
                              controller.onboardingModelList.length - 1
                          ? Text(
                              "AppStrings.getStarted.tr",
                              style: TextStyles.textMdMedium.copyWith(
                                color: AppColors.white,
                              ),
                            )
                          : SvgPicture.asset(
                              "",
                              fit: BoxFit.scaleDown,
                              matchTextDirection: true,
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Indicator list
  List<Widget> _indicatorList({
    required int indicatorLength,
    required int activeIndex,
  }) {
    return List.generate(
      indicatorLength,
      (index) {
        if (index == activeIndex) {
          return Container(
            width: 32,
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(100),
            ),
          ).paddingSymmetric(horizontal: 2);
        } else {
          return Container(
            height: 8,
            width: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(),
            ),
          ).paddingSymmetric(horizontal: 2);
        }
      },
    );
  }
}
