// ignore_for_file: public_member_api_docs, sort_constructors_first
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
  SettingsData copyWith({
    Locale? locale,
    ThemeMode? themeMode,
    BuildContext? context,
  }) {
    return SettingsData(
      locale: locale ?? this.locale,
      themeMode: themeMode ?? this.themeMode,
      context: context ?? this.context,
    );
  }
}
