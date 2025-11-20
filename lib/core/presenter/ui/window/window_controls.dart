import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/presenter/ui/window/ly_window_command_button.dart';
import 'package:window_manager/window_manager.dart';

class WindowControls extends StatefulWidget {
  const WindowControls({super.key});

  @override
  State<WindowControls> createState() => _WindowControlsState();
}

class _WindowControlsState extends State<WindowControls> with WindowListener {
  bool isFocused = true;
  bool isMaximized = false;

  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowFocus() {
    setState(() {
      isFocused = true;
    });
  }

  @override
  void onWindowBlur() {
    setState(() {
      isFocused = false;
    });
  }

  @override
  void onWindowMaximize() {
    setState(() {
      isMaximized = true;
    });
  }

  @override
  void onWindowUnmaximize() {
    setState(() {
      isMaximized = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid || Platform.isIOS) {
      return const SizedBox.shrink();
    }
    return Row(
      children: [
        LyWindowCommandButton(
          onPressed: () => windowManager.close(),
          icon: LucideIcons.x,
          iconSize: 12,
          iconColor: Colors.transparent,
          size: 16,
          isFocused: isFocused,
          backgroundColor: const Color(0xffe8524a),
        ),
        const SizedBox(width: 8),
        LyWindowCommandButton(
          onPressed: () => windowManager.minimize(),
          icon: LucideIcons.minus,
          iconSize: 12,
          iconColor: Colors.transparent,
          size: 16,
          isFocused: isFocused,
          backgroundColor: const Color(0xfff0ae1b),
        ),
        const SizedBox(width: 8),
        LyWindowCommandButton(
          onPressed: () => isMaximized
              ? windowManager.unmaximize()
              : windowManager.maximize(),
          icon: isMaximized ? LucideIcons.copy : LucideIcons.maximize,
          iconSize: 12,
          iconColor: Colors.transparent,
          size: 16,
          isFocused: isFocused,
          backgroundColor: const Color(0xff59c836),
        ),
      ],
    );
  }
}
