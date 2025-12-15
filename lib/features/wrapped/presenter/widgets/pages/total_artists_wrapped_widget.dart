import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/features/wrapped/domain/entities/wrapped_entity.dart';
import 'package:musily/features/wrapped/presenter/utils/wrapped_theme.dart';
import 'package:musily/features/wrapped/presenter/widgets/animated_entry.dart';
import 'package:musily/features/wrapped/presenter/widgets/wrapped_background.dart';

class TotalArtistsWrappedWidget extends StatefulWidget {
  final WrappedEntity wrapped;
  final WrappedTheme theme;

  const TotalArtistsWrappedWidget({
    super.key,
    required this.wrapped,
    required this.theme,
  });

  static List<String> getDescriptions(BuildContext context) => [
        context.localization.wrappedArtistsMessage1,
        context.localization.wrappedArtistsMessage2,
        context.localization.wrappedArtistsMessage3,
        context.localization.wrappedArtistsMessage4,
        context.localization.wrappedArtistsMessage5,
        context.localization.wrappedArtistsMessage6,
      ];

  @override
  State<TotalArtistsWrappedWidget> createState() =>
      _TotalArtistsWrappedWidgetState();
}

class _TotalArtistsWrappedWidgetState extends State<TotalArtistsWrappedWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
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
        Random('${widget.wrapped.visualSeed}_artists_v2'.hashCode);
    final fmt = NumberFormat.decimalPattern('pt_BR');
    final count = fmt.format(widget.wrapped.totalArtistsListened);
    final descriptions = TotalArtistsWrappedWidget.getDescriptions(context);
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
              child: AnimatedEntry(
                controller: _controller,
                interval: const Interval(0.0, 0.6, curve: Curves.easeOut),
                isScale: true,
                child: CustomPaint(
                  painter: _PlusPatternPainter(
                    color: palette.text.withValues(alpha: 0.08),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedEntry(
                          controller: _controller,
                          interval: const Interval(0.0, 0.5,
                              curve: Curves.elasticOut),
                          isScale: true,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: palette.text,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              context.localization.wrappedYourLineup
                                  .toUpperCase(),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                                color: palette.background,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        AnimatedEntry(
                          controller: _controller,
                          interval: const Interval(0.2, 0.6),
                          child: Icon(LucideIcons.micVocal,
                              size: 24,
                              color: palette.text.withValues(alpha: 0.6)),
                        ),
                        const SizedBox(height: 16),
                        AnimatedEntry(
                          controller: _controller,
                          interval: const Interval(0.3, 0.7),
                          offset: const Offset(0, 10),
                          child: Text(
                            context.localization.wrappedYouTunedInto,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: palette.text.withValues(alpha: 0.8),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              AnimatedEntry(
                                controller: _controller,
                                interval: const Interval(0.4, 0.8,
                                    curve: Curves.easeOutBack),
                                offset: const Offset(-50, 0),
                                child: Text(
                                  "{",
                                  style: TextStyle(
                                    fontSize: 120,
                                    fontWeight: FontWeight.w100,
                                    color: palette.text.withValues(alpha: 0.3),
                                    height: 1.0,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              AnimatedEntry(
                                controller: _controller,
                                interval: const Interval(0.5, 0.9,
                                    curve: Curves.elasticOut),
                                isScale: true,
                                child: Text(
                                  count,
                                  style: TextStyle(
                                    fontSize: 140,
                                    fontWeight: FontWeight.w900,
                                    height: 1.0,
                                    letterSpacing: -4,
                                    color: palette.text,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              AnimatedEntry(
                                controller: _controller,
                                interval: const Interval(0.4, 0.8,
                                    curve: Curves.easeOutBack),
                                offset: const Offset(50, 0),
                                child: Text(
                                  "}",
                                  style: TextStyle(
                                    fontSize: 120,
                                    fontWeight: FontWeight.w100,
                                    color: palette.text.withValues(alpha: 0.3),
                                    height: 1.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        AnimatedEntry(
                          controller: _controller,
                          interval: const Interval(0.6, 1.0,
                              curve: Curves.easeOutCubic),
                          offset: const Offset(0, 40),
                          child: Text(
                            context.localization.wrappedArtists.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 4,
                              color: palette.text,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    AnimatedEntry(
                      controller: _controller,
                      interval: const Interval(0.7, 1.0),
                      offset: const Offset(0, 20),
                      child: SizedBox(
                        width: 280,
                        child: Text(
                          description,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            height: 1.4,
                            color: palette.text.withValues(alpha: 0.9),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
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

class _PlusPatternPainter extends CustomPainter {
  final Color color;

  _PlusPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const double spacing = 60.0;
    const double sizeCross = 8.0;

    for (double x = 0; x < size.width; x += spacing) {
      double offsetY = (x % (spacing * 2) == 0) ? 0 : spacing / 2;

      for (double y = -spacing; y < size.height; y += spacing) {
        final centerX = x + 30;
        final centerY = y + offsetY + 30;

        canvas.drawLine(
          Offset(centerX - sizeCross / 2, centerY),
          Offset(centerX + sizeCross / 2, centerY),
          paint,
        );
        canvas.drawLine(
          Offset(centerX, centerY - sizeCross / 2),
          Offset(centerX, centerY + sizeCross / 2),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
