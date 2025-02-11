import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../localization/app_strings.dart';
import '../enum/language_code.dart';
import 'app_logger.dart';
import 'dialog_utils.dart';

class AppMethods {
  /// `urlScheme`: "mailto" or "tel" (OPTIONAL)
  static Future<void> openLink({
    String urlPath = "",
    String urlScheme = "",
  }) async {
    Uri url;
    if (urlScheme != "") {
      url = Uri(scheme: urlScheme, path: urlPath);
    } else {
      if (urlPath.startsWith("http")) {
        url = Uri.parse(urlPath);
      } else {
        url = Uri.https(urlPath);
      }
    }

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
      } else {
        // todo: show snackbar
      }
    } catch (e) {
      debugPrint("ERROR open link: $e");
    }
  }

  /// Get platform details
  static String getPlatformDevice() {
    if (Platform.isIOS) {
      return "ios";
    } else if (Platform.isAndroid) {
      return "android";
    } else {
      return "unknown";
    }
  }

  /// Get converted date
  static String getConvertedDate({
    String? inputDateFormat,
    String? outputDateFormat = "yyyy-MM-dd",
    String? date,
  }) {
    if (date == null || date.isEmpty) {
      return "";
    }
    try {
      String locale = Get.locale?.languageCode ?? LanguageCode.en.name;

      DateTime inputDate = DateFormat(inputDateFormat, locale).parse(date);

      String dateFormat =
          DateFormat(outputDateFormat, locale).format(inputDate);
      return dateFormat;
    } catch (exception) {
      logger.e("getConvertedDate:$exception");
      return "";
    }
  }

  /// android sdk version
  static Future<int> getAndroidVersion() async {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidDeviceInfo =
          await DeviceInfoPlugin().androidInfo;
      logger.i(
        "androidDeviceInfo.version.sdkInt: ${androidDeviceInfo.version.sdkInt}",
      );
      return androidDeviceInfo.version.sdkInt;
    } else {
      return 0;
    }
  }

  /// permission
  static Future<bool> askPermission({
    Permission? permission,
    String? whichPermission,
  }) async {
    bool isPermissionGranted = await permission!.isGranted;
    var shouldShowRequestRationale =
        await permission.shouldShowRequestRationale;

    if (isPermissionGranted) {
      return true;
    } else {
      if (!shouldShowRequestRationale) {
        var permissionStatus = await permission.request();
        logger.e("STATUS == $permissionStatus");
        if (permissionStatus.isPermanentlyDenied) {
          DialogUtils.showAdaptiveAppDialog(
            titleStr: AppStrings.permission.tr,
            message:
                '${AppStrings.pleaseAllowThe.tr} $whichPermission ${AppStrings.permissionFromSettings.tr}',
            positiveText: AppStrings.settings.tr,
            onPositiveTap: () {
              openAppSettings();
            },
            negativeText: AppStrings.cancel.tr,
            onNegativeTap: () {},
          );
          return false;
        }
        if (permissionStatus.isGranted || permissionStatus.isLimited) {
          return true;
        } else {
          return false;
        }
      } else {
        var permissionStatus = await permission.request();
        if (permissionStatus.isGranted || permissionStatus.isLimited) {
          return true;
        } else {
          return false;
        }
      }
    }
  }

  /// Check image size
  static Future<bool> imageSize(XFile file) async {
    final bytes = (await file.readAsBytes()).lengthInBytes;
    final kb = bytes / 1024;
    final mb = kb / 1024;

    logger.log("IMAGE SIZE ----$mb");

    if (mb <= 2) {
      return true;
    } else {
      return false;
    }
  }
}
