import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mybookstore/shared/components/app_icon.dart';
import 'package:mybookstore/shared/components/custom_input.dart';
import 'package:mybookstore/shared/themes/app_colors_theme.dart';
import 'package:mybookstore/shared/themes/app_icons_theme.dart';
import 'package:mybookstore/shared/themes/app_text_styles_theme.dart';

class BookDesign extends StatefulWidget {
  const BookDesign({super.key});

  @override
  State<BookDesign> createState() => _BookDesignState();
}

class _BookDesignState extends State<BookDesign> {
  final TextEditingController _coverColorController =
      TextEditingController(text: '#B5DBE8');
  final TextEditingController _linesColorController = TextEditingController();
  final TextEditingController _shadowColorController = TextEditingController();

  @override
  void dispose() {
    _coverColorController.dispose();
    _linesColorController.dispose();
    _shadowColorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Image.asset(
            'assets/images/book-placeholder.png',
            width: 150,
          ),
          const SizedBox(height: 24),
          AppInput(
            controller: _coverColorController,
            label: 'Cor da capa',
          ),
          const SizedBox(height: 12),
          AppInput(
            controller: _linesColorController,
            label: 'Cor das linhas',
          ),
          const SizedBox(height: 12),
          AppInput(
            controller: _shadowColorController,
            label: 'Cor de sombra',
          ),
          const SizedBox(height: 24),
          CustomPaint(
            painter: DashedBorderPainter(
              color: AppColorsTheme.primary,
              gap: 6.0,
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const AppIcon(
                    AppIconsTheme.upload,
                    color: AppColorsTheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Selecione a imagem de capa',
                    style: AppTextThemeStyleTheme.regular14.textStyle.copyWith(
                      color: AppColorsTheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                'Tamanho máximo: 124 x 176, Formato: PNG, JPEG',
                textAlign: TextAlign.start,
                style: AppTextThemeStyleTheme.regular12.textStyle.copyWith(
                  color: AppColorsTheme.label,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  DashedBorderPainter({
    this.color = Colors.black,
    this.strokeWidth = 1.0,
    this.gap = 5.0,
    this.radius = 12.0,
  });
  final Color color;
  final double strokeWidth;
  final double gap;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint dashedPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );

    final Path path = Path()..addRRect(rect);
    final PathMetrics metrics = path.computeMetrics();
    final PathMetric metric = metrics.first;
    final double length = metric.length;
    double distance = 0;

    while (distance < length) {
      final double start = distance;
      final double end = (start + gap).clamp(0, length);

      final Path extractPath = metric.extractPath(start, end);
      canvas.drawPath(extractPath, dashedPaint);

      distance += gap * 2;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
