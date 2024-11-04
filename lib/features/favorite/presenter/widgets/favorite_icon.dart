import 'package:flutter/material.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';

class FavoriteIcon extends StatefulWidget {
  final double size;
  final double? iconSize;
  final bool animated;

  const FavoriteIcon({
    super.key,
    this.size = 50,
    this.iconSize,
    this.animated = false,
  });

  @override
  State<FavoriteIcon> createState() => _FavoriteIconState();
}

class _FavoriteIconState extends State<FavoriteIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutCubic,
      ),
    );

    if (widget.animated) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant FavoriteIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animated != oldWidget.animated) {
      widget.animated ? _controller.repeat(reverse: true) : _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.transparent,
            context.themeData.buttonTheme.colorScheme?.primary ?? Colors.white,
          ],
        ),
      ),
      child: Center(
        child: ScaleTransition(
          scale: widget.animated
              ? _scaleAnimation
              : const AlwaysStoppedAnimation(1.0),
          child: Icon(
            Icons.favorite_rounded,
            color: Colors.white,
            size: widget.iconSize ?? widget.size * 0.6,
          ),
        ),
      ),
    );
  }
}
