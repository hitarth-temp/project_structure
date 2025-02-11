import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../themes/app_colors.dart';

class LoadingDialog {
  LoadingDialog._(); // Private constructor to prevent instantiation

  static void show(BuildContext context, {String? feedback}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (context) => _LoadingDialogContent(feedback: feedback),
    );
  }

  static void hide(BuildContext context) {
    if (Navigator.of(context, rootNavigator: true).canPop()) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }
}

class _LoadingDialogContent extends StatelessWidget {
  final String? feedback;

  const _LoadingDialogContent({super.key, this.feedback});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaY: 1.5, sigmaX: 1.5),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          return;
        },
        child: Dialog(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 110,
                width: 110,
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    AppColors.primary,
                    BlendMode.srcIn,
                  ),
                  child: Lottie.asset(
                    "Assets.video.loader.path",
                  ), // todo: loader json path
                ),
              ),
              if (feedback != null) ...[
                const SizedBox(height: 4),
                Text(
                  feedback!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

extension LoadingDialogExtension on BuildContext {
  void showLoading({String? feedback}) =>
      LoadingDialog.show(this, feedback: feedback);

  void hideLoading() => LoadingDialog.hide(this);
}
