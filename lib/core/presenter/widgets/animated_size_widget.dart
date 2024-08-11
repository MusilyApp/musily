import 'package:flutter/material.dart';

class AnimatedSizeWidget extends StatefulWidget {
  final Widget child;
  final double width;
  final double height;

  const AnimatedSizeWidget({
    super.key,
    required this.child,
    required this.width,
    required this.height,
  });

  @override
  State<AnimatedSizeWidget> createState() => _AnimatedSizeWidgetState();
}

class _AnimatedSizeWidgetState extends State<AnimatedSizeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _widthAnimation;
  late Animation<double> _heightAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _widthAnimation = Tween<double>(begin: widget.width, end: widget.width)
        .animate(_animationController);
    _heightAnimation = Tween<double>(begin: widget.height, end: widget.height)
        .animate(_animationController);
  }

  @override
  void didUpdateWidget(covariant AnimatedSizeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _widthAnimation =
        Tween<double>(begin: _widthAnimation.value, end: widget.width)
            .animate(_animationController);
    _heightAnimation =
        Tween<double>(begin: _heightAnimation.value, end: widget.height)
            .animate(_animationController);
    _animationController.forward(from: 0.0);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
      width: _widthAnimation.value,
      height: _heightAnimation.value,
      child: widget.child,
    );
  }
}
