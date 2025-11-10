import 'package:flutter/material.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';

class LyWindowCommandButton extends StatelessWidget {
  final bool isFocused;
  final Color? backgroundColor;
  final double iconSize;
  final double size;
  final Color? iconColor;

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

  final Function onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: Size.square(size),
      child: Material(
        color: backgroundColor ??
            context.themeData.focusColor.withValues(alpha: .1),
        shape: const CircleBorder(),
        child: IconButton(
          // color: ,
          icon: Icon(icon, color: iconColor),
          iconSize: iconSize,
          padding: EdgeInsets.zero,
          onPressed: () => onPressed(),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
        ),
      ),
    );
  }
}
