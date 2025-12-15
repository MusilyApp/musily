import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/features/wrapped/domain/entities/wrapped_entity.dart';
import 'package:musily/features/wrapped/presenter/utils/wrapped_theme.dart';
import 'package:musily/features/wrapped/presenter/widgets/animated_entry.dart';
import 'package:musily/features/wrapped/presenter/widgets/wrapped_background.dart';

class ThankYouWrappedWidget extends StatefulWidget {
  final WrappedEntity wrapped;
  final WrappedTheme theme;

  const ThankYouWrappedWidget({
    super.key,
    required this.wrapped,
    required this.theme,
  });

  static List<String> getTitles(BuildContext context) => [
        context.localization.wrappedThankYouTitle1,
        context.localization.wrappedThankYouTitle2,
        context.localization.wrappedThankYouTitle3,
        context.localization.wrappedThankYouTitle4,
        context.localization.wrappedThankYouTitle5,
        context.localization.wrappedThankYouTitle6,
      ];

  static List<String> getSubtitles(BuildContext context) => [
        context.localization.wrappedThankYouMessage1,
        context.localization.wrappedThankYouMessage2,
        context.localization.wrappedThankYouMessage3,
        context.localization.wrappedThankYouMessage4,
        context.localization.wrappedThankYouMessage5,
        context.localization.wrappedThankYouMessage6,
      ];

  @override
  State<ThankYouWrappedWidget> createState() => _ThankYouWrappedWidgetState();
}

class _ThankYouWrappedWidgetState extends State<ThankYouWrappedWidget>
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
    final layoutRng = Random('${widget.wrapped.visualSeed}_thankyou'.hashCode);

    final titles = ThankYouWrappedWidget.getTitles(context);
    final subtitles = ThankYouWrappedWidget.getSubtitles(context);

    final title = titles[layoutRng.nextInt(titles.length)];
    final subtitle = subtitles[layoutRng.nextInt(subtitles.length)];

    final bool isHeart = layoutRng.nextBool();
    final IconData themeIcon = isHeart ? LucideIcons.heart : LucideIcons.star;

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
            Positioned(
              top: -50,
              right: -50,
              child: AnimatedEntry(
                controller: _controller,
                interval: const Interval(0.0, 1.0, curve: Curves.easeOut),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 0.2),
                  duration: const Duration(seconds: 2),
                  builder: (context, value, child) {
                    return Transform.rotate(
                      angle: value,
                      child: Icon(
                        themeIcon,
                        size: 300,
                        color: palette.text.withValues(alpha: 0.03),
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              bottom: 100,
              left: -80,
              child: AnimatedEntry(
                controller: _controller,
                interval: const Interval(0.0, 1.0, curve: Curves.easeOut),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: -0.2),
                  duration: const Duration(seconds: 2),
                  builder: (context, value, child) {
                    return Transform.rotate(
                      angle: value,
                      child: Icon(
                        themeIcon,
                        size: 400,
                        color: palette.text.withValues(alpha: 0.02),
                      ),
                    );
                  },
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    AnimatedEntry(
                      controller: _controller,
                      interval:
                          const Interval(0.2, 0.7, curve: Curves.elasticOut),
                      isScale: true,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: palette.text.withValues(alpha: 0.3),
                              blurRadius: 80,
                              spreadRadius: 20,
                            ),
                          ],
                        ),
                        child: Icon(
                          themeIcon,
                          color: palette.text,
                          size: 72,
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                    AnimatedEntry(
                      controller: _controller,
                      interval:
                          const Interval(0.4, 0.8, curve: Curves.easeOutBack),
                      offset: const Offset(0, 40),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 72,
                            fontWeight: FontWeight.w900,
                            height: 1.0,
                            letterSpacing: -2,
                            color: palette.text,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    AnimatedEntry(
                      controller: _controller,
                      interval: const Interval(0.5, 0.9, curve: Curves.easeOut),
                      offset: const Offset(0, 20),
                      child: Text(
                        subtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: palette.text.withValues(alpha: 0.8),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const Spacer(),
                    _DashedLineReveal(
                      controller: _controller,
                      interval:
                          const Interval(0.6, 1.0, curve: Curves.easeInOut),
                      color: palette.text.withValues(alpha: 0.3),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        AnimatedEntry(
                          controller: _controller,
                          interval:
                              const Interval(0.7, 1.0, curve: Curves.easeOut),
                          offset: const Offset(0, 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "WRAPPED",
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2.0,
                                  color: palette.text.withValues(alpha: 0.6),
                                ),
                              ),
                              Text(
                                widget.wrapped.rangeEnd.year.toString(),
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -1,
                                  color: palette.text,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _StampReveal(
                          controller: _controller,
                          interval: const Interval(0.8, 1.0,
                              curve: Curves.elasticOut),
                          child: Icon(
                            LucideIcons.circleCheck,
                            color: palette.text.withValues(alpha: 0.5),
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
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

class _DashedLineReveal extends StatelessWidget {
  final AnimationController controller;
  final Interval interval;
  final Color color;

  const _DashedLineReveal({
    required this.controller,
    required this.interval,
    required this.color,
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
          alignment: Alignment.centerLeft,
          child: CustomPaint(
            size: const Size(double.infinity, 1),
            painter: _DashedLinePainter(color: color),
          ),
        );
      },
    );
  }
}

class _StampReveal extends StatelessWidget {
  final AnimationController controller;
  final Interval interval;
  final Widget child;

  const _StampReveal({
    required this.controller,
    required this.interval,
    required this.child,
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
        final val = animation.value;

        final scale = (val * 1.5).clamp(0.0, 1.0);

        final rotation = (1.0 - val) * 0.5;

        return Opacity(
          opacity: val.clamp(0.0, 1.0),
          child: Transform.rotate(
            angle: rotation,
            child: Transform.scale(
              scale: scale,
              child: child,
            ),
          ),
        );
      },
      child: child,
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;

  _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.square;

    const double dashWidth = 4;
    const double dashSpace = 4;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
