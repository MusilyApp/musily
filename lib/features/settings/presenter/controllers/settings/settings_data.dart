import 'package:flutter/material.dart';
import 'package:musily/core/domain/presenter/app_controller.dart';

class SettingsData implements BaseControllerData {
  Locale? locale;
  ThemeMode? themeMode;
  BuildContext? context;
  SettingsData({
    this.locale,
    this.themeMode,
    this.context,
  });

  @override
  SettingsData copyWith() {
    return this;
  }
}
