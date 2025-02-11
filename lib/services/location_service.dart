import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../core/utils/dialog_utils.dart';
import '../core/utils/loading_dialog.dart';

import '../core/themes/app_colors.dart';
import '../core/utils/app_logger.dart';

import '../core/widgets/app_button.dart';
import '../localization/app_strings.dart';

class LocationService {
  /// check location service and permission
  static Future<bool> checkLocationPermission() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      _openLocationSettingDialog();
      return false;
    }

    bool isPermissionGranted = await _askLocationPermission(
      whichPermission: 'Location',
    );
    logger.i('LOCATION PERMISSION: $isPermissionGranted');
    return isPermissionGranted;
  }

  /// get current address: lat, lng -- [Set as const global lat lng]
  static Future<void> getCurrentAddress() async {
    try {
      Get.context!.showLoading(feedback: "Fetching address");

      Position loc = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      logger.i("CURRENT LOCATION FETCHED");
      List<Placemark> placemarks =
          await placemarkFromCoordinates(loc.latitude, loc.longitude);

      if (placemarks[0].subLocality == '' || placemarks[0].locality == '') {
        // ValueConstants.displayAddress.value = placemarks[0].name!;
      } else {
        // ValueConstants.displayAddress.value = '${placemarks[0].subLocality}, ${placemarks[0].locality}';
      }

      Get.context!.hideLoading();
    } catch (e) {
      logger.e('EXCEPTION getCurrentAddress: ${e.toString()}');
      Get.context!.hideLoading();
    }
  }

  /// ask location permission
  static Future<bool> _askLocationPermission({
    String? whichPermission,
  }) async {
    LocationPermission permission = await Geolocator.checkPermission();
    bool isPermissionGranted = permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;

    if (isPermissionGranted) {
      return true;
    } else {
      LocationPermission permissionStatus =
          await Geolocator.requestPermission();
      logger.log('STATUS == $permissionStatus');
      if (permissionStatus == LocationPermission.deniedForever) {
        DialogUtils.showAdaptiveAppDialog(
          titleStr: AppStrings.permission.tr,
          message:
              '${AppStrings.pleaseAllowThe.tr} $whichPermission ${AppStrings.permissionFromSettings.tr}',
          positiveText: AppStrings.settings.tr,
          onPositiveTap: () {
            openAppSettings();
          },
          negativeText: AppStrings.cancel.tr,
          onNegativeTap: () {
            Get.back();
          },
        );
        return false;
      }
      if (permissionStatus == LocationPermission.always ||
          permissionStatus == LocationPermission.whileInUse) {
        return true;
      } else {
        return false;
      }
    }
  }

  /// location service dialog
  static void _openLocationSettingDialog() {
    Widget title = Text(
      AppStrings.locationIsDisabled.tr,
    );

    Widget contentAndroid = Text(
      AppStrings.pleaseEnableLocation.tr,
    );

    Widget contentIOS = Text(
      AppStrings.enableLocationMessageIOS.tr,
    );

    final actionsAndroid = <Widget>[
      TextButton(
        onPressed: () => Get.back(),
        child: Text(
          AppStrings.noThanks.tr,
        ),
      ),
      TextButton(
        onPressed: () async {
          Geolocator.openLocationSettings().then(
            (_) => Navigator.pop(Get.overlayContext!),
          );
        },
        child: Text(
          AppStrings.okay.tr,
        ),
      ),
    ];

    final actionsIOS = <Widget>[
      TextButton(
        onPressed: () => Get.back(),
        child: Text(
          AppStrings.cancel.tr,
        ),
      ),
    ];
    Future.delayed(
      const Duration(milliseconds: 200),
      () {
        showDialog(
          context: Get.overlayContext!,
          builder: (dialogContext) {
            return Platform.isIOS
                ? CupertinoAlertDialog(
                    title: title,
                    content: contentIOS,
                    actions: actionsIOS,
                  )
                : Theme(
                    data: ThemeData(useMaterial3: false),
                    child: AlertDialog(
                      title: contentAndroid,
                      actions: actionsAndroid,
                    ),
                  );
          },
        );
      },
    );
  }

  ///
  static Future<bool> checkLocationPermissionStatus() async {
    LocationPermission permission = await Geolocator.checkPermission();
    bool isPermissionGranted = permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;

    return isPermissionGranted;
  }

  /// location permission bottom sheet
  /*static Future<void> showLocationPermissionBottomSheet({
    required void Function(bool isSuccess) onAddressFetched,
    required bool allowLocationSheet,
  }) async {
    // permission granted and no address
    if (await LocationService.checkLocationPermissionStatus() &&
        AppConstant.currentLatitude.value == null) {
      logger.i("Getting current address");
      await LocationService.getCurrentAddress().then(
        (_) {
          onAddressFetched.call(true);
        },
      );
    }
    // permission not granted
    else {
      if (AppConstant.currentLatitude.value == null) {
        logger.i("Getting location permission from sheet");
        if (allowLocationSheet) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) async {
              _showBottomLocationSheet(
                onContinue: () async {
                  Get.back();

                  bool isPermissionGranted =
                      await LocationService.checkLocationPermission();

                  // set lat lng in constants
                  if (isPermissionGranted) {
                    await LocationService.getCurrentAddress().then(
                      (_) {
                        onAddressFetched.call(true);
                      },
                    );
                  } else {
                    onAddressFetched.call(false);
                  }
                },
              );
            },
          );
        } else {
          logger.i("show no location screen");
          onAddressFetched.call(false);
        }
      } else {
        logger.i("No address or permission -- returning false");
        onAddressFetched.call(false);
      }
    }
  }*/

  static void _showBottomLocationSheet({
    bool isDismissible = false,
    VoidCallback? onContinue,
  }) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      backgroundColor: AppColors.white,
      enableDrag: isDismissible,
      isDismissible: isDismissible,
      context: Get.context!,
      isScrollControlled: true,
      builder: (builder) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    width: 45,
                    height: 5,
                    color: const Color(0xffCCCCCC),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 16,
                      bottom: 24,
                    ),
                    child: Column(
                      children: [
                        // location icon
                        Image.asset(
                          "Assets.images.png.locationPinImage.path",
                          height: 100,
                          width: 100,
                        ),

                        // permission title
                        Text(
                          "${AppStrings.locationPermission.tr.capitalize}",
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 2),

                        Text(
                          AppStrings.locationPermissionMsg.tr,
                          textAlign: TextAlign.center,
                        ).paddingSymmetric(horizontal: 40),

                        const SizedBox(height: 16),

                        // continue button
                        AppButton(
                          onPressed: () {
                            onContinue?.call();
                          },
                          buttonText: AppStrings.continueLabel.tr,
                          buttonRadius: 16,
                        ),

                        const SizedBox(
                          height: 24,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
