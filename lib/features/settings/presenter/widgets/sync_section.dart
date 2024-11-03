import 'package:flutter/material.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/ui/buttons/ly_filled_button.dart';
import 'package:musily/core/presenter/ui/buttons/ly_outlined_button.dart';
import 'package:musily/core/presenter/ui/utils/ly_navigator.dart';
import 'package:musily/core/presenter/widgets/app_flex.dart';
import 'package:musily/features/auth/presenter/controllers/auth_controller/auth_controller.dart';
import 'package:musily/features/auth/presenter/pages/login_page.dart';
import 'package:musily/features/auth/presenter/pages/signup_page.dart';

class SyncSection extends StatelessWidget {
  final AuthController authController;
  final CoreController coreController;

  const SyncSection({
    super.key,
    required this.authController,
    required this.coreController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          child: Text(
            context.localization.account,
            style: context.themeData.textTheme.titleSmall,
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
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: context.isDarkMode
                        ? const Color(0xffe8def7)
                        : const Color(0xff68548f),
                    child: Text(
                      data.user!.name[0],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        color: !context.isDarkMode
                            ? const Color(0xffe8def7)
                            : const Color(0xff68548f),
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
                if (data.user == null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: AppFlex(
                      maxItemsPerRow: 1,
                      maxItemsPerRowMd: 2,
                      spacing: AppFlexSpacing.all(8),
                      children: [
                        LyFilledButton(
                          onPressed: () {
                            LyNavigator.push(
                              coreController.coreContext!,
                              LoginPage(
                                authController: authController,
                              ),
                            );
                          },
                          fullWidth: true,
                          child: Text(context.localization.login),
                        ),
                        LyOutlinedButton(
                          onPressed: () {
                            LyNavigator.push(
                              coreController.coreContext!,
                              SignupPage(
                                authController: authController,
                              ),
                            );
                          },
                          fullWidth: true,
                          child: Text(context.localization.createAccount),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          }),
        ),
      ],
    );
  }
}
