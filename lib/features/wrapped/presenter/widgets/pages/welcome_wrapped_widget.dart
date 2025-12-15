import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/features/wrapped/domain/entities/wrapped_entity.dart';
import 'package:musily/features/wrapped/presenter/utils/wrapped_theme.dart';
import 'package:musily/features/wrapped/presenter/widgets/animated_entry.dart';
import 'package:musily/features/wrapped/presenter/widgets/wrapped_background.dart';

enum _WelcomeLayout { magazine, minimal, typographic }

class WelcomeWrappedWidget extends StatefulWidget {
  final WrappedEntity wrapped;
  final WrappedTheme theme;

  const WelcomeWrappedWidget({
    super.key,
    required this.wrapped,
    required this.theme,
  });

  static List<String> getWelcomeMessages(BuildContext context) => [
        context.localization.wrappedWelcome1,
        context.localization.wrappedWelcome2,
        context.localization.wrappedWelcome3,
        context.localization.wrappedWelcome4,
        context.localization.wrappedWelcome5,
        context.localization.wrappedWelcome6,
        context.localization.wrappedWelcome7,
      ];

  @override
  State<WelcomeWrappedWidget> createState() => _WelcomeWrappedWidgetState();
}

class _WelcomeWrappedWidgetState extends State<WelcomeWrappedWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
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
        Random('\${widget.wrapped.visualSeed}_welcome_v3'.hashCode);

    final welcomeMessages = WelcomeWrappedWidget.getWelcomeMessages(context);
    final message = welcomeMessages[layoutRng.nextInt(welcomeMessages.length)];

    final layout =
        _WelcomeLayout.values[layoutRng.nextInt(_WelcomeLayout.values.length)];

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
                interval: const Interval(0.0, 0.5),
                child:
                    Container(color: palette.background.withValues(alpha: 0.2)),
              ),
            ),
            if (layout == _WelcomeLayout.magazine)
              _MagazineLayout(
                controller: _controller,
                context: context,
                message: message,
                palette: palette,
                year: widget.wrapped.rangeEnd.year,
              )
            else if (layout == _WelcomeLayout.typographic)
              _TypographicLayout(
                controller: _controller,
                context: context,
                message: message,
                palette: palette,
                year: widget.wrapped.rangeEnd.year,
              )
            else
              _MinimalLayout(
                controller: _controller,
                message: message,
                palette: palette,
                year: widget.wrapped.rangeEnd.year,
              ),
            Positioned(
              right: 16,
              bottom: 12,
              child: AnimatedEntry(
                controller: _controller,
                interval: const Interval(0.7, 1.0),
                offset: const Offset(0, 10),
                child: Text(
                  'musily.app',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                    color: palette.text.withValues(alpha: 0.3),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: MediaQuery.of(context).padding.bottom + 24,
              child: Center(
                child: AnimatedEntry(
                  controller: _controller,
                  interval:
                      const Interval(0.85, 1.0, curve: Curves.easeOutBack),
                  isScale: true,
                  child: _SwipeIndicator(
                    palette: palette,
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

class _MagazineLayout extends StatelessWidget {
  final AnimationController controller;
  final BuildContext context;
  final String message;
  final WrappedPalette palette;
  final int year;

  const _MagazineLayout({
    required this.controller,
    required this.context,
    required this.message,
    required this.palette,
    required this.year,
  });

  @override
  Widget build(BuildContext _) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedEntry(
              controller: controller,
              interval: const Interval(0.0, 0.6, curve: Curves.easeOut),
              offset: const Offset(0, -20),
              child: Row(
                children: [
                  Text(
                    context.localization.wrappedEdition.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: palette.text.withValues(alpha: 0.6),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    context.localization.wrappedVolume(year),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: palette.text.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            AnimatedEntry(
              controller: controller,
              interval: const Interval(0.2, 0.7, curve: Curves.easeInOut),
              child: Container(height: 4, color: palette.text),
            ),
            const Spacer(),
            AnimatedEntry(
              controller: controller,
              interval: const Interval(0.3, 0.8, curve: Curves.easeOutQuart),
              offset: const Offset(0, 50),
              child: Text(
                "MUSILY\nWRAPPED",
                style: TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.w900,
                  height: 0.9,
                  letterSpacing: -3,
                  color: palette.text,
                ),
              ),
            ),
            const SizedBox(height: 24),
            AnimatedEntry(
              controller: controller,
              interval: const Interval(0.5, 0.9),
              child: Container(width: 40, height: 4, color: palette.text),
            ),
            const SizedBox(height: 24),
            AnimatedEntry(
              controller: controller,
              interval: const Interval(0.6, 1.0, curve: Curves.easeOutBack),
              offset: const Offset(0, 30),
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: palette.text.withValues(alpha: 0.8),
                ),
              ),
            ),
            const Spacer(),
            Center(
              child: AnimatedEntry(
                controller: controller,
                interval: const Interval(0.8, 1.0),
                offset: const Offset(0, -10),
                child: Icon(LucideIcons.arrowDown,
                    color: palette.text.withValues(alpha: 0.5), size: 32),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypographicLayout extends StatelessWidget {
  final AnimationController controller;
  final BuildContext context;
  final String message;
  final WrappedPalette palette;
  final int year;

  const _TypographicLayout({
    required this.controller,
    required this.context,
    required this.message,
    required this.palette,
    required this.year,
  });

  @override
  Widget build(BuildContext _) {
    return Stack(
      children: [
        Positioned(
          left: -40,
          bottom: 100,
          child: AnimatedEntry(
            controller: controller,
            interval: const Interval(0.0, 1.0),
            offset: const Offset(-50, 0),
            child: RotatedBox(
              quarterTurns: 3,
              child: Text(
                year.toString(),
                style: TextStyle(
                  fontSize: 350,
                  fontWeight: FontWeight.w900,
                  height: 1.0,
                  letterSpacing: -10,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 2
                    ..color = palette.text.withValues(alpha: 0.1),
                ),
              ),
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                Center(
                  child: AnimatedEntry(
                    controller: controller,
                    interval:
                        const Interval(0.2, 0.7, curve: Curves.elasticOut),
                    isScale: true,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: palette.text,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        context.localization.wrappedRetrospective.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          color: palette.background,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                AnimatedEntry(
                  controller: controller,
                  interval: const Interval(0.4, 0.9, curve: Curves.easeOutExpo),
                  offset: const Offset(0, 100),
                  child: Text(
                    message.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.w900,
                      height: 1.0,
                      letterSpacing: -2,
                      color: palette.text,
                      shadows: [
                        Shadow(
                          color: palette.background.withValues(alpha: 0.5),
                          blurRadius: 15,
                        )
                      ],
                    ),
                  ),
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MinimalLayout extends StatelessWidget {
  final AnimationController controller;
  final String message;
  final WrappedPalette palette;
  final int year;

  const _MinimalLayout({
    required this.controller,
    required this.message,
    required this.palette,
    required this.year,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedEntry(
              controller: controller,
              interval: const Interval(0.1, 0.7, curve: Curves.easeOutBack),
              isScale: true,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: palette.text.withValues(alpha: 0.2), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: palette.text.withValues(alpha: 0.1),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    LucideIcons.play,
                    size: 48,
                    color: palette.text,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 60),
            AnimatedEntry(
              controller: controller,
              interval: const Interval(0.4, 0.8),
              offset: const Offset(0, 20),
              child: Text(
                year.toString(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 8,
                  color: palette.text.withValues(alpha: 0.5),
                ),
              ),
            ),
            const SizedBox(height: 16),
            AnimatedEntry(
              controller: controller,
              interval: const Interval(0.5, 1.0, curve: Curves.easeOutCubic),
              offset: const Offset(0, 40),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w300,
                  letterSpacing: -0.5,
                  color: palette.text,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SwipeIndicator extends StatefulWidget {
  final WrappedPalette palette;

  const _SwipeIndicator({required this.palette});

  @override
  State<_SwipeIndicator> createState() => _SwipeIndicatorState();
}

class _SwipeIndicatorState extends State<_SwipeIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _bounceAnimation = Tween<double>(begin: 0, end: -8).animate(
      CurvedAnimation(
        parent: _bounceController,
        curve: Curves.easeInOut,
      ),
    );

    _bounceController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _bounceAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _bounceAnimation.value),
          child: child,
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            LucideIcons.chevronUp,
            size: 24,
            color: widget.palette.text.withValues(alpha: 0.7),
          ),
          const SizedBox(height: 4),
          Text(
            context.localization.wrappedSwipeUp,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: widget.palette.text.withValues(alpha: 0.6),
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
