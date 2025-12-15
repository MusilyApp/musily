import 'dart:math';
import 'package:flutter/material.dart';
import 'package:musily/features/wrapped/presenter/utils/wrapped_theme.dart';
import 'package:musily/features/wrapped/presenter/widgets/background_painters/wrapped_style_painter.dart';

class ParticlesPainter implements WrappedStylePainter {
  @override
  void paint(Canvas canvas, Size size, Random rng, double t,
      WrappedPalette palette, int seed) {
    final paint = Paint()
      ..color = palette.accent.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;
    final List<Offset> points = [];
    for (int i = 0; i < 45; i++) {
      double bx = rng.nextDouble() * size.width;
      double by = rng.nextDouble() * size.height;
      double ox = sin(t * 2 * pi + i) * 12;
      double oy = cos(t * 2 * pi + i * 0.7) * 12;
      points.add(Offset(bx + ox, by + oy));
      canvas.drawCircle(points.last, 2 + rng.nextDouble() * 2, paint);
    }
    final linePaint = Paint()..strokeWidth = 1;
    for (int i = 0; i < points.length; i++) {
      for (int j = i + 1; j < points.length; j++) {
        final dist = (points[i] - points[j]).distance;
        if (dist < 100) {
          linePaint.color =
              palette.primary.withValues(alpha: 0.2 * (1 - dist / 100));
          canvas.drawLine(points[i], points[j], linePaint);
        }
      }
    }
  }
}
