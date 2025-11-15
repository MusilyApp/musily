import 'package:flutter_download_manager/flutter_download_manager.dart';
import 'package:musily/core/domain/presenter/app_controller.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';

class DownloadingItem {
  final TrackEntity track;
  double progress;
  DownloadStatus status;
  bool boosted;

  int downloadedBytes;
  int totalBytes;
  double downloadSpeed;
  DateTime? startTime;
  DateTime? endTime;
  DateTime? processingStartTime;
  String? errorMessage;
  String? lastLog;
  int partsCount;
  int completedParts;

  final List<double> _speedHistory = [];
  static const int _maxSpeedSamples = 20;

  DownloadStatus get downloadCompleted => DownloadStatus.completed;
  DownloadStatus get downloadQueued => DownloadStatus.queued;
  DownloadStatus get downloadDownloading => DownloadStatus.downloading;
  DownloadStatus get downloadPaused => DownloadStatus.paused;
  DownloadStatus get downloadFailed => DownloadStatus.failed;
  DownloadStatus get downloadCanceled => DownloadStatus.canceled;

  void addSpeedSample(double speed) {
    if (speed <= 0) return;

    _speedHistory.add(speed);

    if (_speedHistory.length > _maxSpeedSamples) {
      _speedHistory.removeAt(0);
    }

    if (_speedHistory.isNotEmpty) {
      downloadSpeed =
          _speedHistory.reduce((a, b) => a + b) / _speedHistory.length;
    }
  }

  double get smoothedSpeed {
    if (_speedHistory.isEmpty) return downloadSpeed;
    return _speedHistory.reduce((a, b) => a + b) / _speedHistory.length;
  }

  String get formattedSpeed {
    final speed = smoothedSpeed;
    if (speed <= 0) return '0 B/s';
    if (speed < 1024) return '${speed.toStringAsFixed(0)} B/s';
    if (speed < 1024 * 1024) {
      return '${(speed / 1024).toStringAsFixed(1)} KB/s';
    }
    return '${(speed / (1024 * 1024)).toStringAsFixed(2)} MB/s';
  }

  String get formattedSize {
    if (totalBytes <= 0) return '0 B';
    if (totalBytes < 1024) return '$totalBytes B';
    if (totalBytes < 1024 * 1024) {
      return '${(totalBytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(totalBytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }

  String get formattedDownloaded {
    if (downloadedBytes <= 0) return '0 B';
    if (downloadedBytes < 1024) return '$downloadedBytes B';
    if (downloadedBytes < 1024 * 1024) {
      return '${(downloadedBytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(downloadedBytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }

  Duration? get estimatedTimeRemaining {
    final speed = smoothedSpeed;
    if (speed <= 0 || totalBytes <= 0) return null;
    final remaining = totalBytes - downloadedBytes;
    if (remaining <= 0) return Duration.zero;
    return Duration(seconds: (remaining / speed).ceil());
  }

  String get formattedTimeRemaining {
    final eta = estimatedTimeRemaining;
    if (eta == null) return '--:--';
    if (eta.inHours > 0) {
      return '${eta.inHours}h ${eta.inMinutes.remainder(60)}m';
    }
    if (eta.inMinutes > 0) {
      return '${eta.inMinutes}m ${eta.inSeconds.remainder(60)}s';
    }
    return '${eta.inSeconds}s';
  }

  DownloadingItem({
    required this.track,
    required this.progress,
    required this.status,
    this.boosted = false,
    this.downloadedBytes = 0,
    this.totalBytes = 0,
    this.downloadSpeed = 0.0,
    this.startTime,
    this.endTime,
    this.processingStartTime,
    this.errorMessage,
    this.lastLog,
    this.partsCount = 0,
    this.completedParts = 0,
  });
}

class DownloaderData implements BaseControllerData {
  final List<DownloadingItem> queue;
  final String? downloadingKey;

  final Map<String, DownloadingItem> _queueMap;

  DownloaderData({
    required this.queue,
    required this.downloadingKey,
    Map<String, DownloadingItem>? queueMap,
  }) : _queueMap = queueMap ?? {};

  DownloadingItem? getItemByHash(String hash) => _queueMap[hash];

  void addToMap(DownloadingItem item) {
    _queueMap[item.track.hash] = item;
  }

  void removeFromMap(String hash) {
    _queueMap.remove(hash);
  }

  void clearMap() {
    _queueMap.clear();
  }

  int get totalDownloadingCount =>
      queue.where((e) => e.status == DownloadStatus.downloading).length;

  int get totalQueuedCount =>
      queue.where((e) => e.status == DownloadStatus.queued).length;

  int get totalCompletedCount =>
      queue.where((e) => e.status == DownloadStatus.completed).length;

  int get totalFailedCount => queue
      .where((e) =>
          e.status == DownloadStatus.failed ||
          e.status == DownloadStatus.canceled)
      .length;

  double get globalDownloadSpeed {
    final downloading =
        queue.where((e) => e.status == DownloadStatus.downloading);
    if (downloading.isEmpty) return 0.0;
    return downloading.fold(0.0, (sum, item) => sum + item.smoothedSpeed);
  }

  String get formattedGlobalSpeed {
    final speed = globalDownloadSpeed;
    if (speed <= 0) return '0 B/s';
    if (speed < 1024) return '${speed.toStringAsFixed(0)} B/s';
    if (speed < 1024 * 1024) {
      return '${(speed / 1024).toStringAsFixed(1)} KB/s';
    }
    return '${(speed / (1024 * 1024)).toStringAsFixed(2)} MB/s';
  }

  int get totalDownloadedBytes {
    return queue.fold(0, (sum, item) => sum + item.downloadedBytes);
  }

  int get totalBytes {
    return queue.fold(0, (sum, item) => sum + item.totalBytes);
  }

  double get globalProgress {
    if (queue.isEmpty) return 0.0;
    if (totalBytes <= 0) return 0.0;
    return totalDownloadedBytes / totalBytes;
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

  void rebuildMap() {
    _queueMap.clear();
    for (final item in queue) {
      _queueMap[item.track.hash] = item;
    }
  }
}
