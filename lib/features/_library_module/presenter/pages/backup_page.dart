import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/data/services/library_backup_service.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/ui/lists/ly_list_tile.dart';
import 'package:musily/core/presenter/ui/utils/ly_navigator.dart';
import 'package:musily/core/presenter/ui/window/ly_header_bar.dart';
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
    return Scaffold(
      appBar: context.display.isDesktop
          ? LyHeaderBar(
              middle: Text(context.localization.backupLibrary),
            )
          : MusilyAppBar(
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
                      if (Platform.isAndroid || Platform.isIOS) {
                        await coreController.methods.requestStoragePermission();
                      }
                      return backupService.backupLibrary(options);
                    },
                  ),
                ),
              );
            },
            leading: const Icon(
              LucideIcons.databaseBackup,
              size: 20,
            ),
            title: Text(context.localization.backup),
          ),
          LyListTile(
            onTap: () {
              coreController.methods.pickBackupfile();
            },
            leading: const Icon(
              LucideIcons.hardDrive,
              size: 20,
            ),
            title: Text(context.localization.restore),
          ),
        ],
      ),
    );
  }
}
