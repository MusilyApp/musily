import 'package:flutter/material.dart';
import 'package:musily/core/data/services/library_backup_service.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/ui/lists/ly_list_tile.dart';
import 'package:musily/core/presenter/ui/utils/ly_navigator.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(context.localization.backupLibrary),
      ),
      body: ListView(
        children: [
          LyListTile(
            onTap: () async {
              final backupService = BackupService(
                downloaderController: downloaderController,
                libraryController: libraryController,
              );
              LyNavigator.showLyCardDialog(
                padding: EdgeInsets.zero,
                context: context,
                barrierDismissible: false,
                builder: (context) => Center(
                  child: LibraryBackup(
                    onBackup: (options) async {
                      await coreController.methods.requestStoragePermission();
                      return backupService.backupLibrary(options);
                    },
                  ),
                ),
              );
            },
            leading: const Icon(
              Icons.settings_backup_restore_rounded,
            ),
            title: Text(context.localization.backup),
          ),
          LyListTile(
            onTap: () {
              coreController.methods.pickBackupfile();
            },
            leading: const Icon(
              Icons.sd_card_rounded,
            ),
            title: Text(context.localization.restore),
          ),
        ],
      ),
    );
  }
}
