import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:musily/features/settings/presenter/controllers/settings/settings_controller.dart';

ThemeMode getThemeMode(BuildContext context) {
  final SettingsController controller = Modular.get<SettingsController>();
  final themeMode = controller.data.themeMode ?? ThemeMode.system;
  if (themeMode == ThemeMode.system) {
    final brightness = MediaQuery.of(context).platformBrightness;
    return brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
  }
  return themeMode;
}
