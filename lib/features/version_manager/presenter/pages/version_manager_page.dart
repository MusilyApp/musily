import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/ui/buttons/ly_filled_button.dart';
import 'package:musily/core/presenter/ui/text_fields/ly_dropdown_button.dart';
import 'package:musily/core/presenter/ui/utils/ly_page.dart';
import 'package:musily/core/presenter/widgets/markdown_content.dart';
import 'package:musily/core/presenter/widgets/musily_app_bar.dart';
import 'package:musily/core/presenter/widgets/musily_loading.dart';
import 'package:musily/features/version_manager/domain/entities/release_entity.dart';
import 'package:musily/features/version_manager/presenter/controllers/version_manager/version_manager_controller.dart';

class VersionManagerPage extends StatefulWidget {
  final VersionManagerController controller;
  final bool newUpdateAvailable;
  final CoreController? coreController;

  const VersionManagerPage({
    super.key,
    required this.controller,
    this.newUpdateAvailable = false,
    this.coreController,
  });

  @override
  State<VersionManagerPage> createState() => _VersionManagerPageState();
}

class _VersionManagerPageState extends State<VersionManagerPage> {
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
    final coreController =
        widget.coreController ?? Modular.get<CoreController>();

    return LyPage(
      contextKey: 'VersionManagerPage',
      child: coreController.builder(
        builder: (context, coreData) {
          return widget.controller.builder(
            builder: (context, data) {
              return Scaffold(
                appBar: MusilyAppBar(
                  title: Text(widget.newUpdateAvailable
                      ? context.localization.newUpdateAvailable
                      : context.localization.versionManager),
                ),
                body: SafeArea(
                  child: Builder(
                    builder: (context) {
                      if (coreData.offlineMode) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  LucideIcons.wifiOff,
                                  size: 64,
                                  color: context.themeData.colorScheme.error
                                      .withValues(alpha: 0.7),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  context.localization.offlineMode,
                                  style: context
                                      .themeData.textTheme.headlineSmall
                                      ?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  context.localization.offlineModeDescription,
                                  style: context.themeData.textTheme.bodyMedium
                                      ?.copyWith(
                                    color: context
                                        .themeData.colorScheme.onSurface
                                        .withValues(alpha: 0.7),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      if (data.loadingReleases) {
                        return const Center(child: MusilyDotsLoading());
                      }

                      if (data.error != null) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  LucideIcons.triangleAlert,
                                  size: 48,
                                  color: context.themeData.colorScheme.error,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  data.error!,
                                  textAlign: TextAlign.center,
                                  style: context.themeData.textTheme.bodyLarge,
                                ),
                                const SizedBox(height: 24),
                                LyFilledButton(
                                  onPressed: () {
                                    widget.controller.methods.loadReleases();
                                  },
                                  child: Text(context.localization.retry),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      if (data.releases.isEmpty) {
                        return Center(
                          child: Text(context.localization.noReleasesFound),
                        );
                      }

                      return ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: [
                          _AppHeader(),
                          const SizedBox(height: 32),
                          _VersionSelector(
                            controller: widget.controller,
                            data: data,
                          ),
                          const SizedBox(height: 24),
                          _ActionButton(
                            controller: widget.controller,
                            data: data,
                          ),
                          if (data.selectedRelease != null) ...[
                            const SizedBox(height: 32),
                            _Changelog(
                              controller: widget.controller,
                              data: data,
                            ),
                          ],
                        ],
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _AppHeader extends StatelessWidget {
  const _AppHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(
          'assets/icons/musily.svg',
          width: 72,
        ),
        const SizedBox(height: 16),
        Text(
          'Musily',
          style: context.themeData.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'by Felipe Yslaoker',
          style: context.themeData.textTheme.bodyLarge?.copyWith(
            color:
                context.themeData.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}

class _VersionSelector extends StatelessWidget {
  final VersionManagerController controller;
  final dynamic data;

  const _VersionSelector({
    required this.controller,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return LyDropdownButton<ReleaseEntity>(
      labelText: context.localization.version,
      value: data.selectedRelease,
      items: data.releases.map<DropdownMenuItem<ReleaseEntity>>((release) {
        return DropdownMenuItem<ReleaseEntity>(
          value: release,
          child: Text('${release.name} (${release.version})'),
        );
      }).toList(),
      onChanged: (release) {
        if (release != null) {
          controller.methods.selectRelease(release);
          final languageCode = Localizations.localeOf(context).languageCode;
          controller.setLanguageCode(languageCode);
        }
      },
    );
  }
}

class _ActionButton extends StatelessWidget {
  final VersionManagerController controller;
  final dynamic data;

  const _ActionButton({
    required this.controller,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    if (data.selectedRelease == null) {
      return const SizedBox.shrink();
    }

    String buttonText;
    VoidCallback? onPressed;

    if (data.isSelectedVersionCurrent) {
      buttonText = context.localization.alreadyInstalled;
      onPressed = null;
    } else if (data.isSelectedVersionNewer) {
      buttonText = context.localization.update;
      onPressed = () {
        controller.methods.downloadRelease(data.selectedRelease!);
      };
    } else {
      buttonText = context.localization.download;
      onPressed = () {
        controller.methods.downloadRelease(data.selectedRelease!);
      };
    }

    return LyFilledButton(
      fullWidth: true,
      onPressed: onPressed,
      child: Text(buttonText),
    );
  }
}

class _Changelog extends StatelessWidget {
  final VersionManagerController controller;
  final dynamic data;

  const _Changelog({
    required this.controller,
    required this.data,
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
          padding: const EdgeInsets.all(16),
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
          child: Builder(
            builder: (context) {
              if (data.loadingChangelog) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: MusilyDotsLoading(),
                  ),
                );
              }

              if (data.changelog == null || data.changelog!.isEmpty) {
                return Text(
                  context.localization.changelogNotAvailable,
                  style: context.themeData.textTheme.bodyMedium?.copyWith(
                    color: context.themeData.colorScheme.onSurface
                        .withValues(alpha: 0.7),
                  ),
                );
              }

              return MarkdownContent(content: data.changelog!);
            },
          ),
        ),
      ],
    );
  }
}
