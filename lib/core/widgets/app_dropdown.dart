import 'dart:math' as math;

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../themes/app_colors.dart';
import '../themes/app_theme.dart';
import '../themes/text_styles.dart';
import 'app_text_field.dart';
import 'app_text_field_label.dart';

class AppDropdownWithSearch<T> extends StatelessWidget {
  final String? labelText, hintText;
  final List<T> items;
  final ValueChanged<T> onChanged;
  final bool showRequiredMark;
  final T? selectedValue;
  final TextEditingController? textEditingController;
  final FocusNode focusNode;
  final String Function(T item) getTitle;
  final bool searchRequired;

  const AppDropdownWithSearch({
    super.key,
    this.labelText = "",
    this.hintText = "",
    required this.items,
    required this.onChanged,
    this.showRequiredMark = false,
    this.selectedValue,
    this.textEditingController,
    required this.focusNode,
    required this.getTitle,
    this.searchRequired = true,
  });

  @override
  Widget build(BuildContext context) {
    FocusNode searchFocusNode = FocusNode();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showRequiredMark)
          Padding(
            padding: const EdgeInsetsDirectional.only(bottom: 6),
            child: AppTextFieldLabel(
              label: labelText.toString(),
              showRequiredMark: showRequiredMark,
            ),
          ),
        DropdownButtonHideUnderline(
          child: DropdownButtonFormField2<T>(
            focusNode: focusNode,
            dropdownSearchData: (searchRequired)
                ? DropdownSearchData(
                    searchController: textEditingController,
                    searchInnerWidgetHeight: 70,
                    searchInnerWidget: Padding(
                      padding: const EdgeInsets.all(8),
                      child: AppTextField(
                        constraints: const BoxConstraints(maxHeight: 40),
                        focusNode: searchFocusNode,
                        textEditingController: textEditingController!,
                        borderRadius: 8,
                        labelText: "AppStrings.search.tr",
                        showRequiredMark: false,
                      ),
                    ),
                    searchMatchFn: (item, searchValue) {
                      return getTitle
                          .call(item.value as T)
                          .toLowerCase()
                          .contains(searchValue.toLowerCase());
                    },
                  )
                : null,
            iconStyleData: IconStyleData(
              icon: Skeleton.replace(
                replacement: const Bone.circle(size: 20),
                child: Transform.rotate(
                  angle: 90 * math.pi / 180,
                  child: SvgPicture.asset(
                    "Assets.images.svg.arrowRight.path",
                    colorFilter: ColorFilter.mode(
                      AppColors.black,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              iconEnabledColor: AppColors.black,
              iconDisabledColor: AppColors.white,
            ),
            value: selectedValue,
            onChanged: (newValue) {
              if (newValue != null) {
                onChanged.call(newValue as T);
              }
            },
            items: items.map<DropdownMenuItem<T>>(
              (item) {
                return DropdownMenuItem<T>(
                  value: item,
                  child: Text(
                    getTitle.call(item),
                    style: TextStyles.textMdRegular,
                  ),
                );
              },
            ).toList(),
            decoration: InputDecoration(
              contentPadding: const EdgeInsetsDirectional.symmetric(
                vertical: 12,
                horizontal: 16,
              ),
              labelText:
                  (hintText.toString().isNotEmpty) ? hintText : labelText,
              labelStyle:
                  TextStyles.textMdRegular.copyWith(color: AppColors.black),
              enabledBorder:
                  AppTheme.appTheme.inputDecorationTheme.enabledBorder,
              errorBorder: AppTheme.appTheme.inputDecorationTheme.errorBorder,
              focusedBorder:
                  AppTheme.appTheme.inputDecorationTheme.focusedBorder,
              focusedErrorBorder:
                  AppTheme.appTheme.inputDecorationTheme.focusedErrorBorder,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              floatingLabelStyle:
                  TextStyles.textXsRegular.copyWith(color: AppColors.black),
              filled: true,
              fillColor: AppColors.white,
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 200,
              width: MediaQuery.of(context).size.width - 36,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: AppColors.white,
              ),
              offset: const Offset(1, -4),
              // Set the offset to center the dropdown
              scrollbarTheme: ScrollbarThemeData(
                radius: const Radius.circular(40),
                thickness: WidgetStateProperty.all<double>(6),
                thumbVisibility: WidgetStateProperty.all<bool>(true),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
