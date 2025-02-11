import 'package:flutter/material.dart';
import '../themes/app_colors.dart';
import '../themes/text_styles.dart';

class AppTextFieldLabel extends StatelessWidget {
  final String label;
  final bool showRequiredMark;

  const AppTextFieldLabel({
    super.key,
    required this.label,
    this.showRequiredMark = false,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: label,
        style: TextStyles.textSmRegular.copyWith(
          color: AppColors.black,
        ),
        children: [
          if (showRequiredMark)
            TextSpan(
              text: ' *',
              style: TextStyles.textSmRegular.copyWith(
                color: AppColors.warning,
              ),
            ),
        ],
      ),
    );
  }
}
