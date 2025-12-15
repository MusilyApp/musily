import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/features/wrapped/domain/entities/wrapped_entity.dart';
import 'package:musily/features/wrapped/presenter/utils/wrapped_theme.dart';
import 'package:musily/features/wrapped/presenter/widgets/animated_entry.dart';
import 'package:musily/features/wrapped/presenter/widgets/wrapped_background.dart';

class TotalTracksWrappedWidget extends StatefulWidget {
  final WrappedEntity wrapped;
  final WrappedTheme theme;

  const TotalTracksWrappedWidget({
    super.key,
    required this.wrapped,
    required this.theme,
  });

  static List<String> getDescriptions(BuildContext context) => [
        context.localization.wrappedTracksMessage1,
        context.localization.wrappedTracksMessage2,
        context.localization.wrappedTracksMessage3,
        context.localization.wrappedTracksMessage4,
        context.localization.wrappedTracksMessage5,
        context.localization.wrappedTracksMessage6,
        context.localization.wrappedTracksMessage7,
      ];

  @override
  State<TotalTracksWrappedWidget> createState() =>
      _TotalTracksWrappedWidgetState();
}

class _TotalTracksWrappedWidgetState extends State<TotalTracksWrappedWidget>
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
    final seed = widget.wrapped.visualSeed.hashCode;
    final layoutRng = Random('${widget.wrapped.visualSeed}_tracks_v3'.hashCode);

    final fmt = NumberFormat.decimalPattern('pt_BR');
    final trackCount = fmt.format(widget.wrapped.totalTracksListened);
    final descriptions = TotalTracksWrappedWidget.getDescriptions(context);
    final description = descriptions[layoutRng.nextInt(descriptions.length)];

    final alignRight = layoutRng.nextBool();

    return WrappedBackground(
      theme: widget.theme,
      seed: seed,
      child: DefaultTextStyle(
        style: TextStyle(
          fontFamily: 'Inter',
          color: palette.text,
        ),
        child: Stack(
          children: [
            Positioned(
              top: -50,
              right: -100,
              child: AnimatedEntry(
                controller: _controller,
                interval: const Interval(0.0, 0.8, curve: Curves.easeOut),
                offset: const Offset(50, 0),
                child: Opacity(
                  opacity: 0.04,
                  child: Icon(
                    LucideIcons.audioWaveform,
                    size: 500,
                    color: palette.text,
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
                    AnimatedEntry(
                      controller: _controller,
                      interval: const Interval(0.0, 0.5),
                      offset: const Offset(0, -10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            context.localization.wrappedDiversity.toUpperCase(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2.5,
                              color: palette.text.withValues(alpha: 0.6),
                            ),
                          ),
                          Icon(LucideIcons.disc,
                              size: 16,
                              color: palette.text.withValues(alpha: 0.6)),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedEntry(
                          controller: _controller,
                          interval: const Interval(0.2, 0.6),
                          child: Text(
                            context.localization.wrappedYouDiscovered,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: palette.text.withValues(alpha: 0.8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _LineReveal(
                          controller: _controller,
                          interval: const Interval(0.3, 0.8,
                              curve: Curves.easeInOutCubic),
                          color: palette.text,
                        ),
                        AnimatedEntry(
                          controller: _controller,
                          interval: const Interval(0.5, 0.9,
                              curve: Curves.elasticOut),
                          isScale: true,
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              trackCount,
                              style: TextStyle(
                                fontSize: 180,
                                fontWeight: FontWeight.w900,
                                height: 1.1,
                                letterSpacing: -8,
                                color: palette.text,
                              ),
                            ),
                          ),
                        ),
                        _LineReveal(
                          controller: _controller,
                          interval: const Interval(0.4, 0.9,
                              curve: Curves.easeInOutCubic),
                          color: palette.text,
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerRight,
                          child: AnimatedEntry(
                            controller: _controller,
                            interval: const Interval(0.6, 1.0),
                            offset: const Offset(20, 0),
                            child: Text(
                              context.localization.wrappedUniqueTracks
                                  .toUpperCase(),
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w300,
                                letterSpacing: -1,
                                color: palette.text,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: alignRight
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        if (!alignRight) ...[
                          _RotatingAsterisk(
                              controller: _controller, palette: palette),
                          const SizedBox(width: 12),
                        ],
                        Flexible(
                          child: AnimatedEntry(
                            controller: _controller,
                            interval:
                                const Interval(0.7, 1.0, curve: Curves.easeOut),
                            offset: const Offset(0, 20),
                            child: SizedBox(
                              width: 200,
                              child: Text(
                                description,
                                textAlign: alignRight
                                    ? TextAlign.right
                                    : TextAlign.left,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  height: 1.4,
                                  color: palette.text.withValues(alpha: 0.9),
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (alignRight) ...[
                          const SizedBox(width: 12),
                          _RotatingAsterisk(
                              controller: _controller, palette: palette),
                        ],
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

class _LineReveal extends StatelessWidget {
  final AnimationController controller;
  final Interval interval;
  final Color color;

  const _LineReveal({
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
          child: Container(
            height: 4,
            color: color,
          ),
        );
      },
    );
  }
}

class _RotatingAsterisk extends StatelessWidget {
  final AnimationController controller;
  final WrappedPalette palette;

  const _RotatingAsterisk({required this.controller, required this.palette});

  @override
  Widget build(BuildContext context) {
    final animation = CurvedAnimation(
        parent: controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOutBack));

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final safeOpacity = animation.value.clamp(0.0, 1.0);

        return Opacity(
          opacity: safeOpacity,
          child: Transform.rotate(
            angle: animation.value * 2 * pi,
            child: Transform.scale(
              scale: animation.value,
              child: Text(
                "*",
                style: TextStyle(
                  fontSize: 40,
                  height: 0.5,
                  color: palette.text,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
