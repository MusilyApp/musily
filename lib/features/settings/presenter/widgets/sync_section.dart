import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/ui/buttons/ly_filled_button.dart';
import 'package:musily/core/presenter/ui/buttons/ly_outlined_button.dart';
import 'package:musily/core/utils/get_theme_mode.dart';
import 'package:musily/features/auth/presenter/controllers/auth_controller/auth_controller.dart';
import 'package:musily/features/auth/presenter/pages/login_page.dart';
import 'package:musily/features/auth/presenter/pages/signup_page.dart';
import 'package:musily_repository/musily_repository.dart';

class SyncSection extends StatelessWidget {
  final musilyRepository = MusilyRepository();
  final AuthController authController;
  final CoreController coreController;
  SyncSection({
    super.key,
    required this.authController,
    required this.coreController,
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = getThemeMode(context) == ThemeMode.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          child: Text(
            AppLocalizations.of(context)!.account,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          child: authController.builder(builder: (context, data) {
            return Column(
              children: [
                if (data.user != null) ...[
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: isDarkMode
                          ? const Color(0xffe8def7)
                          : const Color(0xff68548f),
                      child: Text(
                        data.user!.name[0],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                          color: !isDarkMode
                              ? const Color(0xffe8def7)
                              : const Color(0xff68548f),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    data.user!.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  LyOutlinedButton(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    onPressed: () {
                      authController.methods.logout();
                    },
                    fullWidth: true,
                    child: const Text('Logout'),
                  ),
                ],
                if (data.user == null) ...[
                  LyFilledButton(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    onPressed: () {
                      coreController.methods.pushWidget(
                        LoginPage(
                          authController: authController,
                        ),
                        overlayMainPage: true,
                      );
                    },
                    fullWidth: true,
                    child: Text(AppLocalizations.of(context)!.login),
                  ),
                  LyOutlinedButton(
                    margin: const EdgeInsets.only(bottom: 8),
                    onPressed: () {
                      coreController.methods.pushWidget(
                        SignupPage(
                          authController: authController,
                        ),
                        overlayMainPage: true,
                      );
                    },
                    fullWidth: true,
                    child: Text(AppLocalizations.of(context)!.createAccount),
                  ),
                ],
              ],
            );
          }),
        ),
      ],
    );
  }
}
