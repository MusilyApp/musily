import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/data/services/library_backup_service.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/ui/buttons/ly_filled_button.dart';
import 'package:musily/core/presenter/ui/buttons/ly_outlined_button.dart';
import 'package:musily/core/presenter/ui/utils/ly_navigator.dart';

class LibraryBackup extends StatefulWidget {
  final Future<void> Function(List<BackupOptions>) onBackup;
  final bool hasLibrary;
  final bool hasDownloads;

  const LibraryBackup({
    required this.onBackup,
    required this.hasLibrary,
    required this.hasDownloads,
    super.key,
  });

  @override
  State<LibraryBackup> createState() => _LibraryBackupState();
}

class _LibraryBackupState extends State<LibraryBackup> {
  bool isLoading = false;
  late bool includeLibrary;
  late bool includeDownloads;

  @override
  void initState() {
    super.initState();
    // Set initial values based on what's available
    includeLibrary = widget.hasLibrary;
    includeDownloads = widget.hasDownloads;
  }

  Future<void> _startBackup() async {
    setState(() {
      isLoading = true;
    });

    final selectedOptions = <BackupOptions>[];
    if (includeLibrary) selectedOptions.add(BackupOptions.library);
    if (includeDownloads) selectedOptions.add(BackupOptions.downloads);

    try {
      await widget.onBackup(selectedOptions);
      // Success is handled by progress card
    } catch (e) {
      // Error is handled by progress card
    } finally {
      setState(() {
        isLoading = false;
      });
      LyNavigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
        minHeight: 280,
      ),
      decoration: BoxDecoration(
        color: context.themeData.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color:
                  context.themeData.colorScheme.outline.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: context.themeData.colorScheme.primary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    LucideIcons.databaseBackup,
                    size: 20,
                    color: context.themeData.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  context.localization.backupLibrary,
                  style: context.themeData.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          // Options
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: context
                          .themeData.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: context.themeData.colorScheme.outline
                            .withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        CheckboxListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 2,
                          ),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                          ),
                          title: Row(
                            children: [
                              Icon(
                                LucideIcons.library,
                                size: 18,
                                color: context.themeData.colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                context.localization.includeLibrary,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          subtitle: Text(
                            context.localization.includeLibraryDescription,
                            style: TextStyle(
                              fontSize: 12,
                              color: context.themeData.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                            ),
                          ),
                          value: includeLibrary,
                          onChanged: widget.hasLibrary
                              ? (value) {
                                  setState(() {
                                    includeLibrary = value ?? false;
                                  });
                                }
                              : null,
                        ),
                        Divider(
                          height: 1,
                          color: context.themeData.colorScheme.outline
                              .withValues(alpha: 0.2),
                        ),
                        CheckboxListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 2,
                          ),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            ),
                          ),
                          title: Row(
                            children: [
                              Icon(
                                LucideIcons.download,
                                size: 18,
                                color: context.themeData.colorScheme.secondary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                context.localization.includeDownloads,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          subtitle: Text(
                            context.localization.includeDownloadsDescription,
                            style: TextStyle(
                              fontSize: 12,
                              color: context.themeData.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                            ),
                          ),
                          value: includeDownloads,
                          onChanged: widget.hasDownloads
                              ? (value) {
                                  setState(() {
                                    includeDownloads = value ?? false;
                                  });
                                }
                              : null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          // Actions
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Row(
              children: [
                Expanded(
                  child: LyOutlinedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            LyNavigator.pop(context);
                          },
                    child: Text(context.localization.cancel),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: LyFilledButton(
                    loading: isLoading,
                    onPressed: (includeLibrary || includeDownloads)
                        ? _startBackup
                        : null,
                    child: isLoading
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                context.themeData.colorScheme.onPrimary,
                              ),
                            ),
                          )
                        : Text(context.localization.backup),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
