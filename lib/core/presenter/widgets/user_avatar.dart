import 'package:flutter/material.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/utils/get_theme_mode.dart';
import 'package:musily/features/settings/presenter/controllers/settings/settings_controller.dart';
import 'package:musily/features/settings/presenter/pages/settings_page.dart';

class UserAvatar extends StatelessWidget {
  final CoreController coreController;
  final SettingsController settingsController;
  const UserAvatar({
    super.key,
    required this.coreController,
    required this.settingsController,
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = getThemeMode(context) == ThemeMode.dark;
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      onTap: () {
        coreController.methods.pushWidget(
          SettingsPage(
            coreController: coreController,
            settingsController: settingsController,
          ),
          overlayMainPage: true,
        );
      },
      child: CircleAvatar(
        backgroundColor:
            isDarkMode ? const Color(0xffe8def7) : const Color(0xff68548f),
        child: Icon(
          Icons.person_rounded,
          color:
              !isDarkMode ? const Color(0xffe8def7) : const Color(0xff68548f),
        ),
      ),
    );
  }
}
