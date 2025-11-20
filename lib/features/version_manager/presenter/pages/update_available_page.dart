import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/widgets/markdown_content.dart';
import 'package:musily/core/presenter/ui/buttons/ly_filled_button.dart';
import 'package:musily/core/presenter/ui/buttons/ly_outlined_button.dart';
import 'package:musily/core/presenter/ui/utils/ly_navigator.dart';
import 'package:musily/core/presenter/ui/utils/ly_page.dart';
import 'package:musily/core/presenter/widgets/musily_app_bar.dart';
import 'package:musily/core/presenter/widgets/musily_loading.dart';
import 'package:musily/features/version_manager/domain/entities/release_entity.dart';
import 'package:musily/features/version_manager/presenter/controllers/version_manager/version_manager_controller.dart';
import 'package:musily/features/version_manager/presenter/pages/version_manager_page.dart';

class UpdateAvailablePage extends StatefulWidget {
  final VersionManagerController controller;

  const UpdateAvailablePage({
    super.key,
    required this.controller,
  });

  @override
  State<UpdateAvailablePage> createState() => _UpdateAvailablePageState();
}

class _UpdateAvailablePageState extends State<UpdateAvailablePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final languageCode = Localizations.localeOf(context).languageCode;
      widget.controller.setLanguageCode(languageCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LyPage(
      contextKey: 'UpdateAvailablePage',
      child: widget.controller.builder(
        builder: (context, data) {
          return Scaffold(
            appBar: MusilyAppBar(
              title: Text(context.localization.newUpdateAvailable),
            ),
            bottomNavigationBar: _UpdateBottomBar(
              controller: widget.controller,
              selectedRelease: data.selectedRelease,
            ),
            extendBody: true,
            body: SafeArea(
              bottom: false,
              child: Builder(
                builder: (context) {
                  if (data.loadingReleases) {
                    return const Center(child: MusilyDotsLoading());
                  }

                  if (data.error != null || data.selectedRelease == null) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          data.error ?? context.localization.noReleasesFound,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  return ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      const _UpdateHeader(),
                      const SizedBox(height: 32),
                      _VersionInfo(version: data.selectedRelease!.version),
                      const SizedBox(height: 24),
                      if (data.changelog != null && data.changelog!.isNotEmpty)
                        _ChangelogSection(releaseNotes: data.changelog!),
                      if (data.loadingChangelog)
                        const Padding(
                          padding: EdgeInsets.all(24),
                          child: Center(child: MusilyDotsLoading()),
                        ),
                      const SizedBox(height: 120),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class _UpdateHeader extends StatelessWidget {
  const _UpdateHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: context.themeData.colorScheme.primaryContainer
                .withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
          child: Icon(
            LucideIcons.download,
            size: 48,
            color: context.themeData.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          context.localization.newUpdateAvailable,
          style: context.themeData.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          context.localization.updateAvailableDescription,
          style: context.themeData.textTheme.bodyLarge?.copyWith(
            color:
                context.themeData.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _VersionInfo extends StatelessWidget {
  final String version;

  const _VersionInfo({
    required this.version,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.themeData.colorScheme.surfaceContainerHighest
            .withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.themeData.colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            LucideIcons.tag,
            size: 20,
            color: context.themeData.colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Text(
            context.localization.version,
            style: context.themeData.textTheme.bodyMedium?.copyWith(
              color: context.themeData.colorScheme.onSurface
                  .withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            version,
            style: context.themeData.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChangelogSection extends StatelessWidget {
  final String releaseNotes;

  const _ChangelogSection({
    required this.releaseNotes,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 24,
              decoration: BoxDecoration(
                color: context.themeData.colorScheme.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              LucideIcons.fileText,
              size: 18,
              color: context.themeData.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              context.localization.changelog,
              style: context.themeData.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: context.themeData.colorScheme.surfaceContainerHighest
                .withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color:
                  context.themeData.colorScheme.outline.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          constraints: const BoxConstraints(maxHeight: 300),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: MarkdownContent(content: releaseNotes),
          ),
        ),
      ],
    );
  }
}

class _UpdateBottomBar extends StatelessWidget {
  final VersionManagerController controller;
  final ReleaseEntity? selectedRelease;

  const _UpdateBottomBar({
    required this.controller,
    required this.selectedRelease,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        decoration: BoxDecoration(
          color: context.themeData.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: context.themeData.colorScheme.outline.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: LyOutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(context.localization.later),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: LyFilledButton(
                onPressed: selectedRelease != null
                    ? () {
                        LyNavigator.pop(context);
                        LyNavigator.push(
                          context,
                          VersionManagerPage(
                            controller: controller,
                          ),
                        );
                      }
                    : null,
                child: Text(context.localization.update),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
