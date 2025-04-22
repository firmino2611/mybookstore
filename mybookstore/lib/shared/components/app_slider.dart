import 'package:flutter/material.dart';
import 'package:mybookstore/shared/themes/app_colors_theme.dart';
import 'package:mybookstore/shared/themes/app_text_styles_theme.dart';

class CustomRangeSlider extends StatefulWidget {
  const CustomRangeSlider({
    super.key,
    this.initialStart = 1990,
    this.initialEnd = 2025,
    this.min = 1990,
    this.max = 2025,
    this.onChanged,
  });

  final int initialStart;
  final int initialEnd;
  final int min;
  final int max;
  final Function(int start, int end)? onChanged;

  @override
  State<CustomRangeSlider> createState() => _CustomRangeSliderState();
}

class _CustomRangeSliderState extends State<CustomRangeSlider> {
  late RangeValues values;

  @override
  void initState() {
    super.initState();
    values = RangeValues(
      widget.initialStart.toDouble(),
      widget.initialEnd.toDouble(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ano de lançamento',
          style: AppTextThemeStyleTheme.regular14.textStyle.copyWith(
            color: AppColorsTheme.label,
          ),
        ),
        const SizedBox(height: 12),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 8,
            activeTrackColor: AppColorsTheme.primary,
            inactiveTrackColor: AppColorsTheme.line,
            rangeThumbShape: const RoundRangeSliderThumbShape(
              enabledThumbRadius: 14,
            ),
            thumbColor: Colors.white,
            overlayColor: Colors.transparent,
            activeTickMarkColor: Colors.transparent,
            inactiveTickMarkColor: Colors.transparent,
            overlayShape: SliderComponentShape.noOverlay,
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 14,
              pressedElevation: 0,
            ),
            trackShape: const RoundedRectSliderTrackShape(),
            showValueIndicator: ShowValueIndicator.always,
          ),
          child: RangeSlider(
            values: values,
            max: widget.max.toDouble(),
            min: widget.min.toDouble(),
            onChanged: (newValues) {
              setState(() {
                values = newValues;
                if (widget.onChanged != null) {
                  widget.onChanged!(values.start.ceil(), values.end.ceil());
                }
              });
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              values.start.ceil().toString(),
              style: AppTextThemeStyleTheme.regular12.textStyle.copyWith(
                color: AppColorsTheme.label,
              ),
            ),
            Text(
              values.end.ceil().toString(),
              style: AppTextThemeStyleTheme.regular12.textStyle.copyWith(
                color: AppColorsTheme.label,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
