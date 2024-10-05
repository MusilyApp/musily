import 'package:flutter/material.dart';

class AppMenuEntry {
  final Widget? leading;
  final Widget title;
  final Widget? trailing;
  final void Function()? onTap;

  AppMenuEntry({
    this.leading,
    required this.title,
    this.trailing,
    this.onTap,
  });
}
