import 'package:flutter/material.dart';

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
    final color =
        widget.color ?? Theme.of(context).iconTheme.color ?? Colors.white;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Outer rotating circle
              Transform.rotate(
                angle: _controller.value * 2 * 3.14159,
                child: CustomPaint(
                  size: Size(widget.size, widget.size),
                  painter: _LoadingPainter(
                    color: color.withValues(alpha: 0.3),
                    progress: _controller.value,
                    strokeWidth: 2.5,
                  ),
                ),
              ),
              // Inner pulsing dot
              Transform.scale(
                scale: 0.5 + (_controller.value * 0.3),
                child: Container(
                  width: widget.size * 0.25,
                  height: widget.size * 0.25,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withValues(
                      alpha: 0.6 + (0.4 * (1 - _controller.value)),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _LoadingPainter extends CustomPainter {
  final Color color;
  final double progress;
  final double strokeWidth;

  _LoadingPainter({
    required this.color,
    required this.progress,
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
    final radius = (size.width - strokeWidth) / 2;

    // Draw arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 / 2, // Start from top
      3.14159 * 1.5, // Draw 270 degrees
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_LoadingPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
