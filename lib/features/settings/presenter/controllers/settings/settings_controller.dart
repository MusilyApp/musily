import 'package:flutter/material.dart';
import 'package:musily/core/domain/adapters/http_adapter.dart';
import 'package:musily/core/domain/presenter/app_controller.dart';
import 'package:musily/features/settings/presenter/controllers/settings/settings_data.dart';
import 'package:musily/features/settings/presenter/controllers/settings/settings_methods.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';

class SettingsController extends BaseController<SettingsData, SettingsMethods> {
  SettingsController({
    required HttpAdapter httpAdapter,
  }) {
    methods.loadLanguage();
    methods.loadThemeMode();
    showSyncSection = httpAdapter.baseUrl.isNotEmpty;
  }

  bool showSyncSection = false;

  @override
  SettingsData defineData() {
    return SettingsData();
  }

  @override
  SettingsMethods defineMethods() {
    return SettingsMethods(
      loadThemeMode: () async {
        final prefs = await SharedPreferences.getInstance();
        final savedThemeMode = prefs.getString('themeMode');
        data.themeMode = ThemeMode.values.byName(
          savedThemeMode ?? 'system',
        );
      },
      changeLanguage: (locale) async {
        if (locale == null) {
          return;
        }
        data.locale = Locale(locale);
        updateData(data);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('locale', locale);
      },
      changeTheme: (mode) async {
        data.themeMode = mode;
        updateData(data);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          'themeMode',
          mode?.name ?? 'system',
        );
      },
      loadLanguage: () async {
        final prefs = await SharedPreferences.getInstance();
        final savedLocale = prefs.getString('locale');
        if (savedLocale != null) {
          data.locale = Locale(savedLocale);
          updateData(data);
        } else {
          while (data.context == null) {
            await Future.delayed(
              const Duration(
                seconds: 1,
              ),
            );
          }
          while (data.context == null) {
            await Future.delayed(
              const Duration(
                seconds: 1,
              ),
            );
          }
          data.locale = Locale(
            data.context!.localization.localeName,
          );
          updateData(data);
          methods.changeLanguage(data.locale.toString());
        }
      },
    );
  }
}
