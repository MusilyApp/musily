import 'package:flutter/material.dart';
import 'package:flutter_download_manager/flutter_download_manager.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/track/presenter/widgets/track_tile_static.dart';

class DownloadManagerWidget extends StatelessWidget {
  final DownloaderController controller;
  final bool borderLess;
  final bool dense;
  final Color? backgroundItemColor;
  const DownloadManagerWidget({
    super.key,
    required this.controller,
    this.borderLess = false,
    this.dense = false,
    this.backgroundItemColor,
  });

  @override
  Widget build(BuildContext context) {
    return controller.builder(
      builder: (context, data) {
        final downloadingItems = data.queue.where(
          (e) => e.status == e.downloadDownloading,
        );
        final queuedItems = data.queue.where(
          (e) => e.status == e.downloadQueued || e.status == e.downloadPaused,
        );
        final otherItems = data.queue.where(
          (e) =>
              e.status != e.downloadDownloading &&
              e.status != e.downloadQueued &&
              e.status != e.downloadPaused,
        );

        final items = [
          ...downloadingItems,
          ...queuedItems,
          ...otherItems,
        ];
        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Padding(
              padding: dense
                  ? EdgeInsets.zero
                  : const EdgeInsets.symmetric(
                      vertical: 4,
                    ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Card(
                  color: backgroundItemColor,
                  shape: borderLess
                      ? const RoundedRectangleBorder()
                      : RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            12,
                          ),
                          side: BorderSide(
                            width: 1,
                            color: context.themeData.dividerColor.withValues(
                              alpha: .2,
                            ),
                          ),
                        ),
                  margin: EdgeInsets.zero,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TrackTileStatic(
                        track: item.track,
                        trailing: controller.methods.trailing(
                          context,
                          item,
                        ),
                      ),
                      if (![
                        DownloadStatus.completed,
                        DownloadStatus.queued,
                        DownloadStatus.canceled,
                        DownloadStatus.failed,
                      ].contains(item.status))
                        LinearProgressIndicator(
                          value: item.progress,
                          color: item.status == DownloadStatus.paused
                              ? context.themeData.disabledColor
                              : null,
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
