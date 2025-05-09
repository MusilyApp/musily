import 'package:flutter/material.dart';

import 'package:musily/core/domain/presenter/app_controller.dart';
import 'package:musily/features/settings/domain/enums/accent_color_preference.dart';
import 'package:musily/features/settings/domain/enums/close_preference.dart';

class SettingsData implements BaseControllerData {
  Locale? locale;
  ThemeMode? themeMode;
  BuildContext? context;
  ClosePreference closePreference;
  AccentColorPreference accentColorPreference;

  SettingsData({
    this.locale,
    this.themeMode,
    this.context,
    this.closePreference = ClosePreference.hide,
    this.accentColorPreference = AccentColorPreference.system,
  });

  @override
  SettingsData copyWith({
    Locale? locale,
    ThemeMode? themeMode,
    BuildContext? context,
    ClosePreference? closePreference,
    AccentColorPreference? accentColorPreference,
  }) {
    return SettingsData(
      locale: locale ?? this.locale,
      themeMode: themeMode ?? this.themeMode,
      context: context ?? this.context,
      closePreference: closePreference ?? this.closePreference,
      accentColorPreference:
          accentColorPreference ?? this.accentColorPreference,
    );
  }
}
