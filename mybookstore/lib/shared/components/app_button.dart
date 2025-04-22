import 'package:flutter/material.dart';
import 'package:mybookstore/shared/components/app_icon.dart';
import 'package:mybookstore/shared/themes/app_colors_theme.dart';
import 'package:mybookstore/shared/themes/app_icons_theme.dart';
import 'package:mybookstore/shared/themes/app_text_styles_theme.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    required this.text,
    required this.onPressed,
    super.key,
    this.backgroundColor = AppColorsTheme.primary,
    this.textColor = AppColorsTheme.bg,
    this.icon,
    this.isLoading = false,
    this.borderColor,
  });
  final String text;
  final VoidCallback? onPressed;

  final AppIconsTheme? icon;
  final bool isLoading;

  final Color backgroundColor;
  final Color? borderColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          splashFactory: NoSplash.splashFactory,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: borderColor ?? Colors.transparent,
              width: 2,
            ),
          ),
          disabledBackgroundColor: AppColorsTheme.gray,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16,
          children: [
            if (icon != null && !isLoading) AppIcon(icon!, color: textColor),
            if (isLoading)
              SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(color: textColor),
              ),
            if (!isLoading)
              Text(
                text,
                style: AppTextThemeStyleTheme.semibold16.textStyle.copyWith(
                  color: textColor,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
