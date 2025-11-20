import 'package:flutter/material.dart';

class LyIconButton extends StatelessWidget {
  final void Function()? onPressed;
  final Widget? icon;
  final double? size;
  const LyIconButton({super.key, this.onPressed, this.icon, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(width: size, height: size, child: Center(child: icon)),
    );
  }
}
