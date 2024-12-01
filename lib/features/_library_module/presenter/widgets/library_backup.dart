import 'package:flutter/material.dart';
import 'package:musily/core/data/services/library_backup_service.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/ui/buttons/ly_filled_button.dart';
import 'package:musily/core/presenter/ui/utils/ly_navigator.dart';

class LibraryBackup extends StatefulWidget {
  final Future<void> Function(List<BackupOptions>) onBackup;

  const LibraryBackup({required this.onBackup, super.key});

  @override
  State<LibraryBackup> createState() => _LibraryBackupState();
}

class _LibraryBackupState extends State<LibraryBackup> {
  bool isLoading = false;
  bool includeLibrary = true;
  bool includeDownloads = false;

  Future<void> _startBackup() async {
    setState(() {
      isLoading = true;
    });

    final selectedOptions = <BackupOptions>[];
    if (includeLibrary) selectedOptions.add(BackupOptions.library);
    if (includeDownloads) selectedOptions.add(BackupOptions.downloads);

    try {
      await widget.onBackup(selectedOptions);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.localization.backupCompletedSuccessfully,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${context.localization.backupFailed}: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
      LyNavigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CheckboxListTile(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              title: Text(context.localization.includeLibrary),
              value: includeLibrary,
              onChanged: (value) {
                setState(() {
                  includeLibrary = value ?? false;
                });
              },
            ),
            CheckboxListTile(
              title: Text(context.localization.includeDownloads),
              value: includeDownloads,
              onChanged: (value) {
                setState(() {
                  includeDownloads = value ?? false;
                });
              },
            ),
            const Expanded(child: SizedBox()),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                LyFilledButton(
                  margin: const EdgeInsets.only(right: 8, bottom: 12),
                  onPressed: isLoading
                      ? null
                      : () {
                          LyNavigator.pop(context);
                        },
                  child: Text(context.localization.cancel),
                ),
                LyFilledButton(
                  margin: const EdgeInsets.only(right: 12, bottom: 12),
                  loading: isLoading,
                  onPressed: (includeLibrary || includeDownloads)
                      ? _startBackup
                      : null,
                  child: Text(context.localization.startBackup),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
