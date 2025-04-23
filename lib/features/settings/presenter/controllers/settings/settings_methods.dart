import 'package:flutter/material.dart';
import 'package:musily/features/settings/domain/enums/close_preference.dart';

class SettingsMethods {
  final Future<void> Function(
    String? locale,
  ) changeLanguage;
  final void Function(ThemeMode? mode) changeTheme;
  final Future<void> Function() loadLanguage;
  final Future<void> Function() loadThemeMode;
  final void Function() setBrightness;
  final void Function() getClosePreference;
  final void Function(ClosePreference preference) setClosePreference;

  SettingsMethods({
    required this.changeLanguage,
    required this.changeTheme,
    required this.loadLanguage,
    required this.loadThemeMode,
    required this.setBrightness,
    required this.getClosePreference,
    required this.setClosePreference,
  });
}
