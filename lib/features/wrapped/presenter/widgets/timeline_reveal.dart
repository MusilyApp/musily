import 'package:flutter/material.dart';

class TimelineReveal extends StatelessWidget {
  final AnimationController controller;
  final Interval interval;
  final Color color;
  final double width;
  final double? height;

  const TimelineReveal({
    super.key,
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
