import 'package:flutter/material.dart';

class AnimatedEntry extends StatelessWidget {
  final AnimationController controller;
  final Interval interval;
  final Widget child;
  final Offset offset;
  final bool isScale;

  const AnimatedEntry({
    super.key,
    required this.controller,
    required this.interval,
    required this.child,
    this.offset = const Offset(0, 0),
    this.isScale = false,
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
        final safeOpacity = animation.value.clamp(0.0, 1.0);

        if (isScale) {
          return Opacity(
            opacity: safeOpacity,
            child: Transform.scale(
              scale: animation.value,
              child: child,
            ),
          );
        }

        final currentOffset =
            Offset.lerp(offset, Offset.zero, animation.value)!;
        return Opacity(
          opacity: safeOpacity,
          child: Transform.translate(
            offset: currentOffset,
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
