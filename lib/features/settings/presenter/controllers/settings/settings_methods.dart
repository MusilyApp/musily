import 'package:flutter/material.dart';

class SettingsMethods {
  final Future<void> Function(
    String? locale,
  ) changeLanguage;
  final void Function(ThemeMode? mode) changeTheme;
  final Future<void> Function() loadLanguage;
  final Future<void> Function() loadThemeMode;

  SettingsMethods({
    required this.changeLanguage,
    required this.changeTheme,
    required this.loadLanguage,
    required this.loadThemeMode,
  });
}
