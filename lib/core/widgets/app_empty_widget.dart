import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path/path.dart';

import '../themes/app_colors.dart';
import '../themes/text_styles.dart';
import 'app_button.dart';

class AppEmptyWidget extends StatelessWidget {
  final String imgPath;
  final String title;
  final String subtitle;
  final String? buttonText;
  final VoidCallback? onPressed;
  final bool addListView;

  const AppEmptyWidget({
    super.key,
    required this.imgPath,
    required this.title,
    required this.subtitle,
    this.buttonText,
    this.onPressed,
    this.addListView = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Allows pull to refresh
        if (addListView)
          ListView(
            physics: const AlwaysScrollableScrollPhysics(),
          ),

        // Empty view centered
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // img
              extension(imgPath) == ".svg"
                  ? SvgPicture.asset(imgPath)
                  : Image.asset(imgPath),

              const SizedBox(height: 24),

              // title
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyles.displayXsMedium,
              ),

              const SizedBox(height: 16),

              // subtitle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyles.textLgRegular.copyWith(
                    color: AppColors.black,
                  ),
                ),
              ),

              // button
              if (buttonText != null)
                Padding(
                  padding: const EdgeInsetsDirectional.only(top: 24),
                  child: Align(
                    alignment: Alignment.center,
                    child: AppButton(
                      buttonWidth: 0,
                      buttonHeight: 44,
                      onPressed: onPressed,
                      buttonText: buttonText!,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
