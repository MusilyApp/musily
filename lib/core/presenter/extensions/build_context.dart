import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:musily/core/domain/presenter/app_controller.dart';
import 'package:musily/core/presenter/ui/utils/ly_navigator.dart';
import 'package:musily/core/presenter/widgets/app_builder.dart';
import 'package:musily/core/utils/display_helper.dart';
import 'package:musily/features/settings/presenter/controllers/settings/settings_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:musily/features/settings/presenter/controllers/settings/settings_data.dart';

extension MusilyBuildContext on BuildContext {
  ThemeMode get themeMode {
    final SettingsController controller = Modular.get<SettingsController>();
    final themeMode = controller.data.themeMode ?? ThemeMode.system;
    if (themeMode == ThemeMode.system) {
      final brightness = MediaQuery.of(this).platformBrightness;
      return brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
    }
    return themeMode;
  }

  bool get isDarkMode => themeMode == ThemeMode.dark;
  AppBuilder Function({
    required Widget Function(BuildContext context, SettingsData data) builder,
    void Function(
      BuildContext context,
      BaseControllerEvent event,
      SettingsData data,
    )? eventListener,
    bool allowAlertDialog,
  }) get settingsBuilder => Modular.get<SettingsController>().builder;

  AppLocalizations get localization {
    return AppLocalizations.of(this)!;
  }

  DisplayHelper get display => DisplayHelper(this);

  BuildContext get showingPageContext {
    final contextManager = ContextManager();

    final foundContext = contextManager.contextStack
        .where(
          (e) => [
            'SectionsPage',
            'SearchPage',
            'DownloaderPage',
            'LibraryPage',
          ].contains(e.key),
        )
        .firstOrNull;

    return foundContext?.context ?? this;
  }

  ThemeData get themeData {
    return Theme.of(this);
  }

  MediaQueryData get mediaQuery => MediaQuery.of(this);
}
