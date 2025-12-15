import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/features/wrapped/domain/entities/wrapped_entity.dart';
import 'package:musily/features/wrapped/presenter/utils/wrapped_theme.dart';
import 'package:musily/features/wrapped/presenter/widgets/animated_entry.dart';
import 'package:musily/features/wrapped/presenter/widgets/wrapped_background.dart';

class TotalAlbumsWrappedWidget extends StatefulWidget {
  final WrappedEntity wrapped;
  final WrappedTheme theme;

  const TotalAlbumsWrappedWidget({
    super.key,
    required this.wrapped,
    required this.theme,
  });

  static List<String> getDescriptions(BuildContext context) => [
        context.localization.wrappedAlbumsMessage1,
        context.localization.wrappedAlbumsMessage2,
        context.localization.wrappedAlbumsMessage3,
        context.localization.wrappedAlbumsMessage4,
        context.localization.wrappedAlbumsMessage5,
      ];

  @override
  State<TotalAlbumsWrappedWidget> createState() =>
      _TotalAlbumsWrappedWidgetState();
}

class _TotalAlbumsWrappedWidgetState extends State<TotalAlbumsWrappedWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = widget.theme.effectivePalette;
    final layoutRng =
        Random('${widget.wrapped.visualSeed}_total_albums'.hashCode);
    final fmt = NumberFormat.decimalPattern('pt_BR');
    final count = fmt.format(widget.wrapped.totalAlbumsListened);
    final descriptions = TotalAlbumsWrappedWidget.getDescriptions(context);
    final description = descriptions[layoutRng.nextInt(descriptions.length)];

    return WrappedBackground(
      theme: widget.theme,
      seed: widget.wrapped.visualSeed.hashCode,
      child: DefaultTextStyle(
        style: TextStyle(
          fontFamily: 'Inter',
          color: palette.text,
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _AnimatedFramesPainter(
                      color: palette.text.withValues(alpha: 0.1),
                      progress: _controller.value,
                    ),
                  );
                },
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(32, 24, 32, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AnimatedEntry(
                      controller: _controller,
                      interval: const Interval(0.0, 0.5, curve: Curves.easeOut),
                      offset: const Offset(0, -20),
                      child: Text(
                        context.localization.wrappedYourCollection
                            .toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3,
                          color: palette.text.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        AnimatedEntry(
                          controller: _controller,
                          interval: const Interval(0.2, 0.6),
                          child: Text(
                            context.localization.wrappedYouExplored,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: palette.text.withValues(alpha: 0.8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        AnimatedEntry(
                          controller: _controller,
                          interval: const Interval(0.3, 0.8,
                              curve: Curves.easeOutBack),
                          isScale: true,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              count,
                              style: TextStyle(
                                fontSize: 180,
                                fontWeight: FontWeight.w900,
                                height: 1.0,
                                letterSpacing: -6,
                                color: palette.text,
                                shadows: [
                                  Shadow(
                                    color: palette.background
                                        .withValues(alpha: 0.5),
                                    blurRadius: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _LineReveal(
                              controller: _controller,
                              interval: const Interval(0.5, 0.9,
                                  curve: Curves.easeOut),
                              color: palette.text.withValues(alpha: 0.5),
                              isLeft: true,
                            ),
                            const SizedBox(width: 12),
                            AnimatedEntry(
                              controller: _controller,
                              interval: const Interval(0.5, 0.9,
                                  curve: Curves.easeOut),
                              offset: const Offset(0, 10),
                              child: Text(
                                context.localization.wrappedCompleteAlbums
                                    .toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                  color: palette.text,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            _LineReveal(
                              controller: _controller,
                              interval: const Interval(0.5, 0.9,
                                  curve: Curves.easeOut),
                              color: palette.text.withValues(alpha: 0.5),
                              isLeft: false,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            final start = 0.6 + (index * 0.08);
                            final end = (start + 0.3).clamp(0.0, 1.0);

                            return AnimatedEntry(
                              controller: _controller,
                              interval: Interval(start, end,
                                  curve: Curves.easeOutBack),
                              isScale: true,
                              child: Container(
                                width: 6,
                                height: 6,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  color: index % 2 == 0
                                      ? palette.text
                                      : Colors.transparent,
                                  border:
                                      Border.all(color: palette.text, width: 1),
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 16),
                        AnimatedEntry(
                          controller: _controller,
                          interval: const Interval(0.7, 1.0),
                          offset: const Offset(0, 20),
                          child: SizedBox(
                            width: 260,
                            child: Text(
                              description,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                height: 1.4,
                                color: palette.text.withValues(alpha: 0.9),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 24,
              bottom: 24,
              child: AnimatedEntry(
                controller: _controller,
                interval: const Interval(0.9, 1.0),
                child: Text(
                  'musily.app',
                  style: TextStyle(
                    fontSize: 12,
                    color: palette.text.withValues(alpha: 0.4),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LineReveal extends StatelessWidget {
  final AnimationController controller;
  final Interval interval;
  final Color color;
  final bool isLeft;

  const _LineReveal({
    required this.controller,
    required this.interval,
    required this.color,
    this.isLeft = false,
  });

  @override
  Widget build(BuildContext context) {
    final safeInterval = Interval(
      interval.begin.clamp(0.0, 1.0),
      interval.end.clamp(0.0, 1.0),
      curve: interval.curve,
    );
    final animation = CurvedAnimation(parent: controller, curve: safeInterval);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.scale(
          scaleX: animation.value,
          alignment: isLeft ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 20,
            height: 1,
            color: color,
          ),
        );
      },
    );
  }
}

class _AnimatedFramesPainter extends CustomPainter {
  final Color color;
  final double progress;

  _AnimatedFramesPainter({required this.color, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final center = Offset(size.width / 2, size.height / 2);
    final double maxSize = size.width * 0.85;

    void drawScaledRect(double baseScale, double entryThreshold) {
      if (progress < entryThreshold) return;

      double localProgress = (progress - entryThreshold) * 2.5;
      localProgress = localProgress.clamp(0.0, 1.0);
      localProgress = 1 - pow(1 - localProgress, 3).toDouble();

      double currentSize = maxSize * baseScale * localProgress;

      if (currentSize > 0) {
        paint.color = color.withValues(alpha: color.a * localProgress);

        canvas.drawRect(
          Rect.fromCenter(
              center: center, width: currentSize, height: currentSize),
          paint,
        );
      }
    }

    drawScaledRect(0.35, 0.4);
    drawScaledRect(0.65, 0.2);
    drawScaledRect(1.00, 0.0);
  }

  @override
  bool shouldRepaint(covariant _AnimatedFramesPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
