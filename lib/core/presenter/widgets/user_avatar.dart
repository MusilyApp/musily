import 'package:flutter/material.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/ui/utils/ly_navigator.dart';
import 'package:musily/features/auth/presenter/controllers/auth_controller/auth_controller.dart';
import 'package:musily/features/settings/presenter/controllers/settings/settings_controller.dart';
import 'package:musily/features/settings/presenter/pages/settings_page.dart';

class UserAvatar extends StatelessWidget {
  final CoreController coreController;
  final SettingsController settingsController;
  final AuthController authController;
  const UserAvatar({
    super.key,
    required this.coreController,
    required this.settingsController,
    required this.authController,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      onTap: () {
        late final BuildContext? usingContext;

        if (context.display.isDesktop) {
          usingContext = context;
        } else {
          usingContext = coreController.coreKey.currentContext;
        }
        if (usingContext != null) {
          LyNavigator.push(
            usingContext,
            SettingsPage(
              coreController: coreController,
              settingsController: settingsController,
              authController: authController,
            ),
          );
        }
      },
      child: CircleAvatar(
        radius: 19,
        backgroundColor: context.isDarkMode
            ? const Color(0xffe8def7)
            : const Color(0xff68548f),
        child: authController.builder(builder: (context, data) {
          if (data.user != null) {
            return Text(
              data.user!.name[0],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: !context.isDarkMode
                    ? const Color(0xffe8def7)
                    : const Color(0xff68548f),
              ),
            );
          }
          return Icon(
            Icons.person_rounded,
            color: !context.isDarkMode
                ? const Color(0xffe8def7)
                : const Color(0xff68548f),
          );
        }),
      ),
    );
  }
}
