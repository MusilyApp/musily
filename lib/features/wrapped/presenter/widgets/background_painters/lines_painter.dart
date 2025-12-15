import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:musily/features/wrapped/presenter/utils/wrapped_theme.dart';
import 'package:musily/features/wrapped/presenter/widgets/background_painters/wrapped_style_painter.dart';

class LinesPainter implements WrappedStylePainter {
  @override
  void paint(Canvas canvas, Size size, Random rng, double t,
      WrappedPalette palette, int seed) {
    final bgPaint = Paint()
      ..shader = ui.Gradient.linear(
        const Offset(0, 0),
        Offset(0, size.height),
        [palette.background, palette.primary.withValues(alpha: 0.05)],
      );
    canvas.drawRect(Offset.zero & size, bgPaint);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    int numberOfLines = 20;
    double verticalSpacing = size.height / (numberOfLines * 0.8);

    for (int i = 0; i < numberOfLines + 5; i++) {
      double progress = i / numberOfLines;

      Color baseColor;
      if (progress < 0.5) {
        baseColor = Color.lerp(palette.primary, palette.accent, progress * 2)!;
      } else {
        baseColor = Color.lerp(
            palette.accent, palette.secondary, (progress - 0.5) * 2)!;
      }

      paint.color =
          baseColor.withValues(alpha: 0.25 + (0.15 * rng.nextDouble()));
      paint.strokeWidth = 1.0 + rng.nextDouble();

      final path = Path();
      double yBase = (i * verticalSpacing) - (size.height * 0.1);
      path.moveTo(0, yBase);

      double animationPhase = t * 2 * pi;

      for (double x = 0; x <= size.width; x += 10) {
        double w1 = sin(x * 0.012 + (i * 0.3) + animationPhase) * 25;
        double w2 =
            sin(x * 0.04 + (i * 0.1) + (seed * 0.1) + animationPhase * 1.5) * 8;
        double yOffset = (w1 + w2) * (1 + i * 0.05);
        path.lineTo(x, yBase + yOffset);
      }
      canvas.drawPath(path, paint);
    }
  }
}
