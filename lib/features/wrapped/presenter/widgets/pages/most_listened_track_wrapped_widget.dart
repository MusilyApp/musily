import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/features/wrapped/domain/entities/wrapped_entity.dart';
import 'package:musily/features/wrapped/presenter/utils/wrapped_theme.dart';
import 'package:musily/features/wrapped/presenter/widgets/animated_entry.dart';
import 'package:musily/features/wrapped/presenter/widgets/wrapped_background.dart';

class MostListenedTrackWrappedWidget extends StatefulWidget {
  final WrappedEntity wrapped;
  final WrappedTheme theme;

  const MostListenedTrackWrappedWidget({
    super.key,
    required this.wrapped,
    required this.theme,
  });

  static List<String> getTitles(BuildContext context) => [
        context.localization.wrappedMostListenedTrackTitle1,
        context.localization.wrappedMostListenedTrackTitle2,
        context.localization.wrappedMostListenedTrackTitle3,
        context.localization.wrappedMostListenedTrackTitle4,
        context.localization.wrappedMostListenedTrackTitle5,
        context.localization.wrappedMostListenedTrackTitle6,
      ];

  @override
  State<MostListenedTrackWrappedWidget> createState() =>
      _MostListenedTrackWrappedWidgetState();
}

class _MostListenedTrackWrappedWidgetState
    extends State<MostListenedTrackWrappedWidget>
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
        Random('${widget.wrapped.visualSeed}_most_track'.hashCode);
    final titles = MostListenedTrackWrappedWidget.getTitles(context);
    final label = titles[layoutRng.nextInt(titles.length)];
    final track = widget.wrapped.mostListenedTrack;
    final plays = widget.wrapped.mostListenedTrackPlays ?? 0;
    final minutes = widget.wrapped.mostListenedTrackMinutes ?? 0;

    if (track == null) {
      return Container(color: palette.background);
    }

    final alignLeft = layoutRng.nextBool();
    final CrossAxisAlignment crossAlign =
        alignLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end;
    final TextAlign textAlign = alignLeft ? TextAlign.left : TextAlign.right;

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
              right: alignLeft ? -40 : null,
              left: alignLeft ? null : -40,
              top: 0,
              bottom: 0,
              child: AnimatedEntry(
                controller: _controller,
                interval: const Interval(0.0, 0.8, curve: Curves.easeOut),
                offset: alignLeft ? const Offset(-50, 0) : const Offset(50, 0),
                child: Center(
                  child: Text(
                    "1",
                    style: TextStyle(
                      fontSize: 600,
                      fontWeight: FontWeight.w900,
                      color: palette.text.withValues(alpha: 0.04),
                      height: 1.0,
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: alignLeft
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.end,
                      children: [
                        AnimatedEntry(
                          controller: _controller,
                          interval: const Interval(0.2, 0.6,
                              curve: Curves.elasticOut),
                          isScale: true,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: palette.text, width: 1.5),
                            ),
                            child: Text(
                              label,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 2,
                                color: palette.text,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(flex: 1),
                    AspectRatio(
                      aspectRatio: 1,
                      child: _ShadowPopReveal(
                        controller: _controller,
                        interval:
                            const Interval(0.3, 0.8, curve: Curves.easeOutBack),
                        shadowColor: palette.text.withValues(alpha: 0.2),
                        backgroundColor: palette.text.withValues(alpha: 0.1),
                        child: track.imageHigh.isNotEmpty
                            ? Image.network(
                                track.imageHigh,
                                fit: BoxFit.cover,
                              )
                            : Icon(LucideIcons.music,
                                size: 80, color: palette.text),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Column(
                      crossAxisAlignment: crossAlign,
                      children: [
                        AnimatedEntry(
                          controller: _controller,
                          interval: const Interval(0.5, 0.9,
                              curve: Curves.easeOutCubic),
                          offset: Offset(alignLeft ? -30 : 30, 0),
                          child: Text(
                            track.name.toUpperCase(),
                            textAlign: textAlign,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              height: 0.95,
                              letterSpacing: -1,
                              color: palette.text,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        AnimatedEntry(
                          controller: _controller,
                          interval:
                              const Interval(0.6, 1.0, curve: Curves.easeOut),
                          offset: Offset(alignLeft ? -20 : 20, 0),
                          child: Text(
                            track.artistName,
                            textAlign: textAlign,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: palette.text.withValues(alpha: 0.8),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(flex: 2),
                    _DividerReveal(
                      controller: _controller,
                      interval: const Interval(0.5, 0.9),
                      color: palette.text.withValues(alpha: 0.3),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedEntry(
                          controller: _controller,
                          interval: const Interval(0.7, 1.0),
                          offset: const Offset(0, 10),
                          child: _StatBox(
                            label:
                                context.localization.wrappedPlays.toUpperCase(),
                            value: "$plays",
                            palette: palette,
                          ),
                        ),
                        AnimatedEntry(
                          controller: _controller,
                          interval: const Interval(0.8, 1.0),
                          offset: const Offset(0, 10),
                          child: _StatBox(
                            label: context.localization.wrappedTotalTime
                                .toUpperCase(),
                            value: "${(minutes / 60).toStringAsFixed(1)}h",
                            palette: palette,
                            alignRight: true,
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
                    color: palette.text.withValues(alpha: 0.3),
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

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final WrappedPalette palette;
  final bool alignRight;

  const _StatBox({
    required this.label,
    required this.value,
    required this.palette,
    this.alignRight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: palette.text.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: palette.text,
            letterSpacing: -0.5,
            height: 1.0,
          ),
        ),
      ],
    );
  }
}

class _ShadowPopReveal extends StatelessWidget {
  final AnimationController controller;
  final Interval interval;
  final Widget child;
  final Color shadowColor;
  final Color backgroundColor;

  const _ShadowPopReveal({
    required this.controller,
    required this.interval,
    required this.child,
    required this.shadowColor,
    required this.backgroundColor,
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
        final offsetValue = 12.0 * animation.value;
        final scaleValue = animation.value;

        return Transform.scale(
          scale: scaleValue,
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              boxShadow: [
                BoxShadow(
                  color: shadowColor,
                  offset: Offset(offsetValue, offsetValue),
                  blurRadius: 0,
                ),
              ],
            ),
            child: child,
          ),
        );
      },
      child: child,
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
    final animation = CurvedAnimation(parent: controller, curve: interval);
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.scale(
          scaleX: animation.value,
          alignment: Alignment.centerLeft,
          child: Container(height: 1, color: color),
        );
      },
    );
  }
}
