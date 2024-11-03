import 'package:flutter/material.dart';

class AnimatedSizeWidget extends StatefulWidget {
  final Widget child;
  final double? width;
  final double? height;
  final Duration? duration;
  final Color? color;
  final BorderRadiusGeometry? borderRadius;

  const AnimatedSizeWidget({
    super.key,
    required this.child,
    required this.width,
    required this.height,
    this.borderRadius,
    this.color,
    this.duration,
  });

  @override
  State<AnimatedSizeWidget> createState() => _AnimatedSizeWidgetState();
}

class _AnimatedSizeWidgetState extends State<AnimatedSizeWidget> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: widget.duration ?? const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: widget.borderRadius,
      ),
      width: widget.width,
      height: widget.height,
      child: widget.child,
    );
  }
}
