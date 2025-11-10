import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/ui/utils/ly_navigator.dart';
import 'package:musily/features/settings/presenter/pages/about_page.dart';
import 'package:musily/features/settings/presenter/controllers/settings/settings_controller.dart';

class OtherSection extends StatelessWidget {
  final CoreController coreController;
  final SettingsController settingsController;

  const OtherSection({
    super.key,
    required this.coreController,
    required this.settingsController,
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
                  color: context.themeData.colorScheme.secondary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                LucideIcons.ellipsis,
                size: 18,
                color: context.themeData.colorScheme.secondary,
              ),
              const SizedBox(width: 8),
              Text(
                context.localization.others,
                style: context.themeData.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
        // Licenses Tile
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                showLicensePage(
                  applicationName: 'Musily',
                  useRootNavigator: true,
                  applicationIcon: SvgPicture.asset(
                    'assets/icons/musily.svg',
                    width: 60,
                  ),
                  context: context.display.isDesktop
                      ? coreController.coreContext!
                      : context,
                );
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
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
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: context.themeData.colorScheme.secondary
                            .withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        LucideIcons.scale,
                        size: 22,
                        color: context.themeData.colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        context.localization.licenses,
                        style:
                            context.themeData.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                    Icon(
                      LucideIcons.chevronRight,
                      size: 20,
                      color: context.themeData.colorScheme.onSurface
                          .withValues(alpha: 0.5),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // About Tile
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                LyNavigator.push(
                  context,
                  AboutPage(
                    controller: settingsController,
                  ),
                );
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
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
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: context.themeData.colorScheme.tertiary
                            .withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        LucideIcons.heart,
                        size: 22,
                        color: context.themeData.colorScheme.tertiary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        context.localization.aboutSupporters,
                        style:
                            context.themeData.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                    Icon(
                      LucideIcons.chevronRight,
                      size: 20,
                      color: context.themeData.colorScheme.onSurface
                          .withValues(alpha: 0.5),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
