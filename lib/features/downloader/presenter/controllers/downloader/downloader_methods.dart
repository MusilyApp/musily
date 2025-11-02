import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_download_manager/flutter_download_manager.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_data.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';

class DownloaderMethods {
  final Future<void> Function(
    TrackEntity track, {
    int position,
  }) addDownload;
  final Future<void> Function(List<TrackEntity> tracks)? addDownloadBatch;
  final void Function(String key) setDownloadingKey;
  final Future<DownloadTask?> Function(
    String path,
    String url,
  ) downloadFile;
  final Future<void> Function(
    File file,
  ) saveMd5;
  final Future<bool> Function(
    String path,
  ) checkFileIntegrity;

  final Widget Function(
    BuildContext context,
    DownloadingItem item,
  ) trailing;

  final Future<void> Function({
    TrackEntity? track,
    String? path,
  }) deleteDownloadedFile;
  final Future<void> Function(
    String url,
  ) cancelDownload;
  final Future<void> Function(
    List<TrackEntity> tracks,
  ) cancelDownloadCollection;
  final Future<void> Function() clearAllDownloads;
  final Future<void> Function() clearQueuedDownloads;
  final Future<void> Function() clearCompletedDownloads;

  final Future<void> Function() loadStoredQueue;
  final Future<void> Function() updateStoredQueue;
  final bool Function(TrackEntity track) isOffline;
  final DownloadingItem? Function(TrackEntity track) getItem;
  final Future<String> Function(TrackEntity track) getTrackPath;
  final Future<void> Function(
    DownloadTask task,
    DownloadingItem item,
    String downloadDir,
  ) registerListeners;

  DownloaderMethods({
    required this.addDownload,
    this.addDownloadBatch,
    required this.setDownloadingKey,
    required this.downloadFile,
    required this.saveMd5,
    required this.checkFileIntegrity,
    required this.trailing,
    required this.deleteDownloadedFile,
    required this.loadStoredQueue,
    required this.updateStoredQueue,
    required this.getTrackPath,
    required this.registerListeners,
    required this.isOffline,
    required this.getItem,
    required this.cancelDownload,
    required this.cancelDownloadCollection,
    required this.clearAllDownloads,
    required this.clearQueuedDownloads,
    required this.clearCompletedDownloads,
  });
}
