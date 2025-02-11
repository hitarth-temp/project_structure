import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../localization/app_strings.dart';
import '../themes/app_colors.dart';
import '../themes/text_styles.dart';

class DialogUtils {
  // alert dialog
  static void showAdaptiveAppDialog({
    required String message,
    required String titleStr,
    String? positiveText,
    String? negativeText,
    VoidCallback? onPositiveTap,
    VoidCallback? onNegativeTap,
  }) {
    Widget content = Text(
      message,
      style: TextStyles.textMdRegular.copyWith(color: AppColors.black),
    );
    Widget title = Text(titleStr, style: TextStyles.displayXsMedium);
    final actions = <Widget>[
      if (negativeText != null) ...[
        TextButton(
          onPressed: () {
            Get.back();
            onNegativeTap!.call();
          },
          child: Text(
            negativeText,
            style: TextStyles.textLgMedium.copyWith(color: AppColors.primary),
          ),
        ),
      ],
      TextButton(
        onPressed: () {
          Get.back();
          onPositiveTap!.call();
        },
        child: Text(
          positiveText!,
          style: TextStyles.textLgMedium.copyWith(color: AppColors.primary),
        ),
      ),
    ];
    showDialog(
      context: Get.overlayContext!,
      barrierDismissible: false,
      builder: (dialogContext) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            return;
          },
          child: AlertDialog.adaptive(
            title: title,
            content: content,
            actions: actions,
          ),
        );
      },
    );
  }

  /// show error dialog
  static Future<void> showErrorDialog({
    bool isDismissible = false,
    bool backgroundBlur = true,
    required String dialogErrorMsg,
    void Function()? onClick,
  }) {
    return showAdaptiveDialog(
      context: Get.context!,
      barrierDismissible: isDismissible,
      builder: (context) {
        return PopScope(
          canPop: isDismissible,
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: backgroundBlur ? 3 : 0,
              sigmaY: backgroundBlur ? 3 : 0,
            ),
            child: AlertDialog.adaptive(
              contentPadding: const EdgeInsets.only(
                top: 24,
                bottom: 16,
                left: 24,
                right: 24,
              ),
              content: Text(
                dialogErrorMsg,
                style: TextStyles.textMdRegular,
                maxLines: 5,
              ),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  onPressed: () {
                    if (onClick != null) {
                      onClick.call();
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    AppStrings.okay.tr,
                    style: TextStyles.textSmBold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// snackbar
  static void showSnackBar(
    String message, {
    SnackbarType snackbarType = SnackbarType.success,
    void Function()? onErrorDialogClick,
  }) async {
    // if (!Get.isSnackbarOpen) {
    if (snackbarType == SnackbarType.errorDialog) {
      showErrorDialog(
        dialogErrorMsg: message,
        onClick: () {
          if (onErrorDialogClick != null) {
            onErrorDialogClick.call();
          } else {
            Navigator.pop(Get.context!);
          }
        },
      );
    } else {
      if (Get.isSnackbarOpen) {
        Get.closeCurrentSnackbar();
      }

      Get.snackbar(
        '',
        '',
        snackPosition: SnackPosition.TOP,
        snackStyle: SnackStyle.FLOATING,
        messageText: Text(
          message,
          style: TextStyles.textMdRegular.copyWith(color: AppColors.white),
        ),
        titleText: Container(),
        borderWidth: 1,
        backgroundColor: snackbarType == SnackbarType.success
            ? AppColors.success
            : AppColors.warning,
        colorText: Theme.of(Get.context!).colorScheme.surface,
        isDismissible: true,
        animationDuration: const Duration(milliseconds: 500),
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        mainButton: TextButton(
          child: snackbarType == SnackbarType.success
              ? const Icon(
                  Icons.done,
                  color: Colors.white,
                )
              : const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
          onPressed: () {
            if (Get.isSnackbarOpen) {
              Get.closeCurrentSnackbar();
            }
          },
        ),
      );
    }
    // }
  }
}

enum SnackbarType {
  success,
  failure,
  errorDialog,
}
