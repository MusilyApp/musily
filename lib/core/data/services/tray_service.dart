import 'dart:io';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/material.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:tray_manager/tray_manager.dart';

class TrayService {
  static Future<void> init() async {
    late final String icon;

    if (Platform.isWindows) {
      icon = 'assets/icons/tray/tray_icon_windows.ico';
    } else if (runningInSandbox()) {
      icon = 'musily_tray';
    } else {
      icon = 'assets/icons/tray/tray_icon.png';
    }
    Menu menu = Menu(
      items: [
        MenuItem(
          key: 'show_window',
          label: 'Show Window',
        ),
        MenuItem.separator(),
        MenuItem(
          key: 'exit_app',
          label: 'Exit App',
        ),
      ],
    );
    await trayManager.setIcon(icon);
    if (!Platform.isWindows) {
      await trayManager.setTitle('Musily');
    }
    await trayManager.setContextMenu(menu);
  }

  static Future<void> initContextMenu(
    BuildContext context, {
    Locale? locale,
  }) async {
    if (Platform.isAndroid || Platform.isIOS) {
      return;
    }
    late final AppLocalizations localization;
    if (locale != null) {
      localization = await AppLocalizations.delegate.load(locale);
    } else {
      localization = context.localization;
    }
    Menu menu = Menu(
      items: [
        MenuItem(
          key: 'show_window',
          label: localization.showWindow,
        ),
        MenuItem.separator(),
        MenuItem(
          key: 'library',
          label: localization.library,
        ),
        MenuItem(
          key: 'settings',
          label: localization.settings,
        ),
        MenuItem(
          key: 'downloads',
          label: localization.downloads,
        ),
        MenuItem.separator(),
        MenuItem(
          key: 'exit_app',
          label: localization.closeWindow,
        ),
      ],
    );
    await trayManager.setContextMenu(menu);
  }

  static bool runningInSandbox() {
    return Platform.environment.containsKey('FLATPAK_ID') ||
        Platform.environment.containsKey('SNAP');
  }
}
