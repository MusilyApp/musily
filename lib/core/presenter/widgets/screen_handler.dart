import 'package:flutter/cupertino.dart';

class ScreenHandler extends StatelessWidget {
  final Widget mobile;
  final Widget? desktop;
  final Widget? tv;
  final Widget? gamepad;

  const ScreenHandler({
    super.key,
    required this.mobile,
    this.desktop,
    this.tv,
    this.gamepad,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: Implement the screen handler
    return mobile;
  }
}
