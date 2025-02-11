class OnboardingModel {
  final String imgPath;
  final String title;
  final String description;
  bool isActive;

  OnboardingModel({
    required this.imgPath,
    required this.title,
    required this.description,
    this.isActive = false,
  });

  static List<OnboardingModel> getOnboardingList() {
    return [
      OnboardingModel(
        imgPath: "Assets.images.png.onboardingImg1.path",
        title: "AppStrings.onboardingTitle1.tr",
        description: "AppStrings.onboardingDesc1.tr",
        isActive: true,
      ),
      OnboardingModel(
        imgPath: "Assets.images.png.onboardingImg2.path",
        title: "AppStrings.onboardingTitle2.tr",
        description: "AppStrings.onboardingDesc2.tr",
      ),
      OnboardingModel(
        imgPath: "Assets.images.png.onboardingImg3.path",
        title: "AppStrings.onboardingTitle3.tr",
        description: "AppStrings.onboardingDesc3.tr",
      ),
    ];
  }
}
