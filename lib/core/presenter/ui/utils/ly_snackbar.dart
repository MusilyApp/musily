import 'package:flutter/material.dart';
import 'package:musily/core/presenter/ui/utils/ly_navigator.dart';

class LySnackbar {
  static void show(String message) {
    final contextManager = ContextManager();
    final context = contextManager.contextStack.last.context;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
        ),
      ),
    );
  }
}
