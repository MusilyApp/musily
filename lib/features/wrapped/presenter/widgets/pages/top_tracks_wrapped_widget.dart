import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/features/wrapped/domain/entities/wrapped_entity.dart';
import 'package:musily/features/wrapped/presenter/utils/wrapped_theme.dart';
import 'package:musily/features/wrapped/presenter/widgets/animated_entry.dart';
import 'package:musily/features/wrapped/presenter/widgets/wrapped_background.dart';

class TopTracksWrappedWidget extends StatefulWidget {
  final WrappedEntity wrapped;
  final WrappedTheme theme;

  const TopTracksWrappedWidget({
    super.key,
    required this.wrapped,
    required this.theme,
  });

  static List<String> getTitles(BuildContext context) => [
        context.localization.wrappedTopTracksTitle1,
        context.localization.wrappedTopTracksTitle2,
        context.localization.wrappedTopTracksTitle3,
        context.localization.wrappedTopTracksTitle4,
        context.localization.wrappedTopTracksTitle5,
        context.localization.wrappedTopTracksTitle6,
      ];

  @override
  State<TopTracksWrappedWidget> createState() => _TopTracksWrappedWidgetState();
}

class _TopTracksWrappedWidgetState extends State<TopTracksWrappedWidget>
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
        Random('${widget.wrapped.visualSeed}_top_tracks'.hashCode);
    final titles = TopTracksWrappedWidget.getTitles(context);
    final titleText = titles[layoutRng.nextInt(titles.length)];

    final displayItems = widget.wrapped.topTracks.take(5).toList();

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
              left: -120,
              bottom: -50,
              child: AnimatedEntry(
                controller: _controller,
                interval: const Interval(0.0, 0.8, curve: Curves.easeOutQuad),
                offset: const Offset(0, 50),
                child: Icon(
                  LucideIcons.music4,
                  size: 500,
                  color: palette.text.withValues(alpha: 0.03),
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
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            titleText,
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -2,
                              height: 1.0,
                              color: palette.text,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text(
                              context.localization.wrappedRanking.toUpperCase(),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                                color: palette.text.withValues(alpha: 0.6),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Expanded(
                      child: ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: displayItems.length,
                        separatorBuilder: (context, index) {
                          final start = 0.1 + (index * 0.1);
                          final end = (start + 0.4).clamp(0.0, 1.0);

                          if (start >= end) {
                            return Divider(
                                color: palette.text.withValues(alpha: 0.2));
                          }

                          return _DividerReveal(
                            controller: _controller,
                            interval:
                                Interval(start, end, curve: Curves.easeInOut),
                            color: palette.text.withValues(alpha: 0.2),
                          );
                        },
                        itemBuilder: (context, index) {
                          final item = displayItems[index];
                          final isFirst = index == 0;

                          final start = 0.15 + (index * 0.12);
                          final end = (start + 0.5).clamp(0.0, 1.0);

                          final safeInterval =
                              Interval(start, end, curve: Curves.easeOutQuart);

                          final capStart = (start + 0.1).clamp(0.0, 1.0);
                          final capEnd = end;
                          final safeCapInterval = Interval(
                              capStart, capEnd >= capStart ? capEnd : capStart,
                              curve: Curves.elasticOut);

                          return AnimatedEntry(
                            controller: _controller,
                            interval: safeInterval,
                            offset: const Offset(0, 20),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: isFirst ? 16.0 : 12.0),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 40,
                                    child: Text(
                                      "${index + 1}",
                                      style: TextStyle(
                                        fontSize: isFirst ? 42 : 24,
                                        fontWeight: FontWeight.w900,
                                        color: isFirst
                                            ? palette.text
                                            : palette.text
                                                .withValues(alpha: 0.5),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  AnimatedEntry(
                                    controller: _controller,
                                    interval: safeCapInterval,
                                    isScale: isFirst,
                                    child: Container(
                                      width: isFirst ? 64 : 48,
                                      height: isFirst ? 64 : 48,
                                      color:
                                          palette.text.withValues(alpha: 0.1),
                                      child: item.imageLow.isNotEmpty
                                          ? Image.network(
                                              item.imageLow,
                                              fit: BoxFit.cover,
                                            )
                                          : Icon(LucideIcons.music,
                                              color: palette.text),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          item.name.toUpperCase(),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: isFirst ? 16 : 14,
                                            letterSpacing: -0.5,
                                            color: palette.text,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          item.artistName,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: palette.text
                                                .withValues(alpha: 0.7),
                                            fontSize: isFirst ? 14 : 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (isFirst)
                                    AnimatedEntry(
                                      controller: _controller,
                                      interval: safeCapInterval,
                                      isScale: true,
                                      child: Icon(LucideIcons.crown,
                                          size: 16, color: palette.text),
                                    ),
                                ],
                              ),
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

class _DividerReveal extends StatelessWidget {
  final AnimationController controller;
  final Interval interval;
  final Color color;

  const _DividerReveal({
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
          child: Divider(
            color: color,
            height: 1,
            thickness: 1,
          ),
        );
      },
    );
  }
}
