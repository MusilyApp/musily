import 'package:flutter/material.dart';
import 'package:musily/core/presenter/widgets/menu_entry.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';

class DownloaderMenuEntry {
  final DownloaderController downloaderController;

  MenuEntry builder(
    BuildContext context,
    TrackEntity track,
  ) {
    final item = downloaderController.methods.getItem(track);
    if (item == null) {
      return MenuEntry(
        onPressed: () {
          downloaderController.methods.addDownload(
            track,
          );
          downloaderController.methods.setDownloadingKey(
            track.hash,
          );
        },
        leading: Icon(
          Icons.download_rounded,
          color: context.themeData.colorScheme.primary,
        ),
        child: Text(
          context.localization.download,
        ),
      );
    }
    if (item.status == item.downloadCompleted) {
      return MenuEntry(
        onPressed: () {
          downloaderController.methods.deleteDownloadedFile(
            track: track,
          );
        },
        leading: Icon(
          Icons.delete_rounded,
          color: context.themeData.colorScheme.primary,
        ),
        child: Text(
          context.localization.deleteDownload,
        ),
      );
    }
    return MenuEntry(
      onPressed: () {
        final item = downloaderController.methods.getItem(
          track,
        );
        if (item?.track.url != null) {
          downloaderController.methods.cancelDownload(
            item!.track.url!,
          );
        }
      },
      leading: Icon(
        Icons.cancel_rounded,
        color: context.themeData.colorScheme.primary,
      ),
      child: Text(context.localization.cancelDownload),
    );
  }

  DownloaderMenuEntry({
    required this.downloaderController,
  });
}
