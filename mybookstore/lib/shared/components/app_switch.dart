import 'package:flutter/material.dart';
import 'package:mybookstore/shared/themes/app_colors_theme.dart';
import 'package:mybookstore/shared/themes/app_text_styles_theme.dart';

class AppSwitch extends StatefulWidget {
  const AppSwitch({
    required this.value,
    required this.onChanged,
    required this.label,
    this.readOnly = false,
    super.key,
  });

  final bool value;

  final ValueChanged<bool> onChanged;

  final bool? readOnly;

  final String label;

  @override
  State<AppSwitch> createState() => _AppSwitchState();
}

class _AppSwitchState extends State<AppSwitch> {
  bool _value = false;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.readOnly == true) {
          return;
        }
        setState(() {
          _value = !_value;
        });
        widget.onChanged(_value);
      },
      child: Row(
        spacing: 8,
        children: [
          Switch(
            value: _value,
            onChanged: (value) {
              if (widget.readOnly != null && widget.readOnly!) {
                return;
              }
              setState(() {
                _value = value;
              });
              widget.onChanged(value);
            },
            splashRadius: 0, // sem splash
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            thumbColor: WidgetStateProperty.all(AppColorsTheme.bg),
            inactiveTrackColor: AppColorsTheme.placehold,
            activeTrackColor: AppColorsTheme.primary,
            trackOutlineWidth: const WidgetStatePropertyAll(0),
          ),
          Text(
            widget.label,
            style: AppTextThemeStyleTheme.regular16.textStyle.copyWith(
              color: AppColorsTheme.headerWeak,
            ),
          ),
        ],
      ),
    );
  }
}
