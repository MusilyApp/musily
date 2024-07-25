import 'package:flutter/material.dart';

class CoreMethods {
  final void Function(Widget widget) pushWidget;
  final void Function(Widget widget) pushModal;
  final void Function() closeDialog;

  CoreMethods({
    required this.pushWidget,
    required this.pushModal,
    required this.closeDialog,
  });
}
