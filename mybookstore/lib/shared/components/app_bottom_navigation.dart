import 'package:flutter/material.dart';
import 'package:mybookstore/shared/components/app_icon.dart';
import 'package:mybookstore/shared/themes/app_colors_theme.dart';
import 'package:mybookstore/shared/themes/app_icons_theme.dart';
import 'package:mybookstore/shared/themes/app_text_styles_theme.dart';

class AppBottomNavigation extends StatelessWidget {
  const AppBottomNavigation({
    required this.currentIndex,
    required this.onTap,
    required this.items,
    Key? key,
  }) : super(key: key);
  final int currentIndex;
  final Function(int) onTap;
  final List<AppBottomNavigationItem> items;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: AppColorsTheme.bg.withValues(alpha: .5),
          border: const Border(top: BorderSide(color: AppColorsTheme.line)),
        ),
        height: 68,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            items.length,
            (index) => Expanded(child: _buildNavItem(index)),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final bool isSelected = index == currentIndex;
    final Color iconColor =
        isSelected ? AppColorsTheme.headerWeak : AppColorsTheme.placehold;
    final Color textColor =
        isSelected ? AppColorsTheme.headerWeak : AppColorsTheme.placehold;

    return Container(
      padding: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.grey.shade50 : Colors.transparent,
        borderRadius: BorderRadius.circular(isSelected ? 8 : 0),
      ),
      child: InkWell(
        onTap: () => onTap(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppIcon(items[index].icon, color: iconColor, width: 24),
            const SizedBox(height: 4),
            if (isSelected)
              Text(
                items[index].label,
                style: AppTextThemeStyleTheme.semibold14.textStyle.copyWith(
                  color: textColor,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class AppBottomNavigationItem {
  const AppBottomNavigationItem({required this.icon, required this.label});
  final AppIconsTheme icon;
  final String label;
}
