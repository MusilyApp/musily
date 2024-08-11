import 'package:flutter/material.dart';
import 'package:musily/core/presenter/widgets/menu_entry.dart';
import 'package:musily_player/musily_player.dart';
import 'package:musily_player/presenter/controllers/downloader/downloader_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DownloaderMenuEntry {
  final DownloaderController downloaderController;

  MenuEntry builder(
    BuildContext context,
    MusilyTrack track,
  ) {
    final item = downloaderController.methods.getItem(track);
    if (item == null) {
      return MenuEntry(
        onPressed: () {
          downloaderController.methods.addDownload(
            track,
          );
          downloaderController.methods.setDownloadingKey(
            track.hash ?? track.id,
          );
        },
        leading: Icon(
          Icons.download_rounded,
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Text(
          AppLocalizations.of(context)!.download,
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
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Text(
          AppLocalizations.of(context)!.deleteDownload,
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
        color: Theme.of(context).colorScheme.primary,
      ),
      child: Text(AppLocalizations.of(context)!.cancelDownload),
    );
  }

  DownloaderMenuEntry({
    required this.downloaderController,
  });
}
