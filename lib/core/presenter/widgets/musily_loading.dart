import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A circular loading indicator with a rotating arc and pulsing center dot.
class MusilyLoading extends StatefulWidget {
  final Color? color;
  final double size;

  const MusilyLoading({
    super.key,
    this.color,
    this.size = 24,
  });

  @override
  State<MusilyLoading> createState() => _MusilyLoadingState();
}

class _MusilyLoadingState extends State<MusilyLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = _resolveColor(context, widget.color);
    return Semantics(
      excludeSemantics: true,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return Stack(
              alignment: Alignment.center,
              children: [
                // Rotating arc
                Transform.rotate(
                  angle: _controller.value * 2 * math.pi,
                  child: CustomPaint(
                    size: Size.square(widget.size),
                    painter: _ArcLoadingPainter(
                      color: color.withOpacity(0.3),
                      strokeWidth: 2.5,
                    ),
                  ),
                ),
                // Pulsing center dot
                Transform.scale(
                  scale: 0.5 + 0.3 * _controller.value,
                  child: Container(
                    width: widget.size * 0.25,
                    height: widget.size * 0.25,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color.withValues(
                        alpha: 0.6 + 0.4 * (1 - _controller.value),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

@immutable
class _ArcLoadingPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  const _ArcLoadingPainter({
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide - strokeWidth) / 2;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // Start from top
      math.pi * 1.5, // 270 degrees
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_ArcLoadingPainter oldDelegate) =>
      oldDelegate.color != color;
}

/// Bouncing dots loading indicator.
class MusilyDotsLoading extends StatefulWidget {
  final Color? color;
  final double size;
  final int dots;
  final Duration duration;
  final double spacing;

  const MusilyDotsLoading({
    super.key,
    this.color,
    this.size = 28,
    this.dots = 3,
    this.duration = const Duration(milliseconds: 900),
    this.spacing = 6.0,
  });

  @override
  State<MusilyDotsLoading> createState() => _MusilyDotsLoadingState();
}

class _MusilyDotsLoadingState extends State<MusilyDotsLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Theme.of(context).colorScheme.primary;

    return SizedBox(
      height: widget.size,
      width: widget.size + widget.spacing * widget.dots,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(widget.dots, (i) {
              final offset = (i / widget.dots);
              final value = (_controller.value + offset) % 1.0;

              final curved = Curves.easeInOutCubic.transform(value);

              final scale = 0.55 + curved * 0.45;
              final opacity = 0.35 + curved * 0.65;
              final y = (1 - curved) * 4;

              return Transform.translate(
                offset: Offset(0, y),
                child: Transform.scale(
                  scale: scale,
                  child: Container(
                    width: widget.size * .2,
                    height: widget.size * .2,
                    margin:
                        EdgeInsets.symmetric(horizontal: widget.spacing / 2),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: opacity),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}

/// Audio-wave-style loading bars.
class MusilyWaveLoading extends StatefulWidget {
  final Color? color;
  final double size;
  final int bars;
  final Duration duration;
  final double amplitude;
  final double baseHeight;

  const MusilyWaveLoading({
    super.key,
    this.color,
    this.size = 24,
    this.bars = 3,
    this.duration = const Duration(milliseconds: 1200),
    this.amplitude = 0.4,
    this.baseHeight = 0.3,
  });

  @override
  State<MusilyWaveLoading> createState() => _MusilyWaveLoadingState();
}

class _MusilyWaveLoadingState extends State<MusilyWaveLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = _resolveColor(context, widget.color);
    final barWidth = widget.size / (widget.bars * 1.5);
    final spacing = barWidth * 0.5;

    return Semantics(
      excludeSemantics: true,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.bars, (i) {
                final phase = (i / widget.bars) * 2 * math.pi;
                final value =
                    math.sin(_controller.value * 2 * math.pi + phase).abs();
                final height = widget.size *
                    (widget.baseHeight + widget.amplitude * value);

                return Container(
                  margin: EdgeInsets.symmetric(horizontal: spacing / 2),
                  width: barWidth,
                  height: height,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(barWidth / 2),
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }
}

// Helper to resolve color consistently
Color _resolveColor(BuildContext context, Color? overrideColor) {
  return overrideColor ?? Theme.of(context).iconTheme.color ?? Colors.white;
}
