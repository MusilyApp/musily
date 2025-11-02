import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/extensions/color_scheme.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_data.dart';

class BackupProgressCard extends StatelessWidget {
  final LibraryController libraryController;
  final bool isDesktop;

  const BackupProgressCard({
    super.key,
    required this.libraryController,
    this.isDesktop = false,
  });

  String _getLocalizedMessage(BuildContext context, LibraryData data) {
    if (data.backupMessageKey == null) {
      return data.backupMessage;
    }

    final loc = context.localization;
    switch (data.backupMessageKey) {
      case 'startingBackup':
        return loc.startingBackup;
      case 'startingRestore':
        return loc.startingRestore;
      case 'initializingBackup':
        return loc.initializingBackup;
      case 'creatingBackupArchive':
        return loc.creatingBackupArchive;
      case 'backingUpDownloadsMetadata':
        return loc.backingUpDownloadsMetadata;
      case 'backingUpAudioFiles':
        return loc.backingUpAudioFiles;
      case 'backingUpLibraryData':
        return loc.backingUpLibraryData;
      case 'writingBackupFile':
        return loc.writingBackupFile;
      case 'savingToStorage':
        return loc.savingToStorage;
      case 'backupCancelled':
        return loc.backupCancelled;
      case 'backupFailed':
        return loc.backupFailed;
      case 'initializingRestore':
        return loc.initializingRestore;
      case 'readingBackupFile':
        return loc.readingBackupFile;
      case 'extractingLibraryData':
        return loc.extractingLibraryData;
      case 'extractingDownloadsData':
        return loc.extractingDownloadsData;
      case 'extractingAudioFiles':
        return loc.extractingAudioFiles;
      case 'finalizingRestore':
        return loc.finalizingRestore;
      case 'restoreCompletedSuccessfully':
        return loc.restoreCompletedSuccessfully;
      case 'restoreFailed':
        return loc.restoreFailed;
      case 'backupFileNotFound':
        return loc.backupFileNotFound;
      case 'savedTo':
        final filename = data.backupMessageParams?['filename'] ?? '';
        return loc.savedTo(filename);
      default:
        return data.backupMessage;
    }
  }

  Future<void> _showCancelDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.localization.cancelOperation),
        content: Text(
          libraryController.data.backupActivityType == BackupActivityType.backup
              ? context.localization.cancelBackupConfirmation
              : context.localization.cancelRestoreConfirmation,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(context.localization.no),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(context.localization.yes),
          ),
        ],
      ),
    );

    if (result == true) {
      await libraryController.methods.cancelBackup();
    }
  }

  @override
  Widget build(BuildContext context) {
    return libraryController.builder(
      builder: (context, data) {
        // Show while in progress OR if recently completed (progress = 1.0)
        final showCard = data.backupInProgress ||
            (data.backupProgress >= 1.0 && data.backupActivityType != null);

        if (!showCard) {
          return const SizedBox.shrink();
        }

        // Auto-hide after 8 seconds when completed
        if (!data.backupInProgress && data.backupProgress >= 1.0) {
          Future.delayed(const Duration(seconds: 8), () {
            if (context.mounted && !libraryController.data.backupInProgress) {
              libraryController.updateData(
                libraryController.data.copyWith(
                  backupProgress: 0.0,
                  backupMessage: '',
                  clearBackupActivityType: true,
                ),
              );
            }
          });
        }

        final isBackup = data.backupActivityType == BackupActivityType.backup;
        final isCompleted =
            !data.backupInProgress && data.backupProgress >= 1.0;

        final icon = isCompleted
            ? LucideIcons.circleCheck
            : (isBackup ? LucideIcons.databaseBackup : LucideIcons.hardDrive);
        final title = isBackup
            ? context.localization.backup
            : context.localization.restore;

        if (isDesktop) {
          return Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: context.themeData.colorScheme.onScaffold,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: context.themeData.colorScheme.primary
                            .withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        icon,
                        size: 18,
                        color: context.themeData.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: context.themeData.textTheme.titleSmall
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _getLocalizedMessage(context, data),
                            style:
                                context.themeData.textTheme.bodySmall?.copyWith(
                              color: context.themeData.colorScheme.onSurface
                                  .withValues(alpha: 0.7),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    if (!isCompleted)
                      IconButton(
                        onPressed: () => _showCancelDialog(context),
                        icon: Icon(
                          LucideIcons.x,
                          size: 18,
                          color: context.themeData.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                        ),
                        visualDensity: VisualDensity.compact,
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: data.backupProgress,
                    minHeight: 6,
                    backgroundColor:
                        context.themeData.colorScheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      context.themeData.colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${(data.backupProgress * 100).toStringAsFixed(0)}%',
                  style: context.themeData.textTheme.bodySmall?.copyWith(
                    color: context.themeData.colorScheme.onSurface
                        .withValues(alpha: 0.6),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          );
        }

        // Mobile style
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: context.themeData.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(
              color:
                  context.themeData.colorScheme.primary.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: context.themeData.colorScheme.primary
                          .withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      size: 20,
                      color: context.themeData.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style:
                              context.themeData.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _getLocalizedMessage(context, data),
                          style:
                              context.themeData.textTheme.bodySmall?.copyWith(
                            color: context.themeData.colorScheme.onSurface
                                .withValues(alpha: 0.7),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  if (!isCompleted)
                    IconButton(
                      onPressed: () => _showCancelDialog(context),
                      icon: Icon(
                        LucideIcons.x,
                        size: 20,
                        color: context.themeData.colorScheme.onSurface
                            .withValues(alpha: 0.6),
                      ),
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: data.backupProgress,
                        minHeight: 8,
                        backgroundColor: context
                            .themeData.colorScheme.surfaceContainerHighest,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          context.themeData.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${(data.backupProgress * 100).toStringAsFixed(0)}%',
                    style: context.themeData.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: context.themeData.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
