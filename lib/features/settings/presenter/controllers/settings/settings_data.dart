import 'package:flutter/material.dart';

import 'package:musily/core/domain/presenter/app_controller.dart';
import 'package:musily/features/settings/domain/entities/supporter_entity.dart';
import 'package:musily/features/settings/domain/enums/accent_color_preference.dart';
import 'package:musily/features/settings/domain/enums/close_preference.dart';

class SettingsData implements BaseControllerData {
  Locale? locale;
  ThemeMode? themeMode;
  BuildContext? context;
  ClosePreference closePreference;
  AccentColorPreference accentColorPreference;
  List<SupporterEntity> supporters;
  bool loadingSupporters;

  SettingsData({
    this.locale,
    this.themeMode,
    this.context,
    this.closePreference = ClosePreference.hide,
    this.accentColorPreference = AccentColorPreference.system,
    this.supporters = const [],
    this.loadingSupporters = false,
  });

  @override
  SettingsData copyWith({
    Locale? locale,
    ThemeMode? themeMode,
    BuildContext? context,
    ClosePreference? closePreference,
    AccentColorPreference? accentColorPreference,
    List<SupporterEntity>? supporters,
    bool? loadingSupporters,
  }) {
    return SettingsData(
      locale: locale ?? this.locale,
      themeMode: themeMode ?? this.themeMode,
      context: context ?? this.context,
      closePreference: closePreference ?? this.closePreference,
      accentColorPreference:
          accentColorPreference ?? this.accentColorPreference,
      supporters: supporters ?? this.supporters,
      loadingSupporters: loadingSupporters ?? this.loadingSupporters,
    );
  }
}
