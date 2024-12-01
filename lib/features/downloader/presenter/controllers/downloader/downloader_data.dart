import 'package:flutter_download_manager/flutter_download_manager.dart';
import 'package:musily/core/domain/presenter/app_controller.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';

class DownloadingItem {
  final TrackEntity track;
  double progress;
  DownloadStatus status;
  bool boosted;

  DownloadStatus get downloadCompleted => DownloadStatus.completed;
  DownloadStatus get downloadQueued => DownloadStatus.queued;
  DownloadStatus get downloadDownloading => DownloadStatus.downloading;
  DownloadStatus get downloadPaused => DownloadStatus.paused;
  DownloadStatus get downloadFailed => DownloadStatus.failed;
  DownloadStatus get downloadCanceled => DownloadStatus.canceled;

  DownloadingItem({
    required this.track,
    required this.progress,
    required this.status,
    this.boosted = false,
  });
}

class DownloaderData implements BaseControllerData {
  final List<DownloadingItem> queue;
  final String? downloadingKey;

  DownloaderData({
    required this.queue,
    required this.downloadingKey,
  });

  @override
  DownloaderData copyWith({
    List<DownloadingItem>? queue,
    String? downloadingKey,
  }) {
    return DownloaderData(
      queue: queue ?? this.queue,
      downloadingKey: downloadingKey ?? this.downloadingKey,
    );
  }
}
