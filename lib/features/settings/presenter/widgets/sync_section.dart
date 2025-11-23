import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
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
        // Section Header
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: context.themeData.colorScheme.tertiary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                LucideIcons.user,
                size: 18,
                color: context.themeData.colorScheme.tertiary,
              ),
              const SizedBox(width: 8),
              Text(
                context.localization.account,
                style: context.themeData.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
        // Account Content
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: authController.builder(builder: (context, data) {
            if (data.user != null) {
              // Logged In State
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: context
                          .themeData.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.35),
                      border: Border.all(
                        color: context.themeData.colorScheme.outline
                            .withValues(alpha: 0.1),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor:
                                  context.themeData.colorScheme.primary,
                              child: Text(
                                data.user!.name[0].toUpperCase(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  color:
                                      context.themeData.colorScheme.onPrimary,
                                  letterSpacing: 0,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data.user!.name,
                                    style: context
                                        .themeData.textTheme.titleMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    data.user!.email,
                                    style: context.themeData.textTheme.bodySmall
                                        ?.copyWith(
                                      color: context
                                          .themeData.colorScheme.onSurface
                                          .withValues(alpha: 0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: LyOutlinedButton(
                            onPressed: () {
                              authController.methods.logout();
                            },
                            icon: Icon(
                              LucideIcons.logOut,
                              size: 18,
                              color: context.themeData.colorScheme.error,
                            ),
                            child: Text(
                              'Logout',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: context.themeData.colorScheme.error,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            // Not Logged In State
            return AppFlex(
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
                  icon: const Icon(
                    LucideIcons.logIn,
                    size: 18,
                  ),
                  child: Text(
                    context.localization.login,
                  ),
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
                  icon: const Icon(
                    LucideIcons.userPlus,
                    size: 18,
                  ),
                  child: Text(
                    context.localization.createAccount,
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
