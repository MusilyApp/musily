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

  // HashMap for O(1) lookups by track hash
  final Map<String, DownloadingItem> _queueMap;

  DownloaderData({
    required this.queue,
    required this.downloadingKey,
    Map<String, DownloadingItem>? queueMap,
  }) : _queueMap = queueMap ?? {};

  // O(1) lookup by track hash
  DownloadingItem? getItemByHash(String hash) => _queueMap[hash];

  // Add item to map
  void addToMap(DownloadingItem item) {
    _queueMap[item.track.hash] = item;
  }

  // Remove item from map by hash
  void removeFromMap(String hash) {
    _queueMap.remove(hash);
  }

  // Clear entire map
  void clearMap() {
    _queueMap.clear();
  }

  @override
  DownloaderData copyWith({
    List<DownloadingItem>? queue,
    String? downloadingKey,
    Map<String, DownloadingItem>? queueMap,
  }) {
    return DownloaderData(
      queue: queue ?? this.queue,
      downloadingKey: downloadingKey ?? this.downloadingKey,
      queueMap: queueMap ?? _queueMap,
    );
  }

  // Helper to rebuild map from queue
  void rebuildMap() {
    _queueMap.clear();
    for (final item in queue) {
      _queueMap[item.track.hash] = item;
    }
  }
}
