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
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: context.themeData.colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: context.themeData.colorScheme.outline
                        .withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            context.themeData.colorScheme.tertiary
                                .withValues(alpha: 0.8),
                            context.themeData.colorScheme.secondary
                                .withValues(alpha: 0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: context.themeData.colorScheme.tertiary
                                .withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          data.user!.name[0].toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 32,
                            color: context.themeData.colorScheme.onSurface,
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      data.user!.name,
                      style: context.themeData.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: LyOutlinedButton(
                        onPressed: () {
                          authController.methods.logout();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              LucideIcons.logOut,
                              size: 18,
                              color: context.themeData.colorScheme.error,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Logout',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        LucideIcons.logIn,
                        size: 18,
                        color: context.themeData.colorScheme.onPrimary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        context.localization.login,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        LucideIcons.userPlus,
                        size: 18,
                        color: context.themeData.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        context.localization.createAccount,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
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
