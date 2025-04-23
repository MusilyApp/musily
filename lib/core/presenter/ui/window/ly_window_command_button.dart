import 'package:flutter/material.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';

class LyWindowCommandButton extends StatelessWidget {
  final bool isFocused;
  const LyWindowCommandButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.isFocused,
  });

  final Function onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: const Size.square(24),
      child: Material(
        color: context.themeData.focusColor.withValues(alpha: .1),
        shape: const CircleBorder(),
        child: IconButton(
          // color: ,
          icon: Icon(icon),
          iconSize: 14,
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
