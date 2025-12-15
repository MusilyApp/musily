import 'dart:math';
import 'package:flutter/material.dart';
import 'package:musily/features/wrapped/presenter/utils/wrapped_theme.dart';
import 'package:musily/features/wrapped/presenter/widgets/background_painters/wrapped_style_painter.dart';

class HoneycombPainter implements WrappedStylePainter {
  @override
  void paint(Canvas canvas, Size size, Random rng, double t,
      WrappedPalette palette, int seed) {
    const double hexSize = 35.0;
    final double width = sqrt(3) * hexSize;
    const double height = 2 * hexSize;
    final double wDist = width;
    const double hDist = height * 0.75;
    final paintStroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    final paintFill = Paint()..style = PaintingStyle.fill;

    int rows = (size.height / hDist).ceil() + 2;
    int cols = (size.width / wDist).ceil() + 2;

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        double x = c * wDist;
        double y = r * hDist;
        if (r % 2 != 0) x += wDist / 2;
        x -= wDist;
        y -= hDist;

        final path = Path();
        for (int i = 0; i < 6; i++) {
          double angle = 2 * pi / 6 * (i + 0.5);
          double px = x + hexSize * cos(angle);
          double py = y + hexSize * sin(angle);
          if (i == 0) {
            path.moveTo(px, py);
          } else {
            path.lineTo(px, py);
          }
        }
        path.close();

        double gridAlpha = 0.05 + 0.03 * sin(t * 2 * pi);
        paintStroke.color = palette.text.withValues(alpha: gridAlpha);
        canvas.drawPath(path, paintStroke);

        final cellHash = (r * 123 + c * 456 + seed);
        final cellRng = Random(cellHash);

        if (cellRng.nextDouble() < 0.2) {
          double wavePhase = (x * 0.005) + (y * 0.005) + (t * 2 * pi);
          double activation = sin(wavePhase);
          if (activation > 0.5) {
            double intensity = (activation - 0.5) * 2;
            Color baseColor =
                cellRng.nextBool() ? palette.primary : palette.accent;
            paintFill.color = baseColor.withValues(alpha: 0.25 * intensity);
            canvas.drawPath(path, paintFill);
          }
        }
      }
    }
  }
}
