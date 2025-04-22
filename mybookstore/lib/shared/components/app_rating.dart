import 'package:flutter/material.dart';
import 'package:mybookstore/shared/components/app_icon.dart';
import 'package:mybookstore/shared/themes/app_colors_theme.dart';
import 'package:mybookstore/shared/themes/app_icons_theme.dart';

class AppRating extends StatefulWidget {
  const AppRating({
    required this.onRatingChanged,
    super.key,
    this.initialRating = 0,
    this.size = 24.0,
    this.readOnly = false,
  });

  final int initialRating;

  final Function(int) onRatingChanged;

  final double size;

  final bool readOnly;

  @override
  State<AppRating> createState() => _AppRatingState();
}

class _AppRatingState extends State<AppRating> {
  late int _rating;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () => _onTap(index),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: AppIcon(
              index < _rating ? AppIconsTheme.startSolid : AppIconsTheme.star,
              color: AppColorsTheme.headerWeak,
              width: widget.size,
            ),
          ),
        );
      }),
    );
  }

  void _onTap(int index) {
    if (widget.readOnly) {
      return;
    }

    setState(() {
      _rating = index + 1;
    });
    widget.onRatingChanged(_rating);
  }
}
