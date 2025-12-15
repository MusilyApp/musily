import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/features/wrapped/domain/entities/wrapped_entity.dart';
import 'package:musily/features/wrapped/presenter/utils/wrapped_theme.dart';
import 'package:musily/features/wrapped/presenter/widgets/animated_entry.dart';
import 'package:musily/features/wrapped/presenter/widgets/wrapped_background.dart';

class MostListenedAlbumWrappedWidget extends StatefulWidget {
  final WrappedEntity wrapped;
  final WrappedTheme theme;

  const MostListenedAlbumWrappedWidget({
    super.key,
    required this.wrapped,
    required this.theme,
  });

  static List<String> getTitles(BuildContext context) => [
        context.localization.wrappedMostListenedAlbumTitle1,
        context.localization.wrappedMostListenedAlbumTitle2,
        context.localization.wrappedMostListenedAlbumTitle3,
        context.localization.wrappedMostListenedAlbumTitle4,
        context.localization.wrappedMostListenedAlbumTitle5,
      ];

  @override
  State<MostListenedAlbumWrappedWidget> createState() =>
      _MostListenedAlbumWrappedWidgetState();
}

class _MostListenedAlbumWrappedWidgetState
    extends State<MostListenedAlbumWrappedWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
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
        Random('${widget.wrapped.visualSeed}_most_album'.hashCode);
    final titles = MostListenedAlbumWrappedWidget.getTitles(context);
    final label = titles[layoutRng.nextInt(titles.length)];

    final album = widget.wrapped.mostListenedAlbum;
    final plays = widget.wrapped.mostListenedAlbumPlays ?? 0;
    final minutes = widget.wrapped.mostListenedAlbumMinutes ?? 0;

    if (album == null) {
      return Container(color: palette.background);
    }

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
              child: Stack(
                children: [
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.25,
                    left: 0,
                    right: 0,
                    child: AnimatedEntry(
                      controller: _controller,
                      interval: const Interval(0.2, 0.8),
                      isScale: true,
                      child: Center(
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: palette.text.withValues(alpha: 0.15),
                                blurRadius: 100,
                                spreadRadius: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      final progress = CurvedAnimation(
                        parent: _controller,
                        curve: const Interval(0.0, 0.6,
                            curve: Curves.easeInOutCubic),
                      ).value;

                      return CustomPaint(
                        painter: _AnimatedCrosshairPainter(
                          color: palette.text.withValues(alpha: 0.1),
                          progress: progress,
                        ),
                        size: Size.infinite,
                      );
                    },
                  ),
                ],
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
                child: Column(
                  children: [
                    AnimatedEntry(
                      controller: _controller,
                      interval: const Interval(0.4, 0.8, curve: Curves.easeOut),
                      offset: const Offset(0, -20),
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3,
                          color: palette.text.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                    const Spacer(),
                    AnimatedEntry(
                      controller: _controller,
                      interval:
                          const Interval(0.2, 0.7, curve: Curves.elasticOut),
                      isScale: true,
                      child: Container(
                        width: 260,
                        height: 260,
                        decoration: BoxDecoration(
                          color: palette.background,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: album.imageHigh.isNotEmpty
                            ? Image.network(
                                album.imageHigh,
                                fit: BoxFit.cover,
                              )
                            : Icon(LucideIcons.disc,
                                size: 80, color: palette.text),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Column(
                      children: [
                        AnimatedEntry(
                          controller: _controller,
                          interval: const Interval(0.4, 0.8,
                              curve: Curves.easeOutBack),
                          offset: const Offset(0, 30),
                          child: SizedBox(
                            height: 60,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                album.name.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 42,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -1,
                                  color: palette.text,
                                  height: 1.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        AnimatedEntry(
                          controller: _controller,
                          interval:
                              const Interval(0.5, 0.9, curve: Curves.easeOut),
                          offset: const Offset(0, 20),
                          child: Text(
                            album.artistName,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: palette.text.withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    AnimatedEntry(
                      controller: _controller,
                      interval: const Interval(0.6, 1.0, curve: Curves.easeOut),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          border: Border.symmetric(
                            horizontal: BorderSide(
                                color: palette.text.withValues(alpha: 0.15),
                                width: 1),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _StatItem(
                              value: minutes.toStringAsFixed(0),
                              label: context.localization.wrappedMinutesLabel,
                              palette: palette,
                            ),
                            _StatItem(
                              value: "$plays",
                              label: context.localization.wrappedPlaysLabel,
                              palette: palette,
                            ),
                          ],
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
                interval: const Interval(0.8, 1.0),
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

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final WrappedPalette palette;

  const _StatItem({
    required this.value,
    required this.label,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
            color: palette.text,
            height: 1.0,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
            color: palette.text.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }
}

class _AnimatedCrosshairPainter extends CustomPainter {
  final Color color;
  final double progress;

  _AnimatedCrosshairPainter({required this.color, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final centerX = size.width / 2;
    final centerY = size.height * 0.42;

    final currentWidth = size.width * progress;
    final halfWidth = currentWidth / 2;

    canvas.drawLine(
      Offset(centerX - halfWidth, centerY),
      Offset(centerX + halfWidth, centerY),
      paint,
    );

    final currentHeight = size.height * progress;
    final halfHeight = currentHeight / 2;

    canvas.drawLine(
      Offset(centerX, centerY - halfHeight),
      Offset(centerX, centerY + halfHeight),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _AnimatedCrosshairPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
