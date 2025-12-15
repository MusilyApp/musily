import 'dart:math';
import 'package:flutter/material.dart';
import 'package:musily/features/wrapped/presenter/utils/wrapped_theme.dart';
import 'package:musily/features/wrapped/presenter/widgets/background_painters/galaxy_painter.dart';
import 'package:musily/features/wrapped/presenter/widgets/background_painters/honeycomb_painter.dart';
import 'package:musily/features/wrapped/presenter/widgets/background_painters/lines_painter.dart';
import 'package:musily/features/wrapped/presenter/widgets/background_painters/particles_painter.dart';
import 'package:musily/features/wrapped/presenter/widgets/background_painters/tech_painter.dart';
import 'package:musily/features/wrapped/presenter/widgets/background_painters/wrapped_style_painter.dart';

class WrappedBackground extends StatefulWidget {
  final WrappedTheme theme;
  final int seed;
  final Widget? child;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const WrappedBackground({
    super.key,
    required this.theme,
    this.seed = 0,
    this.child,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  State<WrappedBackground> createState() => _WrappedBackgroundState();
}

class _WrappedBackgroundState extends State<WrappedBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: widget.borderRadius ?? BorderRadius.zero,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) => CustomPaint(
          painter: _BackgroundPainter(
            theme: widget.theme,
            seed: widget.seed,
            t: _controller.value,
          ),
          size: Size(widget.width ?? 0, widget.height ?? 0),
          child: _buildChild(),
        ),
      ),
    );
  }

  Widget? _buildChild() {
    if (widget.width != null || widget.height != null) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: widget.child,
      );
    }
    return widget.child;
  }
}

class _BackgroundPainter extends CustomPainter {
  final WrappedTheme theme;
  final int seed;
  final double t;

  static final Map<WrappedStyle, WrappedStylePainter> _painters = {
    WrappedStyle.lines: LinesPainter(),
    WrappedStyle.honeycomb: HoneycombPainter(),
    WrappedStyle.particles: ParticlesPainter(),
    WrappedStyle.galaxy: GalaxyPainter(),
    WrappedStyle.tech: TechPainter(),
  };

  _BackgroundPainter({
    required this.theme,
    required this.seed,
    required this.t,
  });

  WrappedPalette get palette => theme.effectivePalette;

  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(seed ^ size.hashCode);
    final effectivePalette = palette;

    canvas.drawRect(
        Offset.zero & size, Paint()..color = effectivePalette.background);

    final painter = _painters[theme.style];
    painter?.paint(canvas, size, rng, t, effectivePalette, seed);
  }

  @override
  bool shouldRepaint(covariant _BackgroundPainter oldDelegate) =>
      oldDelegate.theme.seed != theme.seed ||
      oldDelegate.seed != seed ||
      oldDelegate.t != t;
}
