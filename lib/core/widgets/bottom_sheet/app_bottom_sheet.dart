import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../themes/app_colors.dart';
import '../../themes/text_styles.dart';

class AppBottomSheet extends StatelessWidget {
  final String title;
  final bool showCloseIcon;
  final bool showDivider;
  final Widget contentWidget;

  /// default: vertical: 16
  final EdgeInsetsGeometry? sheetPadding;

  const AppBottomSheet({
    super.key,
    required this.title,
    required this.showCloseIcon,
    required this.showDivider,
    required this.contentWidget,
    this.sheetPadding,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        return;
      },
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Padding(
          padding: sheetPadding ?? const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: 16,
                  end: 16,
                  bottom: 4,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // title
                    Text(
                      title,
                      style: TextStyles.textXlMedium,
                    ),

                    // close icon
                    if (showCloseIcon)
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        borderRadius: BorderRadius.circular(100),
                        child: SizedBox(
                          height: 32,
                          width: 32,
                          child: Icon(Icons.close_rounded),
                        ),
                      ),
                  ],
                ),
              ),

              // divider
              Divider(
                color: showDivider ? AppColors.grey100 : AppColors.transparent,
              ),

              // content
              contentWidget,
            ],
          ),
        ),
      ),
    );
  }

  /// general bottom sheet with two button
  static void showBottomSheet({
    String title = "",
    bool isDismissible = true,
    bool showCloseIcon = true,
    bool showDivider = true,
    required Widget contentWidget,
    EdgeInsetsGeometry? sheetPadding,
  }) {
    showModalBottomSheet(
      context: Get.context!,
      builder: (context) {
        return AppBottomSheet(
          title: title,
          showCloseIcon: showCloseIcon,
          showDivider: showDivider,
          contentWidget: contentWidget,
          sheetPadding: sheetPadding,
        );
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: AppColors.white,
      isDismissible: isDismissible,
      isScrollControlled: true,
      useSafeArea: true,
    );
  }
}
