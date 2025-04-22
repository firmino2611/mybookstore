import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mybookstore/shared/themes/app_colors_theme.dart';

enum AppTextThemeStyleTheme {
  regular8(8, FontWeight.w400),
  regular10(10, FontWeight.w400),
  regular12(12, FontWeight.w400),
  regular14(14, FontWeight.w400),
  regular16(16, FontWeight.w400),
  regular18(18, FontWeight.w400),
  regular24(24, FontWeight.w400),

  medium10(10, FontWeight.w500),
  medium12(12, FontWeight.w500),
  medium14(14, FontWeight.w500),
  medium16(16, FontWeight.w500),
  medium18(18, FontWeight.w500),
  medium20(20, FontWeight.w500),

  semibold8(8, FontWeight.w600),
  semibold10(10, FontWeight.w600),
  semibold12(12, FontWeight.w600),
  semibold14(14, FontWeight.w600),
  semibold16(16, FontWeight.w600),
  semibold18(18, FontWeight.w600),
  semibold20(20, FontWeight.w600),
  semibold24(24, FontWeight.w600),

  bold10(10, FontWeight.w700),
  bold12(12, FontWeight.w700),
  bold14(14, FontWeight.w700),
  bold16(16, FontWeight.w700),
  bold18(18, FontWeight.w700),
  bold20(20, FontWeight.w700),
  bold22(22, FontWeight.w700),
  bold24(24, FontWeight.w700),
  bold28(28, FontWeight.w700),
  bold32(32, FontWeight.w700),
  bold38(38, FontWeight.w700);

  const AppTextThemeStyleTheme(this.size, this.weight);

  final double size;
  final FontWeight weight;

  TextStyle get textStyle {
    return GoogleFonts.poppins(
      fontSize: size,
      fontWeight: weight,
      color: AppColorsTheme.label,
    );
  }
}
