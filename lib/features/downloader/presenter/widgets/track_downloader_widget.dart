import 'package:flutter/material.dart';
import 'package:musily/core/domain/uasecases/get_playable_item_usecase.dart';
import 'package:musily/core/utils/string_is_url.dart';
import 'package:musily/features/downloader/domain/entities/item_queue_entity.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class TrackDownloaderBuilder extends StatelessWidget {
  final DownloaderController downloaderController;
  final TrackEntity track;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final Widget Function(
    BuildContext context,
    double progress,
    Future<void> Function() startDownload,
    void Function() removeDownloadedFile,
    void Function() cancelDownload,
  ) builder;
  const TrackDownloaderBuilder({
    required this.downloaderController,
    required this.track,
    required this.builder,
    required this.getPlayableItemUsecase,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return downloaderController.builder(
      builder: (context, data) {
        final queueItem = data.downloadQueue.where(
          (item) => item.id == 'media/audios/${track.hash}',
        );
        if (queueItem.isNotEmpty && queueItem.first.cancelDownload) {
          return builder(
            context,
            0,
            () async {
              if (queueItem.isNotEmpty) {
                queueItem.first.cancelDownload = false;
                return;
              }
            },
            () {},
            () async {},
          );
        }
        if (queueItem.isEmpty) {
          downloaderController.methods.getFile('media/audios/${track.hash}');
          return builder(
            context,
            0,
            () async {
              downloaderController.methods.addDownload(
                ItemQueueEntity(
                  id: 'media/audios/${track.hash}',
                  url: track.url ?? '',
                  fileName: 'media/audios/${track.hash}',
                ),
                downloadingId: track.hash,
                ytId: track.id,
              );
              if (stringIsUrl(track.highResImg ?? '') &&
                  stringIsUrl(track.lowResImg ?? '')) {
                downloaderController.methods.addDownload(
                  ItemQueueEntity(
                    id: 'media/images/${track.album.id}-600x600',
                    url: track.highResImg ?? '',
                    fileName: 'media/images/${track.album.id}-600x600',
                  ),
                  downloadingId: track.hash,
                );
                downloaderController.methods.addDownload(
                  ItemQueueEntity(
                    id: 'media/images/${track.album.id}-60x60',
                    url: track.lowResImg ?? '',
                    fileName: 'media/images/${track.album.id}-60x60',
                  ),
                  downloadingId: track.hash,
                );
              }
            },
            () {},
            () {
              downloaderController.methods
                  .cancelDownload('media/audios/${track.hash}');
            },
          );
        }
        if (queueItem.isNotEmpty &&
            queueItem.first.progress == 0 &&
            !queueItem.first.cancelDownload) {
          return builder(context, 2.0, () async {}, () {}, () {
            downloaderController.methods
                .cancelDownload('media/audios/${track.hash}');
          });
        }
        if (queueItem.first.progress == 1.0) {
          track.url = queueItem.first.filePath;
          return builder(context, 1.0, () async {}, () {
            track.url = null;
            track.url = null;
            downloaderController.methods.removeDownload(
              'media/audios/${track.hash}',
            );
          }, () {
            downloaderController.methods
                .cancelDownload('media/audios/${track.hash}');
          });
        }
        return StreamBuilder<double>(
          stream: queueItem.first.progressStream,
          builder: (context, snapshot) {
            return builder(context, snapshot.data ?? 0, () async {}, () {}, () {
              downloaderController.methods
                  .cancelDownload('media/audios/${track.hash}');
            });
          },
        );
      },
    );
  }
}

class TrackDownloaderWidget extends StatefulWidget {
  final DownloaderController downloaderController;
  final TrackEntity track;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  const TrackDownloaderWidget({
    required this.downloaderController,
    required this.track,
    required this.getPlayableItemUsecase,
    super.key,
  });

  @override
  State<TrackDownloaderWidget> createState() => _TrackDownloaderWidgetState();
}

class _TrackDownloaderWidgetState extends State<TrackDownloaderWidget> {
  @override
  Widget build(BuildContext context) {
    return TrackDownloaderBuilder(
      downloaderController: widget.downloaderController,
      getPlayableItemUsecase: widget.getPlayableItemUsecase,
      track: widget.track,
      builder: (
        context,
        progress,
        startDownload,
        removeDownloadedFile,
        cancelDownload,
      ) {
        return widget.downloaderController.builder(
          builder: (context, data) {
            final queueItem = data.downloadQueue.where(
              (item) => item.id == 'media/audios/${widget.track.hash}',
            );
            final itemInDownloadQueue = queueItem.isNotEmpty;
            final downloadCancelled =
                queueItem.firstOrNull?.cancelDownload ?? false;
            if (progress == 1) {
              return IconButton(
                onPressed: removeDownloadedFile,
                icon: Icon(
                  Icons.download_done_rounded,
                  color: Theme.of(context).buttonTheme.colorScheme?.primary,
                ),
              );
            }
            if (progress == 0 && (!itemInDownloadQueue || downloadCancelled)) {
              return IconButton(
                onPressed: () async {
                  startDownload();
                },
                icon: Icon(
                  Icons.download_rounded,
                  color: Theme.of(context).buttonTheme.colorScheme?.primary,
                ),
              );
            }
            if (progress == 2 && itemInDownloadQueue) {
              return IconButton(
                onPressed: () => cancelDownload(),
                icon: const Icon(
                  Icons.hourglass_bottom_rounded,
                ),
              );
            }
            if (queueItem.isNotEmpty) {
              return IconButton(
                onPressed: () => cancelDownload(),
                icon: CircularPercentIndicator(
                  lineWidth: 4,
                  percent: progress,
                  startAngle: 180,
                  backgroundColor: Theme.of(context)
                          .buttonTheme
                          .colorScheme
                          ?.primary
                          .withOpacity(.15) ??
                      Colors.white,
                  progressColor:
                      Theme.of(context).buttonTheme.colorScheme?.primary ??
                          Colors.white,
                  radius: 10,
                  center: Icon(
                    Icons.cancel_rounded,
                    size: 12,
                    color: Theme.of(context).buttonTheme.colorScheme?.primary,
                  ),
                ),
              );
            }
            return Container();
          },
        );
      },
    );
  }
}
