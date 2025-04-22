import 'package:flutter/material.dart';
import 'package:mybookstore/shared/themes/app_colors_theme.dart';
import 'package:mybookstore/shared/themes/app_text_styles_theme.dart';

class BookTabSelector extends StatefulWidget {
  const BookTabSelector({
    required this.onTabSelected,
    Key? key,
    this.initialTab = 0,
  }) : super(key: key);
  final Function(int) onTabSelected;
  final int initialTab;

  @override
  State<BookTabSelector> createState() => _BookTabSelectorState();
}

class _BookTabSelectorState extends State<BookTabSelector> {
  late int _selectedTab;

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTab;
  }

  void _selectTab(int tabIndex) {
    setState(() {
      _selectedTab = tabIndex;
    });
    widget.onTabSelected(tabIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTabItem(0, 'Dados do livro'),
        const SizedBox(width: 16),
        _buildTabItem(1, 'Design do Livro'),
      ],
    );
  }

  Widget _buildTabItem(int tabIndex, String title) {
    final isSelected = _selectedTab == tabIndex;

    return GestureDetector(
      onTap: () => _selectTab(tabIndex),
      child: Container(
        width: 160,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColorsTheme.line : AppColorsTheme.bg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: AppTextThemeStyleTheme.medium14.textStyle.copyWith(
                color: isSelected
                    ? AppColorsTheme.headerWeak
                    : AppColorsTheme.label,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: isSelected ? Colors.black87 : AppColorsTheme.bg,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
