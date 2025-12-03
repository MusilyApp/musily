import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/ui/buttons/ly_filled_button.dart';
import 'package:musily/core/presenter/ui/buttons/ly_outlined_button.dart';
import 'package:musily/core/presenter/ui/utils/ly_navigator.dart';

class LibraryRestore extends StatefulWidget {
  final File backupFile;
  final Future<void> Function() onRestore;

  const LibraryRestore({
    required this.backupFile,
    required this.onRestore,
    super.key,
  });

  @override
  State<LibraryRestore> createState() => _LibraryRestoreState();
}

class _LibraryRestoreState extends State<LibraryRestore> {
  bool isLoading = false;

  Future<void> _startRestore() async {
    setState(() {
      isLoading = true;
    });

    try {
      await widget.onRestore();
    } catch (e) {
      // Error is handled by caller
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        LyNavigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final fileName = widget.backupFile.path.split('/').last;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Handle bar
        Container(
          margin: const EdgeInsets.only(top: 12),
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: context.themeData.colorScheme.outline.withValues(alpha: 0.3),
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
              Expanded(
                child: Text(
                  context.localization.restore,
                  style: context.themeData.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Content
        Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: context.themeData.colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: context.themeData.colorScheme.outline
                          .withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        LucideIcons.archiveRestore,
                        size: 48,
                        color: context.themeData.colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        context.localization.doYouWantToRestoreThisBackup,
                        textAlign: TextAlign.center,
                        style: context.themeData.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        context.localization.restoreLibraryDescription,
                        textAlign: TextAlign.center,
                        style: context.themeData.textTheme.bodySmall?.copyWith(
                          color: context.themeData.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: context.themeData.colorScheme.primary
                              .withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              LucideIcons.file,
                              size: 16,
                              color: context.themeData.colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                fileName,
                                style: context.themeData.textTheme.bodySmall
                                    ?.copyWith(
                                  color: context.themeData.colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
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
                  onPressed: isLoading ? null : _startRestore,
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
                      : Text(context.localization.restore),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
