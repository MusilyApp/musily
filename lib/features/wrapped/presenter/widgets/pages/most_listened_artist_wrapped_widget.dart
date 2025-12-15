import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/features/wrapped/domain/entities/wrapped_entity.dart';
import 'package:musily/features/wrapped/presenter/utils/wrapped_theme.dart';
import 'package:musily/features/wrapped/presenter/widgets/animated_entry.dart';
import 'package:musily/features/wrapped/presenter/widgets/wrapped_background.dart';

class MostListenedArtistWrappedWidget extends StatefulWidget {
  final WrappedEntity wrapped;
  final WrappedTheme theme;

  const MostListenedArtistWrappedWidget({
    super.key,
    required this.wrapped,
    required this.theme,
  });

  static List<String> getTitles(BuildContext context) => [
        context.localization.wrappedMostListenedArtistTitle1,
        context.localization.wrappedMostListenedArtistTitle2,
        context.localization.wrappedMostListenedArtistTitle3,
        context.localization.wrappedMostListenedArtistTitle4,
        context.localization.wrappedMostListenedArtistTitle5,
      ];

  @override
  State<MostListenedArtistWrappedWidget> createState() =>
      _MostListenedArtistWrappedWidgetState();
}

class _MostListenedArtistWrappedWidgetState
    extends State<MostListenedArtistWrappedWidget>
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
        Random('${widget.wrapped.visualSeed}_most_artist'.hashCode);
    final titles = MostListenedArtistWrappedWidget.getTitles(context);
    final label = titles[layoutRng.nextInt(titles.length)];

    final artist = widget.wrapped.mostListenedArtist;
    final plays = widget.wrapped.mostListenedArtistPlays ?? 0;
    final minutes = widget.wrapped.mostListenedArtistMinutes ?? 0;

    if (artist == null) {
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
                          width: 220,
                          height: 220,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: palette.text.withValues(alpha: 0.2),
                                blurRadius: 120,
                                spreadRadius: 30,
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
                      final lineProgress = CurvedAnimation(
                        parent: _controller,
                        curve: const Interval(0.0, 0.6,
                            curve: Curves.easeInOutCubic),
                      ).value;

                      final starProgress = CurvedAnimation(
                        parent: _controller,
                        curve:
                            const Interval(0.4, 0.9, curve: Curves.elasticOut),
                      ).value;

                      return CustomPaint(
                        painter: _ArtistStarGridPainter(
                          color: palette.text.withValues(alpha: 0.1),
                          starColor: palette.text.withValues(alpha: 0.15),
                          lineProgress: lineProgress,
                          starProgress: starProgress,
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
                      interval: const Interval(0.0, 0.5, curve: Curves.easeOut),
                      offset: const Offset(0, -20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(LucideIcons.sparkles,
                              size: 14,
                              color: palette.text.withValues(alpha: 0.6)),
                          const SizedBox(width: 8),
                          Text(
                            label,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 3,
                              color: palette.text.withValues(alpha: 0.6),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(LucideIcons.sparkles,
                              size: 14,
                              color: palette.text.withValues(alpha: 0.6)),
                        ],
                      ),
                    ),
                    const Spacer(),
                    AnimatedEntry(
                      controller: _controller,
                      interval:
                          const Interval(0.2, 0.7, curve: Curves.elasticOut),
                      isScale: true,
                      child: Container(
                        width: 240,
                        height: 240,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: palette.text.withValues(alpha: 0.1),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 30,
                              offset: const Offset(0, 15),
                            ),
                          ],
                          image: artist.imageHigh.isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(artist.imageHigh),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: artist.imageHigh.isEmpty
                            ? Icon(LucideIcons.mic,
                                size: 80, color: palette.text)
                            : null,
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
                            height: 70,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                artist.name.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 56,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -2,
                                  color: palette.text,
                                  height: 1.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        AnimatedEntry(
                          controller: _controller,
                          interval: const Interval(0.5, 0.9,
                              curve: Curves.elasticOut),
                          isScale: true,
                          child: Container(
                            width: 40,
                            height: 4,
                            margin: const EdgeInsets.only(top: 8),
                            decoration: BoxDecoration(
                              color: palette.text,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: AnimatedEntry(
                              controller: _controller,
                              interval: const Interval(0.6, 1.0),
                              offset: const Offset(-20, 0),
                              child: _StatItem(
                                value: minutes.toStringAsFixed(0),
                                label: context.localization.wrappedMinutesLabel,
                                palette: palette,
                              ),
                            ),
                          ),
                          Expanded(
                            child: AnimatedEntry(
                              controller: _controller,
                              interval: const Interval(0.6, 1.0),
                              offset: const Offset(20, 0),
                              child: _StatItem(
                                value: "$plays",
                                label: context.localization.wrappedPlaysLabel,
                                palette: palette,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
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
        const SizedBox(height: 6),
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

class _ArtistStarGridPainter extends CustomPainter {
  final Color color;
  final Color starColor;
  final double lineProgress;
  final double starProgress;

  _ArtistStarGridPainter({
    required this.color,
    required this.starColor,
    required this.lineProgress,
    required this.starProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final starPaint = Paint()
      ..color = starColor
      ..style = PaintingStyle.fill;

    final centerX = size.width / 2;
    final footerLineY = size.height * 0.82;

    if (lineProgress > 0) {
      final startY = size.height * 0.6;
      final totalLen = size.height - startY;
      final currentLen = totalLen * lineProgress;

      canvas.drawLine(
        Offset(centerX, startY),
        Offset(centerX, startY + currentLen),
        linePaint,
      );
    }

    if (lineProgress > 0) {
      final halfWidth = (size.width / 2) * lineProgress;
      canvas.drawLine(
        Offset(centerX - halfWidth, footerLineY),
        Offset(centerX + halfWidth, footerLineY),
        linePaint,
      );
    }

    if (starProgress > 0) {
      _drawStar(canvas, starPaint, Offset(size.width * 0.15, size.height * 0.2),
          20 * starProgress);
      _drawStar(canvas, starPaint,
          Offset(size.width * 0.85, size.height * 0.15), 15 * starProgress);
      _drawStar(canvas, starPaint, Offset(size.width * 0.1, size.height * 0.5),
          10 * starProgress);
      _drawStar(canvas, starPaint, Offset(size.width * 0.9, size.height * 0.45),
          25 * starProgress);

      _drawStar(canvas, starPaint, Offset(size.width * 0.3, footerLineY),
          8 * starProgress);
      _drawStar(canvas, starPaint, Offset(size.width * 0.7, footerLineY),
          8 * starProgress);
    }
  }

  void _drawStar(Canvas canvas, Paint paint, Offset center, double scale) {
    if (scale <= 0) return;

    final path = Path();
    path.moveTo(center.dx, center.dy - scale);
    path.quadraticBezierTo(center.dx, center.dy, center.dx + scale, center.dy);
    path.quadraticBezierTo(center.dx, center.dy, center.dx, center.dy + scale);
    path.quadraticBezierTo(center.dx, center.dy, center.dx - scale, center.dy);
    path.quadraticBezierTo(center.dx, center.dy, center.dx, center.dy - scale);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ArtistStarGridPainter oldDelegate) {
    return oldDelegate.lineProgress != lineProgress ||
        oldDelegate.starProgress != starProgress;
  }
}
