import 'dart:io';

import 'package:flutter/material.dart';
import 'package:musily/features/settings/domain/enums/close_preference.dart';
import 'package:window_manager/window_manager.dart';

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
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
    WindowService().isMaximized = await windowManager.isMaximized();
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

  static Future<void> setWindowTitle(
    String title, {
    bool defaultTitle = false,
  }) async {
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
