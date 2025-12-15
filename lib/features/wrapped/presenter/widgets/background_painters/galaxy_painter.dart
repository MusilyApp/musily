import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:musily/features/wrapped/presenter/utils/wrapped_theme.dart';
import 'package:musily/features/wrapped/presenter/widgets/background_painters/wrapped_style_painter.dart';

class GalaxyPainter implements WrappedStylePainter {
  @override
  void paint(Canvas canvas, Size size, Random rng, double t,
      WrappedPalette palette, int seed) {
    final bgPaint = Paint()
      ..shader = ui.Gradient.linear(
          const Offset(0, 0),
          Offset(size.width, size.height),
          [Colors.black, const Color(0xFF180028)]);
    canvas.drawRect(Offset.zero & size, bgPaint);
    final nebulaPaint = Paint();
    for (int i = 0; i < 3; i++) {
      final center = Offset(size.width * (0.2 + 0.6 * rng.nextDouble()),
          size.height * (0.2 + 0.6 * rng.nextDouble()));
      final radius = size.width * (0.5 + 0.1 * sin(t * 2 * pi + i));
      final color = i % 2 == 0 ? palette.primary : palette.secondary;
      final shader = ui.Gradient.radial(center, radius, [
        color.withValues(alpha: 0.2 + 0.05 * sin(t * 2 * pi + i)),
        Colors.transparent
      ], [
        0.0,
        1.0
      ]);
      nebulaPaint.shader = shader;
      canvas.drawCircle(center, radius, nebulaPaint);
    }
    final starPaint = Paint()..color = Colors.white;
    for (int i = 0; i < 120; i++) {
      double flicker = 0.5 + 0.5 * sin((t * 15) + i);
      double alpha = rng.nextDouble() * flicker;
      canvas.drawCircle(
          Offset(rng.nextDouble() * size.width, rng.nextDouble() * size.height),
          0.5 + rng.nextDouble() * 1.5,
          starPaint..color = Colors.white.withValues(alpha: alpha));
    }
  }
}
