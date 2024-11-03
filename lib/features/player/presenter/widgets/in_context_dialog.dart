import 'package:flutter/material.dart';

class InContextDialog extends StatefulWidget {
  final Widget child;
  final bool show;
  final Duration duration;
  final Curve curve;
  final double? width;
  final double? height;

  const InContextDialog({
    super.key,
    required this.child,
    required this.show,
    this.duration = const Duration(
      milliseconds: 200,
    ),
    this.curve = Curves.easeInOut,
    this.height,
    this.width,
  });

  @override
  State<InContextDialog> createState() => _InContextDialogState();
}

class _InContextDialogState extends State<InContextDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
      value: widget.show ? 1.0 : 0.0,
    );
    _animation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void didUpdateWidget(covariant InContextDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.show != oldWidget.show) {
      if (widget.show) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? MediaQuery.of(context).size.width,
      height: widget.height,
      child: Stack(
        children: [
          SlideTransition(
            position: _animation,
            child: Container(
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}
