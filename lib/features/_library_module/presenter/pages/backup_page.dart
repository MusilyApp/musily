import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/ui/utils/ly_navigator.dart';
import 'package:musily/core/presenter/widgets/musily_app_bar.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/_library_module/presenter/widgets/library_backup.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';

class BackupPage extends StatelessWidget {
  final DownloaderController downloaderController;
  final LibraryController libraryController;
  final CoreController coreController;

  const BackupPage({
    super.key,
    required this.downloaderController,
    required this.libraryController,
    required this.coreController,
  });

  @override
  Widget build(BuildContext context) {
    return libraryController.builder(
      builder: (context, libraryData) {
        return downloaderController.builder(
          builder: (context, downloaderData) {
            // Check if library has items (excluding offline playlist)
            final hasLibrary = libraryData.items.isNotEmpty;
            // Check if downloads has completed items
            final hasDownloads = downloaderData.queue
                .where((e) => e.status == e.downloadCompleted)
                .isNotEmpty;

            return Scaffold(
              appBar: MusilyAppBar(
                title: Text(context.localization.backupLibrary),
              ),
              body: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
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
                            color: context.themeData.colorScheme.primary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          context.localization.libraryManagementSectionTitle,
                          style: context.themeData.textTheme.headlineSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Backup Tile - only show if library or downloads has items
                  if (hasLibrary || hasDownloads)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: libraryData.backupInProgress
                              ? null
                              : () async {
                                  LyNavigator.showLyCardDialog(
                                    padding: EdgeInsets.zero,
                                    context: context,
                                    builder: (context) => Center(
                                      child: LibraryBackup(
                                        hasLibrary: hasLibrary,
                                        hasDownloads: hasDownloads,
                                        onBackup: (options) async {
                                          if (Platform.isAndroid ||
                                              Platform.isIOS) {
                                            await coreController.methods
                                                .requestStoragePermission();
                                          }
                                          await libraryController.methods
                                              .backupLibrary(options);
                                          if (context.mounted) {
                                            LyNavigator.pop(context);
                                          }
                                        },
                                      ),
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
                              color: context
                                  .themeData.colorScheme.surfaceContainerHighest
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
                                    color: context.themeData.colorScheme.primary
                                        .withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    LucideIcons.databaseBackup,
                                    size: 22,
                                    color:
                                        context.themeData.colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        context.localization.backup,
                                        style: context
                                            .themeData.textTheme.titleMedium
                                            ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: -0.2,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        context.localization
                                            .backupLibraryDescription,
                                        style: context
                                            .themeData.textTheme.bodySmall
                                            ?.copyWith(
                                          color: context
                                              .themeData.colorScheme.onSurface
                                              .withValues(alpha: 0.7),
                                        ),
                                      ),
                                    ],
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
                  // Restore Tile
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: libraryData.backupInProgress
                            ? null
                            : () async {
                                final file = await libraryController.methods
                                    .pickBackupFile();
                                if (file != null) {
                                  await libraryController.methods
                                      .restoreLibrary(file);
                                }
                              },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: context
                                .themeData.colorScheme.surfaceContainerHighest
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
                                  LucideIcons.hardDrive,
                                  size: 22,
                                  color:
                                      context.themeData.colorScheme.secondary,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      context.localization.restore,
                                      style: context
                                          .themeData.textTheme.titleMedium
                                          ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: -0.2,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      context.localization
                                          .restoreLibraryDescription,
                                      style: context
                                          .themeData.textTheme.bodySmall
                                          ?.copyWith(
                                        color: context
                                            .themeData.colorScheme.onSurface
                                            .withValues(alpha: 0.7),
                                      ),
                                    ),
                                  ],
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
                ],
              ),
            );
          },
        );
      },
    );
  }
}
