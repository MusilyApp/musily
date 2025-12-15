import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/features/wrapped/domain/entities/wrapped_entity.dart';
import 'package:musily/features/wrapped/presenter/utils/wrapped_theme.dart';
import 'package:musily/features/wrapped/presenter/widgets/animated_entry.dart';
import 'package:musily/features/wrapped/presenter/widgets/wrapped_background.dart';

class TopArtistsWrappedWidget extends StatefulWidget {
  final WrappedEntity wrapped;
  final WrappedTheme theme;

  const TopArtistsWrappedWidget({
    super.key,
    required this.wrapped,
    required this.theme,
  });

  static List<String> getTitles(BuildContext context) => [
        context.localization.wrappedTopArtistsTitle1,
        context.localization.wrappedTopArtistsTitle2,
        context.localization.wrappedTopArtistsTitle3,
        context.localization.wrappedTopArtistsTitle4,
        context.localization.wrappedTopArtistsTitle5,
      ];

  @override
  State<TopArtistsWrappedWidget> createState() =>
      _TopArtistsWrappedWidgetState();
}

class _TopArtistsWrappedWidgetState extends State<TopArtistsWrappedWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
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
        Random('${widget.wrapped.visualSeed}_top_artists'.hashCode);
    final titles = TopArtistsWrappedWidget.getTitles(context);
    final titleText = titles[layoutRng.nextInt(titles.length)];

    final topArtists = widget.wrapped.topArtists.take(5).toList();
    final firstPlace = topArtists.isNotEmpty ? topArtists.first : null;
    final otherPlaces = topArtists.length > 1 ? topArtists.sublist(1) : [];

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
                interval: const Interval(0.0, 0.8, curve: Curves.easeOut),
                isScale: true,
                child: CustomPaint(
                  painter: _SharpStarsPainter(
                      color: palette.text.withValues(alpha: 0.08)),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AnimatedEntry(
                      controller: _controller,
                      interval: const Interval(0.0, 0.5, curve: Curves.easeOut),
                      offset: const Offset(0, -20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(LucideIcons.star,
                              size: 14,
                              color: palette.text.withValues(alpha: 0.6)),
                          const SizedBox(width: 8),
                          Text(
                            titleText,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 3,
                              color: palette.text.withValues(alpha: 0.6),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(LucideIcons.star,
                              size: 14,
                              color: palette.text.withValues(alpha: 0.6)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (firstPlace != null)
                      Column(
                        children: [
                          AnimatedEntry(
                            controller: _controller,
                            interval: const Interval(0.2, 0.7,
                                curve: Curves.elasticOut),
                            isScale: true,
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Container(
                                  width: 130,
                                  height: 130,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color:
                                            palette.text.withValues(alpha: 0.2),
                                        width: 1),
                                    image: firstPlace.imageHigh.isNotEmpty
                                        ? DecorationImage(
                                            image: NetworkImage(
                                                firstPlace.imageHigh),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child: firstPlace.imageHigh.isEmpty
                                      ? Icon(LucideIcons.user,
                                          size: 50, color: palette.text)
                                      : null,
                                ),
                                AnimatedEntry(
                                  controller: _controller,
                                  interval: const Interval(0.4, 0.8,
                                      curve: Curves.elasticOut),
                                  isScale: true,
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: palette.text,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: palette.background, width: 4),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "1",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: palette.background,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          AnimatedEntry(
                            controller: _controller,
                            interval: const Interval(0.4, 0.8,
                                curve: Curves.easeOutBack),
                            offset: const Offset(0, 20),
                            child: Text(
                              firstPlace.name.toUpperCase(),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -1,
                                height: 1.0,
                                color: palette.text,
                              ),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 32),
                    Center(
                      child: _TimelineReveal(
                        controller: _controller,
                        interval: const Interval(0.5, 0.7),
                        color: palette.text.withValues(alpha: 0.1),
                        width: 2,
                        height: 20,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: otherPlaces.length,
                        itemBuilder: (context, index) {
                          final item = otherPlaces[index];
                          final rank = index + 2;
                          final isLast = index == otherPlaces.length - 1;

                          final start = 0.6 + (index * 0.1);
                          final end = (start + 0.4).clamp(0.0, 1.0);
                          final safeInterval =
                              Interval(start, end, curve: Curves.easeOutQuart);

                          return IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SizedBox(
                                  width: 40,
                                  child: Column(
                                    children: [
                                      AnimatedEntry(
                                        controller: _controller,
                                        interval: safeInterval,
                                        child: Text(
                                          "#$rank",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w900,
                                            color: palette.text
                                                .withValues(alpha: 0.6),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      if (!isLast)
                                        Expanded(
                                          child: _TimelineReveal(
                                            controller: _controller,
                                            interval: Interval(
                                              (start + 0.1).clamp(0.0, 1.0),
                                              (end + 0.2).clamp(0.0, 1.0),
                                            ),
                                            color: palette.text
                                                .withValues(alpha: 0.1),
                                            width: 2,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: AnimatedEntry(
                                    controller: _controller,
                                    interval: safeInterval,
                                    offset: const Offset(20, 0),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 48,
                                            height: 48,
                                            margin: const EdgeInsets.only(
                                                right: 16),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: palette.text
                                                  .withValues(alpha: 0.1),
                                              image: item.imageLow.isNotEmpty
                                                  ? DecorationImage(
                                                      image: NetworkImage(
                                                          item.imageLow),
                                                      fit: BoxFit.cover,
                                                    )
                                                  : null,
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              item.name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                                color: palette.text,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
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

class _TimelineReveal extends StatelessWidget {
  final AnimationController controller;
  final Interval interval;
  final Color color;
  final double width;
  final double? height;

  const _TimelineReveal({
    required this.controller,
    required this.interval,
    required this.color,
    required this.width,
    this.height,
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
          scaleY: animation.value,
          alignment: Alignment.topCenter,
          child: Container(
            width: width,
            height: height,
            color: color,
          ),
        );
      },
    );
  }
}

class _SharpStarsPainter extends CustomPainter {
  final Color color;

  _SharpStarsPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final random = Random(12345);

    for (int i = 0; i < 12; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final scale = 10 + random.nextDouble() * 30;

      final path = Path();
      path.moveTo(x, y - scale);
      path.quadraticBezierTo(x, y, x + scale, y);
      path.quadraticBezierTo(x, y, x, y + scale);
      path.quadraticBezierTo(x, y, x - scale, y);
      path.quadraticBezierTo(x, y, x, y - scale);
      path.close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
