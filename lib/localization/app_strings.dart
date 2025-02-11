import '../core/enum/language_code.dart';

class AppStrings {
  static const String appName = "appName";
  static const String skip = "skip";
  static const String and = "and";
  static const String readMore = "read_more";
  static const String readLess = "read_less";
  static const String continueLabel = "continue";

  static const String okay = "okay";
  static const String cancel = "cancel";
  static const String upgrade = "upgrade";
  static const String later = "later";
  static const String noInternetConnection = "no_internet_connection";
  static const String sessionExpiredLoginAgain =
      "session_is_expired_please_login_again";
  static const String pleaseAllowThe = "please_allow_the";
  static const String camera = "camera";
  static const String gallery = "gallery";
  static const String permissionFromSettings = "permission_from_the_setting";
  static const String settings = "settings";
  static const String selectUploadOption = "select_upload_option";
  static const String takeAPhoto = "take_a_photo";
  static const String chooseFromGallery = "choose_from_gallery";
  static const String permission = "permission";
  static const String maximumImageSizeError =
      "sorry_maximum_image_size_should_be_2_mb";
  static const String uploadImageError =
      "please_upload_image_format_like_jpg_jpeg_png_etc";
  static const String enableLocationMessageIOS = "enableLocationMessageIOS";
  static const String locationIsDisabled = "locationIsDisabled";
  static const String pleaseEnableLocation = "pleaseEnableLocation";
  static const String noThanks = "noThanks";
  static const String locationPermission = 'locationPermission';
  static const String locationPermissionMsg = 'locationPermissionMsg';
}

class StringConstants {
  static const Map<LanguageCode, Map<String, String>> translations = {
    LanguageCode.en: {
      AppStrings.appName: "App Name",
      AppStrings.skip: "Skip",
      AppStrings.and: "and",
      AppStrings.readMore: "Read more",
      AppStrings.readLess: "Read less",
      AppStrings.continueLabel: "Continue",
      AppStrings.okay: "Okay",
      AppStrings.cancel: "Cancel",
      AppStrings.upgrade: "Upgrade",
      AppStrings.later: "Later",
      AppStrings.noInternetConnection:
          "No internet found. Check your connection or try again",
      AppStrings.sessionExpiredLoginAgain:
          "You've been logged out. Please log back in.",
      AppStrings.permission: 'Permission',
      AppStrings.pleaseAllowThe: 'Please allow the',
      AppStrings.camera: "Camera",
      AppStrings.gallery: "Gallery",
      AppStrings.permissionFromSettings: 'permission from the settings',
      AppStrings.settings: 'Settings',
      AppStrings.selectUploadOption: "Select Upload Option",
      AppStrings.takeAPhoto: "Take a photo",
      AppStrings.chooseFromGallery: "Choose from gallery",
      AppStrings.maximumImageSizeError:
          "Sorry! Maximum image size should be 2 MB.",
      AppStrings.uploadImageError:
          "Please upload image format like jpg, jpeg, png, heic, etc.",
      AppStrings.locationIsDisabled: "Location is Disabled",
      AppStrings.enableLocationMessageIOS:
          "To use location, go to Settings App > Privacy > Location Services.",
      AppStrings.pleaseEnableLocation:
          "Please enable location service from setting.",
      AppStrings.noThanks: "NO, THANKS",
      AppStrings.locationPermission: "Location permission",
      AppStrings.locationPermissionMsg:
          "Enable your location permission to explore nearby _.",
    },
    LanguageCode.ar: {},
    LanguageCode.fr: {},
  };
}
