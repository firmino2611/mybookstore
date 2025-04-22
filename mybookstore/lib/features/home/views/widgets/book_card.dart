import 'package:flutter/material.dart';
import 'package:mybookstore/core/entities/book_entity.dart';
import 'package:mybookstore/shared/components/app_icon.dart';
import 'package:mybookstore/shared/themes/app_colors_theme.dart';
import 'package:mybookstore/shared/themes/app_icons_theme.dart';
import 'package:mybookstore/shared/themes/app_text_styles_theme.dart';

class BookCard extends StatelessWidget {
  const BookCard({required this.book, super.key});

  final BookEntity book;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'assets/images/book-placeholder.png',
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 8),
          Text(
            book.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextThemeStyleTheme.semibold14.textStyle.copyWith(
              color: AppColorsTheme.headerWeak,
            ),
          ),
          Text(
            book.author,
            style: AppTextThemeStyleTheme.regular12.textStyle.copyWith(
              color: AppColorsTheme.label,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            spacing: 4,
            children: [
              const AppIcon(
                AppIconsTheme.star,
                width: 24,
                color: AppColorsTheme.headerWeak,
              ),
              Text(
                '${book.rating}.0',
                style: AppTextThemeStyleTheme.regular14.textStyle.copyWith(
                  color: AppColorsTheme.headerWeak,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
