import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:musily/features/settings/domain/enums/close_preference.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

class WindowState {
  final double dx;
  final double dy;
  final bool isMaximized;
  final bool isFullScreen;
  final double width;
  final double height;

  WindowState({
    required this.isMaximized,
    required this.isFullScreen,
    required this.width,
    required this.height,
    required this.dx,
    required this.dy,
  });

  Map<String, dynamic> toMap() {
    return {
      'isMaximized': isMaximized,
      'isFullScreen': isFullScreen,
      'width': width,
      'height': height,
      'dx': dx,
      'dy': dy,
    };
  }

  factory WindowState.fromMap(Map<String, dynamic> map) {
    return WindowState(
      isMaximized: map['isMaximized'] ?? false,
      isFullScreen: map['isFullScreen'] ?? false,
      width: map['width']?.toDouble() ?? 1280.0,
      height: map['height']?.toDouble() ?? 720.0,
      dx: map['dx']?.toDouble() ?? 0.0,
      dy: map['dy']?.toDouble() ?? 0.0,
    );
  }

  factory WindowState.fromJson(String source) =>
      WindowState.fromMap(jsonDecode(source));

  String toJson() => jsonEncode(toMap());
}

class WindowService {
  static final WindowService _instance = WindowService._internal();
  factory WindowService() => _instance;
  WindowService._internal();

  String windowTitle = 'Musily';
  String currentTitle = 'Musily';

  bool isMaximized = false;

  static Future<void> init() async {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
        size: Size(1280, 720),
        center: true,
        backgroundColor: Colors.transparent,
        skipTaskbar: false,
        titleBarStyle: TitleBarStyle.hidden,
        minimumSize: Size(800, 720),
        title: 'Musily',
        windowButtonVisibility: false);
    await _instance.loadLastWindowState();
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
    WindowService().isMaximized = await windowManager.isMaximized();
  }

  static Future<void> saveLastWindowState() async {
    final position = await windowManager.getPosition();
    final size = await windowManager.getSize();
    final isMaximized = await windowManager.isMaximized();
    final isFullScreen = await windowManager.isFullScreen();

    final lastState = WindowState(
      isMaximized: isMaximized,
      isFullScreen: isFullScreen,
      width: size.width,
      height: size.height,
      dx: position.dx,
      dy: position.dy,
    );

    final prefs = await SharedPreferences.getInstance();

    prefs.setString(
      'lastWindowState',
      lastState.toJson(),
    );

    WindowService().windowTitle = '${WindowService().windowTitle} - $position';
  }

  Future<void> loadLastWindowState() async {
    final prefs = await SharedPreferences.getInstance();
    final lastStateString = prefs.getString('lastWindowState');
    if (lastStateString != null) {
      final lastState = WindowState.fromJson(lastStateString);
      await windowManager.setSize(Size(lastState.width, lastState.height));
      await windowManager.setPosition(Offset(lastState.dx, lastState.dy));
      if (lastState.isMaximized) {
        await windowManager.maximize();
      } else {
        await windowManager.restore();
      }
    }
  }

  static Future<void> setPreventClose(ClosePreference preference) async {
    if (Platform.isAndroid || Platform.isIOS) {
      return;
    }
    if (preference == ClosePreference.close) {
      await windowManager.setPreventClose(false);
    } else {
      await windowManager.setPreventClose(true);
    }
  }

  static Future<void> close(ClosePreference preference) async {
    if (preference == ClosePreference.close) {
      exit(0);
    } else {
      windowManager.hide();
    }
  }

  static Future<void> showWindow() async {
    windowManager.show();
    windowManager.focus();
  }

  static Future<void> focus() async {
    windowManager.focus();
  }

  static Future<void> setWindowTitle(
    String title, {
    bool defaultTitle = false,
  }) async {
    if (Platform.isAndroid || Platform.isIOS) {
      return;
    }
    if (title == WindowService().currentTitle && !defaultTitle) {
      return;
    }
    if (defaultTitle) {
      await windowManager.setTitle(WindowService().windowTitle);
      WindowService().currentTitle = WindowService().windowTitle;
    }
    await windowManager.setTitle(title);
    WindowService().currentTitle = title;
  }
}
