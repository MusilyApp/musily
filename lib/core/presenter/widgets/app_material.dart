import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:musily/features/settings/presenter/controllers/settings/settings_controller.dart';

class AppMaterial extends StatelessWidget {
  const AppMaterial({super.key});

  @override
  Widget build(BuildContext context) {
    Modular.setInitialRoute('/sections/');
    final settingsController = Modular.get<SettingsController>();
    return settingsController.builder(
      builder: (context, data) {
        return MaterialApp.router(
          locale: data.locale,
          themeMode: data.themeMode,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
            ),
            useMaterial3: true,
            cardTheme: const CardTheme(
              shadowColor: Colors.transparent,
            ),
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.dark,
            ),
            scaffoldBackgroundColor: Colors.black,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.black,
            ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Colors.black,
            ),
            cardTheme: const CardTheme(
              color: Color.fromARGB(255, 10, 10, 10),
            ),
          ),
          routerConfig: Modular.routerConfig,
        );
      },
    );
  }
}
