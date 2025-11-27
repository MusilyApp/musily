import 'package:flutter/material.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';

class LyWindowCommandButton extends StatefulWidget {
  final bool isFocused;
  final Color? backgroundColor;
  final double iconSize;
  final double size;
  final Color? iconColor;
  final Function onPressed;
  final IconData icon;

  const LyWindowCommandButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.isFocused,
    this.backgroundColor,
    this.iconSize = 14,
    this.size = 24,
    this.iconColor,
  });

  @override
  State<LyWindowCommandButton> createState() => _LyWindowCommandButtonState();
}

class _LyWindowCommandButtonState extends State<LyWindowCommandButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          _isHovered = false;
        });
      },
      child: SizedBox.fromSize(
        size: Size.square(widget.size),
        child: Material(
          color: widget.backgroundColor ??
              context.themeData.focusColor.withValues(alpha: .1),
          shape: const CircleBorder(),
          child: IconButton(
            icon: AnimatedOpacity(
              opacity: _isHovered ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeInOut,
              child: Icon(widget.icon, color: widget.iconColor),
            ),
            iconSize: widget.iconSize,
            padding: EdgeInsets.zero,
            onPressed: () => widget.onPressed(),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
          ),
        ),
      ),
    );
  }
}
