import 'package:flutter/material.dart';
import 'package:mybookstore/shared/components/app_button.dart';
import 'package:mybookstore/shared/themes/app_colors_theme.dart';
import 'package:mybookstore/shared/themes/app_text_styles_theme.dart';

class AppDialogs {
  static Future<bool?> showDeleteConfirmationDialog({
    required BuildContext context,
    required String entityName,
    required String name,
  }) async {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () => Navigator.pop(context, false),
                    child: const Icon(Icons.close, size: 24),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Deseja deletar o $entityName\n$name?',
                  textAlign: TextAlign.center,
                  style: AppTextThemeStyleTheme.semibold18.textStyle.copyWith(
                    color: AppColorsTheme.headerWeak,
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        text: 'Cancelar',
                        onPressed: () => Navigator.pop(context, false),
                        backgroundColor: AppColorsTheme.bg,
                        textColor: AppColorsTheme.primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: AppButton(
                        text: 'Confirmar',
                        onPressed: () => Navigator.pop(context, true),
                        backgroundColor: AppColorsTheme.danger,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
