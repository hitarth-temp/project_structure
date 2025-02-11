import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../gen/assets.gen.dart';
import '../themes/app_colors.dart';

class AppExpansionTile extends StatelessWidget {
  final Widget titleWidget;
  final int currentIndex;
  final int selectedIndex;
  final List<Widget> childrenWidget;
  final void Function(bool newState) onExpansionChanged;
  final EdgeInsetsGeometry childrenPadding;

  const AppExpansionTile({
    super.key,
    required this.titleWidget,
    required this.currentIndex,
    required this.selectedIndex,
    required this.onExpansionChanged,
    this.childrenWidget = const [],
    this.childrenPadding = EdgeInsetsDirectional.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: AppColors.transparent),
      child: ExpansionTile(
        key: Key(currentIndex.toString()),
        initiallyExpanded: currentIndex == selectedIndex,
        expandedAlignment: Alignment.centerLeft,
        onExpansionChanged: (value) {
          onExpansionChanged.call(value);
        },
        title: titleWidget,
        textColor: AppColors.black,
        iconColor: AppColors.black,
        collapsedIconColor: AppColors.black,
        childrenPadding: childrenPadding,
        visualDensity: const VisualDensity(vertical: -4),
        trailing: Skeleton.replace(
          replacement: const Bone.circle(
            size: 12,
          ),
          child: RotatedBox(
            quarterTurns: currentIndex == selectedIndex ? 3 : 1,
            child: Icon(Icons.chevron_right_outlined),
          ),
        ),
        collapsedBackgroundColor: AppColors.white,
        backgroundColor: AppColors.white,
        tilePadding: EdgeInsetsDirectional.zero,
        children: childrenWidget,
      ),
    );
  }
}
