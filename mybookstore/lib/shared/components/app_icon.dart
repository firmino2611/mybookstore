import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mybookstore/shared/themes/app_colors_theme.dart';
import 'package:mybookstore/shared/themes/app_icons_theme.dart';

class AppIcon extends StatelessWidget {
  const AppIcon(this.icon, {super.key, this.width, this.color});

  final AppIconsTheme icon;

  final double? width;

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      icon.path,
      width: width,
      height: width,
      colorFilter: ColorFilter.mode(
        color ?? AppColorsTheme.label,
        BlendMode.srcIn,
      ),
    );
  }
}
