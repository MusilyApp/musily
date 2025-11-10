import 'dart:io';

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class DraggableBox extends StatefulWidget {
  final Widget child;
  final Function? onWindowResize;

  const DraggableBox({super.key, required this.child, this.onWindowResize});

  @override
  State<DraggableBox> createState() => _DraggableBoxState();
}

class _DraggableBoxState extends State<DraggableBox> with WindowListener {
  bool isFocused = true;
  bool isMaximized = false;
  @override
  void initState() {
    windowManager.setTitleBarStyle(TitleBarStyle.hidden);
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
  Future<void> onWindowResize() async {
    if (widget.onWindowResize != null) {
      widget.onWindowResize!(await windowManager.getSize());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid || Platform.isIOS) {
      return widget.child;
    }
    return GestureDetector(
      onPanStart: (_) => onPanStart(),
      onDoubleTap: () => onDoubleTap(),
      child: widget.child,
    );
  }

  void onPanStart() async => await windowManager.startDragging();
  void onDoubleTap() async => isMaximized
      ? await windowManager.unmaximize()
      : await windowManager.maximize();
}
