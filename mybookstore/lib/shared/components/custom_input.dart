import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mybookstore/shared/components/app_icon.dart';
import 'package:mybookstore/shared/themes/app_colors_theme.dart';
import 'package:mybookstore/shared/themes/app_icons_theme.dart';
import 'package:mybookstore/shared/themes/app_text_styles_theme.dart';

class AppInput extends StatefulWidget {
  const AppInput({
    this.controller,
    this.label,
    this.hint,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.icon,
    this.showClearButton = false,
    this.validator,
    this.maxLines = 1,
    this.textInputAction,
    this.onIconPressed,
    super.key,
  });

  final TextEditingController? controller;

  final FormFieldValidator<String>? validator;

  final String? label;
  final String? hint;

  final AppIconsTheme? icon;

  final int? maxLines;

  final TextInputAction? textInputAction;

  final bool obscureText;
  final bool showClearButton;

  final TextInputType keyboardType;
  final Function(String)? onChanged;

  final Function()? onIconPressed;

  @override
  State<AppInput> createState() => _AppInputState();
}

class _AppInputState extends State<AppInput> {
  final FocusNode _focusNode = FocusNode();
  bool _hasFocus = false;
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _hasFocus = _focusNode.hasFocus;
      });
    });
    _obscureText = widget.obscureText;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Border? _getBorder() {
    if (_hasFocus) {
      return Border.all(
        color: AppColorsTheme.headerWeak,
        strokeAlign: BorderSide.strokeAlignOutside,
        width: 2,
      );
    }

    return null;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: widget.label != null || widget.icon != null ? 6 : 16,
      ),
      decoration: BoxDecoration(
        color: _hasFocus ? Colors.transparent : AppColorsTheme.input,
        borderRadius: BorderRadius.circular(12),
        border: _getBorder(),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label
                if (widget.label != null) ...[
                  Text(
                    widget.label!,
                    style: AppTextThemeStyleTheme.regular14.textStyle.copyWith(
                      color: AppColorsTheme.label,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
                // TextField
                TextFormField(
                  validator: widget.validator,
                  controller: widget.controller,
                  focusNode: _focusNode,
                  obscureText: _obscureText,
                  keyboardType: widget.keyboardType,
                  onChanged: widget.onChanged,
                  style: AppTextThemeStyleTheme.regular16.textStyle.copyWith(
                    color: AppColorsTheme.headerWeak,
                  ),
                  inputFormatters: _applyFormatters(),
                  maxLines: _obscureText ? 1 : widget.maxLines,
                  cursorHeight: 16,
                  textInputAction: widget.textInputAction,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    hintStyle: const TextStyle(
                      color: AppColorsTheme.placehold,
                      fontSize: 16,
                    ),
                    hintText: widget.hint,
                  ),
                ),
              ],
            ),
          ),
          if (widget.icon != null || widget.obscureText)
            IconButton(
              onPressed: () {
                if (widget.showClearButton) {
                  widget.controller?.clear();
                  setState(() {});
                } else if (widget.obscureText) {
                  _togglePasswordVisibility();
                }
              },
              icon: AppIcon(
                _getIcon()!,
                color: AppColorsTheme.headerWeak,
                width: 24,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              splashRadius: 18,
            ),
        ],
      ),
    );
  }

  AppIconsTheme? _getIcon() {
    if (widget.obscureText) {
      return _obscureText ? AppIconsTheme.hide : AppIconsTheme.view;
    }

    return widget.icon;
  }

  List<TextInputFormatter> _applyFormatters() {
    return [
      if (widget.keyboardType == TextInputType.number) ...[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9(\d{1,2})]')),
        FilteringTextInputFormatter.digitsOnly,
      ],
    ];
  }
}
