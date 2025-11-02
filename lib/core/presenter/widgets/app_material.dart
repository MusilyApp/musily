import 'dart:io';

import 'package:dynamic_color/dynamic_color.dart';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:musily/core/data/services/window_service.dart';
import 'package:musily/features/settings/domain/enums/accent_color_preference.dart';
import 'package:musily/features/settings/domain/enums/close_preference.dart';
import 'package:musily/features/settings/presenter/controllers/settings/settings_controller.dart';
import 'package:musily/features/settings/presenter/controllers/settings/settings_data.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppMaterial extends StatefulWidget {
  const AppMaterial({super.key});

  @override
  State<AppMaterial> createState() => _AppMaterialState();
}

class _AppMaterialState extends State<AppMaterial>
    with WidgetsBindingObserver, TrayListener, WindowListener {
  final settingsController = Modular.get<SettingsController>();

  @override
  void initState() {
    super.initState();
    trayManager.addListener(this);
    windowManager.addListener(this);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    trayManager.removeListener(this);
    windowManager.removeListener(this);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    setState(() {
      if (state == AppLifecycleState.resumed) {
        settingsController.methods.setBrightness();
      }
    });
  }

  @override
  void onTrayIconMouseDown() {
    super.onTrayIconMouseDown();
    WindowService.showWindow();
  }

  @override
  void onTrayIconRightMouseDown() {
    super.onTrayIconRightMouseDown();
    trayManager.popUpContextMenu();
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    if (menuItem.key == 'show_window') {
      WindowService.showWindow();
    } else if (menuItem.key == 'exit_app') {
      WindowService.close(ClosePreference.close);
    }
  }

  @override
  void onWindowClose() {
    super.onWindowClose();
    WindowService.close(settingsController.data.closePreference);
  }

  @override
  void onWindowMaximize() {
    super.onWindowMaximize();
    WindowService().isMaximized = true;
  }

  @override
  void onWindowUnmaximize() {
    super.onWindowUnmaximize();
    WindowService().isMaximized = false;
  }

  @override
  onWindowEvent(String event) {
    super.onWindowEvent(event);
    WindowService.saveLastWindowState();
  }

  getMaterialApp(
    Color accentColor,
    SettingsData data, {
    ColorScheme? dakColorScheme,
    ColorScheme? lightColorScheme,
  }) {
    return MaterialApp.router(
      locale: data.locale,
      themeMode: data.themeMode,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme:
            lightColorScheme ?? ColorScheme.fromSeed(seedColor: accentColor),
        useMaterial3: true,
        cardTheme: const CardThemeData(shadowColor: Colors.transparent),
      ),
      darkTheme: ThemeData(
        colorScheme: dakColorScheme ??
        colorScheme: dakColorScheme ??
            ColorScheme.fromSeed(
              seedColor: accentColor,
              brightness: Brightness.dark,
            ),
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
        ),
        cardTheme: const CardThemeData(color: Color.fromARGB(255, 10, 10, 10)),
      ),
      routerConfig: Modular.routerConfig,
    );
  }

  @override
  Widget build(BuildContext context) {
    Modular.setInitialRoute('/sections/');
    return settingsController.builder(
      builder: (context, data) {
        if (Platform.isAndroid) {
          return DynamicColorBuilder(
            builder: (lightDynamic, darkDynamic) {
              return getMaterialApp(
                data.accentColorPreference == AccentColorPreference.defaultColor
                    ? Colors.deepPurple
                    : data.accentColorPreference == AccentColorPreference.system
                        ? Theme.of(context).colorScheme.primary
                        : Colors.deepPurple,
                        ? Theme.of(context).colorScheme.primary
                        : Colors.deepPurple,
                data,
                dakColorScheme: data.accentColorPreference ==
                        AccentColorPreference.defaultColor
                    ? ColorScheme.fromSeed(
                        seedColor: Colors.deepPurple,
                        brightness: Brightness.dark,
                      )
                    : darkDynamic,
                lightColorScheme: data.accentColorPreference ==
                        AccentColorPreference.defaultColor
                    ? ColorScheme.fromSeed(
                        seedColor: Colors.deepPurple,
                        brightness: Brightness.light,
                      )
                    : lightDynamic,
                dakColorScheme: data.accentColorPreference ==
                        AccentColorPreference.defaultColor
                    ? ColorScheme.fromSeed(
                        seedColor: Colors.deepPurple,
                        brightness: Brightness.dark,
                      )
                    : darkDynamic,
                lightColorScheme: data.accentColorPreference ==
                        AccentColorPreference.defaultColor
                    ? ColorScheme.fromSeed(
                        seedColor: Colors.deepPurple,
                        brightness: Brightness.light,
                      )
                    : lightDynamic,
              );
            },
          );
        }
        if (Platform.isIOS) {
          return getMaterialApp(
            data.accentColorPreference == AccentColorPreference.defaultColor
                ? Colors.deepPurple
                : data.accentColorPreference == AccentColorPreference.system
                    ? Theme.of(context).colorScheme.primary
                    : Colors.deepPurple,
                    ? Theme.of(context).colorScheme.primary
                    : Colors.deepPurple,
            data,
          );
        }
        return FutureBuilder(
          future: DynamicColorPlugin.getAccentColor(),
          builder: (context, snapshot) {
            late final Color accentColor;
            if (data.accentColorPreference == AccentColorPreference.system) {
              accentColor = snapshot.data ?? Colors.deepPurple;
            } else {
              accentColor = data.accentColorPreference ==
                      AccentColorPreference.defaultColor
                  ? Colors.deepPurple
                  : Theme.of(context).colorScheme.primary;
              accentColor = data.accentColorPreference ==
                      AccentColorPreference.defaultColor
                  ? Colors.deepPurple
                  : Theme.of(context).colorScheme.primary;
            }
            return getMaterialApp(accentColor, data);
          },
        );
      },
    );
  }
}
