import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/features/wrapped/domain/entities/wrapped_entity.dart';
import 'package:musily/features/wrapped/presenter/utils/wrapped_theme.dart';
import 'package:musily/features/wrapped/presenter/widgets/animated_entry.dart';
import 'package:musily/features/wrapped/presenter/widgets/wrapped_background.dart';

class TopAlbumsWrappedWidget extends StatefulWidget {
  final WrappedEntity wrapped;
  final WrappedTheme theme;

  const TopAlbumsWrappedWidget({
    super.key,
    required this.wrapped,
    required this.theme,
  });

  static List<String> getTitles(BuildContext context) => [
        context.localization.wrappedTopAlbumsTitle1,
        context.localization.wrappedTopAlbumsTitle2,
        context.localization.wrappedTopAlbumsTitle3,
        context.localization.wrappedTopAlbumsTitle4,
        context.localization.wrappedTopAlbumsTitle5,
        context.localization.wrappedTopAlbumsTitle6,
      ];

  @override
  State<TopAlbumsWrappedWidget> createState() => _TopAlbumsWrappedWidgetState();
}

class _TopAlbumsWrappedWidgetState extends State<TopAlbumsWrappedWidget>
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
        Random('${widget.wrapped.visualSeed}_top_albums'.hashCode);
    final titles = TopAlbumsWrappedWidget.getTitles(context);
    final titleText = titles[layoutRng.nextInt(titles.length)];

    final displayItems = widget.wrapped.topAlbums.take(5).toList();

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
                interval: const Interval(0.0, 0.5, curve: Curves.easeOut),
                child: CustomPaint(
                  painter: _DotGridPainter(
                      color: palette.text.withValues(alpha: 0.1)),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AnimatedEntry(
                      controller: _controller,
                      interval: const Interval(0.0, 0.5, curve: Curves.easeOut),
                      offset: const Offset(0, -20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            titleText,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2.5,
                              color: palette.text,
                            ),
                          ),
                          Icon(LucideIcons.layers,
                              size: 16,
                              color: palette.text.withValues(alpha: 0.5)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Expanded(
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: displayItems.length,
                        itemBuilder: (context, index) {
                          final item = displayItems[index];
                          final isLast = index == displayItems.length - 1;

                          final start = 0.15 + (index * 0.15);
                          final end = (start + 0.5).clamp(0.0, 1.0);
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
                                        isScale: true,
                                        child: Text(
                                          "${index + 1}",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w900,
                                            color: palette.text,
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
                                              curve: Curves.linear,
                                            ),
                                            color: palette.text
                                                .withValues(alpha: 0.2),
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
                                          const EdgeInsets.only(bottom: 24.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 56,
                                            height: 56,
                                            margin: const EdgeInsets.only(
                                                right: 16),
                                            decoration: BoxDecoration(
                                              color: palette.text
                                                  .withValues(alpha: 0.1),
                                            ),
                                            child: item.imageLow.isNotEmpty
                                                ? Image.network(
                                                    item.imageLow,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Icon(LucideIcons.disc,
                                                    color: palette.text),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  item.name,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 16,
                                                    height: 1.1,
                                                    color: palette.text,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  item.artistName.toUpperCase(),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: palette.text
                                                        .withValues(alpha: 0.6),
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w600,
                                                    letterSpacing: 1,
                                                  ),
                                                ),
                                              ],
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

  const _TimelineReveal({
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
          scaleY: animation.value,
          alignment: Alignment.topCenter,
          child: Container(
            width: 2,
            color: color,
          ),
        );
      },
    );
  }
}

class _DotGridPainter extends CustomPainter {
  final Color color;

  _DotGridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    const double spacing = 40.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x + 20, y + 20), 1.5, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
