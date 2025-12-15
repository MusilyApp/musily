import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/features/wrapped/domain/entities/wrapped_entity.dart';
import 'package:musily/features/wrapped/presenter/utils/wrapped_theme.dart';
import 'package:musily/features/wrapped/presenter/widgets/animated_entry.dart';
import 'package:musily/features/wrapped/presenter/widgets/wrapped_background.dart';

class TotalMinutesWrappedWidget extends StatefulWidget {
  final WrappedEntity wrapped;
  final WrappedTheme theme;

  const TotalMinutesWrappedWidget({
    super.key,
    required this.wrapped,
    required this.theme,
  });

  static List<String> getDescriptions(BuildContext context) => [
        context.localization.wrappedMinutesMessage1,
        context.localization.wrappedMinutesMessage2,
        context.localization.wrappedMinutesMessage3,
        context.localization.wrappedMinutesMessage4,
        context.localization.wrappedMinutesMessage5,
        context.localization.wrappedMinutesMessage6,
        context.localization.wrappedMinutesMessage7,
      ];

  @override
  State<TotalMinutesWrappedWidget> createState() =>
      _TotalMinutesWrappedWidgetState();
}

class _TotalMinutesWrappedWidgetState extends State<TotalMinutesWrappedWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
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
    final layoutRng =
        Random('${widget.wrapped.visualSeed}_minutes_v3'.hashCode);

    final fmt = NumberFormat.decimalPattern('pt_BR');
    final minutes = fmt.format(widget.wrapped.totalMinutesListened);
    final descriptions = TotalMinutesWrappedWidget.getDescriptions(context);
    final description = descriptions[layoutRng.nextInt(descriptions.length)];

    final bool textOnTop = layoutRng.nextBool();

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
              right: -100,
              top: textOnTop ? -50 : null,
              bottom: textOnTop ? null : -50,
              child: AnimatedEntry(
                controller: _controller,
                interval: const Interval(0.0, 0.6, curve: Curves.easeOut),
                isScale: true,
                child: Container(
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        palette.text.withValues(alpha: 0.15),
                        palette.text.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedEntry(
                      controller: _controller,
                      interval: const Interval(0.0, 0.5, curve: Curves.easeOut),
                      offset: const Offset(0, -20),
                      child: Row(
                        children: [
                          Icon(LucideIcons.clock,
                              size: 16,
                              color: palette.text.withValues(alpha: 0.7)),
                          const SizedBox(width: 8),
                          Text(
                            context.localization.wrappedTotalTime.toUpperCase(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2.0,
                              color: palette.text.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    AnimatedEntry(
                      controller: _controller,
                      interval:
                          const Interval(0.2, 0.8, curve: Curves.easeOutExpo),
                      offset: const Offset(0, 50),
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          minutes,
                          style: TextStyle(
                            fontSize: 200,
                            fontWeight: FontWeight.w900,
                            height: 1.0,
                            letterSpacing: -6.0,
                            color: palette.text,
                          ),
                        ),
                      ),
                    ),
                    AnimatedEntry(
                      controller: _controller,
                      interval:
                          const Interval(0.4, 0.9, curve: Curves.easeOutCubic),
                      offset: const Offset(0, 30),
                      child: Text(
                        context.localization.wrappedMinutesLabel,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w300,
                          color: palette.text,
                          letterSpacing: -1.0,
                          height: 0.8,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    AnimatedEntry(
                      controller: _controller,
                      interval: const Interval(0.6, 1.0, curve: Curves.easeOut),
                      offset: const Offset(0, 20),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Text(
                          description,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                            color: palette.text.withValues(alpha: 0.9),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
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
