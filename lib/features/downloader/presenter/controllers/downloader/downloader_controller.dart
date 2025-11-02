import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_download_manager/flutter_download_manager.dart';
import 'package:isar/isar.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/data/database/collections/download_queue.dart';
import 'package:musily/core/data/database/database.dart';
import 'package:musily/core/data/services/download_isolate.dart';
import 'package:musily/core/domain/presenter/app_controller.dart';
import 'package:musily/features/album/domain/entities/album_entity.dart';
import 'package:musily/features/artist/domain/entitites/artist_entity.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_data.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_methods.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

class DownloaderController
    extends BaseController<DownloaderData, DownloaderMethods> {
  static final DownloaderController _instance =
      DownloaderController._internal();

  factory DownloaderController() {
    return _instance;
  }

  DownloaderController._internal();

  PlayerController? playerController;

  // Isolate management
  final Map<String, Isolate> _activeIsolates = {};
  final Map<String, ReceivePort> _activePorts = {};
  final Map<String, CancelToken> _cancelTokens = {};

  // Batch update management
  Timer? _batchUpdateTimer;
  bool _hasPendingUpdates = false;

  // Concurrent download limit
  static const int _maxConcurrentDownloads = 3;
  static const int _maxConcurrentUrlFetching = 5;
  int _activeDownloads = 0;
  int _activeFetching = 0;

  final Isar _isar = Database().isar;

  Future<void> init() async {
    await _migrateFromSharedPreferences();
    await methods.loadStoredQueue();
    _startBatchUpdateTimer();
  }

  Future<void> _migrateFromSharedPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final queueJson = prefs.getString('downloadQueue');

      if (queueJson == null || queueJson.isEmpty) {
        return;
      }

      // Check if already migrated
      final existingCount = await _isar.downloadQueueItems.count();
      if (existingCount > 0) {
        // Already migrated, clear SharedPreferences
        await prefs.remove('downloadQueue');
        return;
      }

      // Parse and migrate
      final queueList = jsonDecode(queueJson) as List;
      final dbItems = <DownloadQueueItem>[];

      for (final item in queueList) {
        final dbItem = DownloadQueueItem()
          ..hash = item['hash'] ?? ''
          ..trackId = item['id'] ?? ''
          ..title = item['title'] ?? ''
          ..artistId = item['artist']?['id'] ?? ''
          ..artistName = item['artist']?['name'] ?? ''
          ..albumId = item['album']?['id'] ?? ''
          ..albumTitle = item['album']?['title'] ?? ''
          ..highResImg = item['highResImg']
          ..lowResImg = item['lowResImg']
          ..url = item['url']
          ..durationSeconds = item['duration'] ?? 0
          ..progress = (item['progress'] as num?)?.toDouble() ?? 0.0
          ..status = item['status'] ?? 'queued'
          ..addedAt = DateTime.now().millisecondsSinceEpoch;

        dbItems.add(dbItem);
      }

      // Batch save to Isar
      await _isar.writeTxn(() async {
        await _isar.downloadQueueItems.putAll(dbItems);
      });

      // Clear SharedPreferences
      await prefs.remove('downloadQueue');
    } catch (e) {
      // Migration failed, but don't crash the app
      print('Migration from SharedPreferences failed: $e');
    }
  }

  void _startBatchUpdateTimer() {
    _batchUpdateTimer?.cancel();
    _batchUpdateTimer = Timer.periodic(
      const Duration(milliseconds: 500),
      (timer) {
        if (_hasPendingUpdates) {
          _hasPendingUpdates = false;
          updateData(data);
        }
      },
    );
  }

  void _scheduleUpdate() {
    _hasPendingUpdates = true;
  }

  void setPlayerController(PlayerController playerController) {
    this.playerController = playerController;
  }

  @override
  void dispose() {
    _batchUpdateTimer?.cancel();
    // Cancel all active downloads
    for (final isolate in _activeIsolates.values) {
      isolate.kill(priority: Isolate.immediate);
    }
    for (final port in _activePorts.values) {
      port.close();
    }
    _activeIsolates.clear();
    _activePorts.clear();
    _cancelTokens.clear();
    super.dispose();
  }

  @override
  DownloaderData defineData() {
    return DownloaderData(
      queue: [],
      downloadingKey: '',
    );
  }

  @override
  DownloaderMethods defineMethods() {
    return DownloaderMethods(
      cancelDownloadCollection: (tracks) async {
        for (final track in tracks) {
          final item = methods.getItem(track);
          if (item?.status == DownloadStatus.completed) {
            continue;
          }

          // Cancel isolate if active
          final isolate = _activeIsolates[track.hash];
          if (isolate != null) {
            isolate.kill(priority: Isolate.immediate);
            _activeIsolates.remove(track.hash);
            _activePorts[track.hash]?.close();
            _activePorts.remove(track.hash);
            _cancelTokens.remove(track.hash);
            _activeDownloads--;
          }

          // Remove from queue and map
          data.queue.removeWhere((e) => e.track.hash == track.hash);
          data.removeFromMap(track.hash);

          // Delete from database
          await _isar.writeTxn(() async {
            await _isar.downloadQueueItems
                .filter()
                .hashEqualTo(track.hash)
                .deleteAll();
          });
        }

        updateData(data);
        _processDownloadQueue();
      },
      cancelDownload: (url) async {
        final item = data.queue.where((e) => e.track.url == url).firstOrNull;
        if (item != null) {
          await methods.cancelDownloadCollection([item.track]);
        }
      },
      setDownloadingKey: (key) {
        updateData(data.copyWith(downloadingKey: key));
      },
      getItem: (track) {
        // O(1) lookup using hash map
        return data.getItemByHash(track.hash);
      },
      isOffline: (track) {
        // O(1) lookup using hash map
        return data.getItemByHash(track.hash) != null;
      },
      loadStoredQueue: () async {
        final items =
            await _isar.downloadQueueItems.where().sortByAddedAt().findAll();

        final queue = <DownloadingItem>[];
        for (final item in items) {
          final track = TrackEntity(
            id: item.trackId,
            hash: item.hash,
            title: item.title,
            artist: SimplifiedArtist(
              id: item.artistId,
              name: item.artistName,
            ),
            album: SimplifiedAlbum(
              id: item.albumId,
              title: item.albumTitle,
            ),
            highResImg: item.highResImg,
            lowResImg: item.lowResImg,
            url: item.url,
            duration: Duration(seconds: item.durationSeconds),
            fromSmartQueue: false,
          );

          var status = DownloadStatus.values.firstWhere(
            (e) => e.name == item.status,
            orElse: () => DownloadStatus.queued,
          );

          // Reset incomplete downloads
          if (status != DownloadStatus.completed) {
            status = DownloadStatus.queued;
            final appDir = await getApplicationSupportDirectory();
            final invalidFilePath = path.join(
              appDir.path,
              'media/audios/${track.hash}',
            );
            await methods.deleteDownloadedFile(path: invalidFilePath);
          }

          queue.add(DownloadingItem(
            track: track,
            status: status,
            progress: status == DownloadStatus.completed ? 1.0 : 0.0,
          ));
        }

        // Rebuild map after loading queue
        final newData = data.copyWith(queue: queue);
        newData.rebuildMap();
        updateData(newData);

        // Start processing queue
        _processDownloadQueue();
      },
      updateStoredQueue: () async {
        // This is now handled automatically with Isar
        // Individual items are updated as they change
      },
      deleteDownloadedFile: ({track, path}) async {
        if (path != null) {
          final file = File(path);
          final md5File = File('$path.md5');
          if (await file.exists()) {
            await file.delete();
          }
          if (await md5File.exists()) {
            await md5File.delete();
          }
          return;
        }

        if (track != null) {
          final item = methods.getItem(track);
          if (item != null) {
            data.queue.remove(item);
            data.removeFromMap(track.hash);

            // Delete from database
            await _isar.writeTxn(() async {
              await _isar.downloadQueueItems
                  .filter()
                  .hashEqualTo(track.hash)
                  .deleteAll();
            });

            if (track.url != null) {
              final file = File(track.url!);
              final md5File = File('${track.url!}.md5');
              if (await file.exists()) {
                await file.delete();
              }
              if (await md5File.exists()) {
                await md5File.delete();
              }
            }

            track.url = null;
            updateData(data);
          }
        }
      },
      trailing: (context, item) {
        return _buildTrailing(context, item);
      },
      saveMd5: (file) async {
        try {
          final bytes = await file.readAsBytes();
          final digest = md5.convert(bytes);
          final md5Hash = digest.toString();
          final md5File = File('${file.path}.md5');
          await md5File.writeAsString(md5Hash);
        } catch (e) {
          rethrow;
        }
      },
      checkFileIntegrity: (path) async {
        final file = File(path);
        final md5File = File('$path.md5');

        if (!await file.exists()) {
          return false;
        }

        if (!await md5File.exists()) {
          if (await file.exists()) {
            await file.delete();
          }
          return false;
        }

        try {
          final storedMd5 = await md5File.readAsString();
          final currentMd5 = md5.convert(await file.readAsBytes()).toString();

          if (storedMd5 == currentMd5) {
            return true;
          } else {
            await file.delete();
            await md5File.delete();
            return false;
          }
        } catch (e) {
          return false;
        }
      },
      getTrackPath: (track) async {
        final appDir = await getApplicationSupportDirectory();
        final trackDir = path.join(appDir.path, 'media/audios');
        final directory = Directory(trackDir);
        if (!directory.existsSync()) {
          await directory.create(recursive: true);
        }
        return path.join(trackDir, track.hash);
      },
      registerListeners: (task, item, downloadDir) async {
        // Not used in optimized version
      },
      downloadFile: (saveDir, url) async {
        // Check if file already exists and is valid
        if (await File(saveDir).exists()) {
          final isValidFile = await methods.checkFileIntegrity(saveDir);
          if (isValidFile) {
            return null; // Already downloaded
          }
          await methods.deleteDownloadedFile(path: saveDir);
        }

        // This will be handled by the isolate
        return null;
      },
      addDownload: (track, {position = 0}) async {
        await _addDownloadOptimized(track, position: position);
      },
      addDownloadBatch: (tracks) async {
        await _addDownloadBatch(tracks);
      },
      clearAllDownloads: () async {
        await _clearAllDownloads();
      },
      clearQueuedDownloads: () async {
        await _clearQueuedDownloads();
      },
      clearCompletedDownloads: () async {
        await _clearCompletedDownloads();
      },
    );
  }

  Future<void> _clearAllDownloads() async {
    // Cancel all active isolates
    for (final isolate in _activeIsolates.values) {
      isolate.kill(priority: Isolate.immediate);
    }
    for (final port in _activePorts.values) {
      port.close();
    }
    _activeIsolates.clear();
    _activePorts.clear();
    _cancelTokens.clear();
    _activeDownloads = 0;
    _activeFetching = 0;

    // Clear in-memory queue and map
    data.queue.clear();
    data.clearMap();

    // Clear database
    await _isar.writeTxn(() async {
      await _isar.downloadQueueItems.clear();
    });

    updateData(data);
  }

  Future<void> _clearQueuedDownloads() async {
    final queuedItems = data.queue
        .where((e) =>
            e.status == DownloadStatus.queued ||
            e.status == DownloadStatus.downloading ||
            e.status == DownloadStatus.paused ||
            e.status == DownloadStatus.failed)
        .toList();

    for (final item in queuedItems) {
      // Cancel isolate if active
      final isolate = _activeIsolates[item.track.hash];
      if (isolate != null) {
        isolate.kill(priority: Isolate.immediate);
        _activeIsolates.remove(item.track.hash);
        _activePorts[item.track.hash]?.close();
        _activePorts.remove(item.track.hash);
        _cancelTokens.remove(item.track.hash);
        _activeDownloads--;
      }

      // Remove from in-memory queue and map
      data.queue.remove(item);
      data.removeFromMap(item.track.hash);

      // Delete incomplete file if exists
      if (item.track.url != null) {
        final appDir = await getApplicationSupportDirectory();
        final filePath = path.join(
          appDir.path,
          'media/audios/${item.track.hash}',
        );
        await methods.deleteDownloadedFile(path: filePath);
      }
    }

    // Batch delete from database
    await _isar.writeTxn(() async {
      final hashes = queuedItems.map((e) => e.track.hash).toList();
      for (final hash in hashes) {
        await _isar.downloadQueueItems.filter().hashEqualTo(hash).deleteAll();
      }
    });

    updateData(data);
  }

  Future<void> _clearCompletedDownloads() async {
    final completedItems =
        data.queue.where((e) => e.status == DownloadStatus.completed).toList();

    for (final item in completedItems) {
      // Remove from in-memory queue and map
      data.queue.remove(item);
      data.removeFromMap(item.track.hash);

      // Delete downloaded file
      if (item.track.url != null) {
        final file = File(item.track.url!);
        final md5File = File('${item.track.url!}.md5');
        if (await file.exists()) {
          await file.delete();
        }
        if (await md5File.exists()) {
          await md5File.delete();
        }
      }
    }

    // Batch delete from database
    await _isar.writeTxn(() async {
      final hashes = completedItems.map((e) => e.track.hash).toList();
      for (final hash in hashes) {
        await _isar.downloadQueueItems.filter().hashEqualTo(hash).deleteAll();
      }
    });

    updateData(data);
  }

  Future<void> _addDownloadBatch(List<TrackEntity> tracks) async {
    if (tracks.isEmpty) return;

    // Process in chunks to prevent UI freeze
    const chunkSize = 100;
    final totalChunks = (tracks.length / chunkSize).ceil();

    for (int chunkIndex = 0; chunkIndex < totalChunks; chunkIndex++) {
      final start = chunkIndex * chunkSize;
      final end = (start + chunkSize).clamp(0, tracks.length);
      final chunk = tracks.sublist(start, end);

      final newItems = <DownloadingItem>[];
      final dbItems = <DownloadQueueItem>[];

      for (final track in chunk) {
        // O(1) check if already in queue using map
        if (data.getItemByHash(track.hash) != null) {
          continue;
        }

        // Create download item
        final downloadItem = DownloadingItem(
          track: track,
          progress: 0,
          status: DownloadStatus.queued,
          boosted: false,
        );

        newItems.add(downloadItem);

        // Create database item
        final dbItem = DownloadQueueItem()
          ..hash = track.hash
          ..trackId = track.id
          ..title = track.title
          ..artistId = track.artist.id
          ..artistName = track.artist.name
          ..albumId = track.album.id
          ..albumTitle = track.album.title
          ..highResImg = track.highResImg
          ..lowResImg = track.lowResImg
          ..url = track.url
          ..durationSeconds = track.duration.inSeconds
          ..progress = 0.0
          ..status = DownloadStatus.queued.name
          ..addedAt = DateTime.now().millisecondsSinceEpoch;

        dbItems.add(dbItem);
      }

      if (newItems.isEmpty) {
        continue;
      }

      // Add to in-memory queue and map simultaneously
      data.queue.addAll(newItems);
      for (final item in newItems) {
        data.addToMap(item);
      }

      // Batch save to database
      await _isar.writeTxn(() async {
        await _isar.downloadQueueItems.putAll(dbItems);
      });

      // Schedule deferred update instead of immediate
      _scheduleUpdate();

      // Yield to allow UI to remain responsive
      await Future.delayed(Duration.zero);
    }

    // Start processing if not at max capacity
    _processDownloadQueue();
  }

  Future<void> _addDownloadOptimized(TrackEntity track,
      {int position = 0}) async {
    // O(1) check if already in queue
    if (data.getItemByHash(track.hash) != null) {
      return;
    }

    // Create download item
    final downloadItem = DownloadingItem(
      track: track,
      progress: 0,
      status: DownloadStatus.queued,
      boosted: false,
    );

    // Add to in-memory queue and map
    if (position == 0) {
      data.queue.add(downloadItem);
    } else {
      data.queue.insert(position, downloadItem);
    }
    data.addToMap(downloadItem);

    // Save to database
    await _isar.writeTxn(() async {
      final dbItem = DownloadQueueItem()
        ..hash = track.hash
        ..trackId = track.id
        ..title = track.title
        ..artistId = track.artist.id
        ..artistName = track.artist.name
        ..albumId = track.album.id
        ..albumTitle = track.album.title
        ..highResImg = track.highResImg
        ..lowResImg = track.lowResImg
        ..url = track.url
        ..durationSeconds = track.duration.inSeconds
        ..progress = 0.0
        ..status = DownloadStatus.queued.name
        ..addedAt = DateTime.now().millisecondsSinceEpoch;

      await _isar.downloadQueueItems.put(dbItem);
    });

    // Use deferred update for consistency
    _scheduleUpdate();

    // Start processing if not at max capacity
    _processDownloadQueue();
  }

  Future<void> _processDownloadQueue() async {
    // Process queued items
    final queuedItems =
        data.queue.where((e) => e.status == DownloadStatus.queued).toList();

    for (final item in queuedItems) {
      if (_activeDownloads >= _maxConcurrentDownloads) {
        break;
      }

      // Fetch URL if needed
      if (item.track.url == null) {
        if (_activeFetching >= _maxConcurrentUrlFetching) {
          continue;
        }

        _activeFetching++;
        try {
          final playableItem =
              await playerController?.getPlayableItemUsecase.exec(item.track);
          if (playableItem?.url == null) {
            item.status = DownloadStatus.failed;
            _scheduleUpdate();
            await _updateItemInDatabase(item);
            continue;
          }
          item.track.url = playableItem!.url;
        } catch (e) {
          item.status = DownloadStatus.failed;
          _scheduleUpdate();
          await _updateItemInDatabase(item);
          continue;
        } finally {
          _activeFetching--;
        }
      }

      // Start download in isolate
      await _startDownloadInIsolate(item);
    }
  }

  Future<void> _startDownloadInIsolate(DownloadingItem item) async {
    if (item.track.url == null) return;

    _activeDownloads++;
    item.status = DownloadStatus.downloading;
    _scheduleUpdate();
    await _updateItemInDatabase(item);

    final receivePort = ReceivePort();
    _activePorts[item.track.hash] = receivePort;

    final downloadPath = await methods.getTrackPath(item.track);

    final params = DownloadIsolateParams(
      url: item.track.url!,
      savePath: downloadPath,
      sendPort: receivePort.sendPort,
      trackHash: item.track.hash,
    );

    // Listen for progress updates
    receivePort.listen((message) async {
      if (message is DownloadProgressMessage) {
        if (message.trackHash == item.track.hash) {
          item.progress = message.progress;
          item.status = DownloadStatus.values.firstWhere(
            (e) => e.name == message.status,
            orElse: () => DownloadStatus.downloading,
          );

          if (item.status == DownloadStatus.completed) {
            item.track.url = downloadPath;
            _activeDownloads--;
            _activePorts[item.track.hash]?.close();
            _activePorts.remove(item.track.hash);
            _activeIsolates[item.track.hash]?.kill(priority: Isolate.immediate);
            _activeIsolates.remove(item.track.hash);

            // Process next item in queue
            _processDownloadQueue();
          } else if (item.status == DownloadStatus.failed) {
            _activeDownloads--;
            _activePorts[item.track.hash]?.close();
            _activePorts.remove(item.track.hash);
            _activeIsolates[item.track.hash]?.kill(priority: Isolate.immediate);
            _activeIsolates.remove(item.track.hash);

            // Process next item in queue
            _processDownloadQueue();
          }

          _scheduleUpdate();
          await _updateItemInDatabase(item);
        }
      }
    });

    // Spawn isolate
    final isolate = await Isolate.spawn(
      DownloadIsolate.downloadFileIsolate,
      params,
    );
    _activeIsolates[item.track.hash] = isolate;
  }

  Future<void> _updateItemInDatabase(DownloadingItem item) async {
    await _isar.writeTxn(() async {
      final dbItem = await _isar.downloadQueueItems
          .filter()
          .hashEqualTo(item.track.hash)
          .findFirst();

      if (dbItem != null) {
        dbItem
          ..url = item.track.url
          ..progress = item.progress
          ..status = item.status.name;

        await _isar.downloadQueueItems.put(dbItem);
      }
    });
  }

  Widget _buildTrailing(BuildContext context, DownloadingItem item) {
    final deleteButton = IconButton(
      onPressed: () async {
        await methods.deleteDownloadedFile(track: item.track);
      },
      icon: const Icon(LucideIcons.trash, size: 20),
    );

    final cancelButton = IconButton(
      onPressed: () async {
        await methods.cancelDownloadCollection([item.track]);
      },
      icon: const Icon(LucideIcons.x, size: 20),
    );

    final retryButton = IconButton(
      onPressed: () async {
        final itemIndex = data.queue.indexOf(item);
        data.queue.removeAt(itemIndex);
        data.removeFromMap(item.track.hash);
        await methods.addDownload(item.track, position: itemIndex);
      },
      icon: const Icon(LucideIcons.refreshCcw, size: 20),
    );

    final completedTrailing = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        deleteButton,
        if (playerController != null)
          playerController!.builder(
            builder: (context, data) {
              final isPlayingOffline = data.playingId == 'offline';
              final isPlayingThisItem = (data.currentPlayingItem?.hash ??
                      data.currentPlayingItem?.id) ==
                  item.track.hash;
              late final IconData icon;
              if (isPlayingOffline && isPlayingThisItem && data.isPlaying) {
                icon = LucideIcons.pause;
              } else {
                icon = LucideIcons.play;
              }
              return IconButton(
                onPressed: () {
                  if (isPlayingOffline && isPlayingThisItem) {
                    if (data.isPlaying) {
                      playerController!.methods.pause();
                    } else {
                      playerController!.methods.resume();
                    }
                  } else if (isPlayingOffline) {
                    playerController!.methods.queueJumpTo(item.track.id);
                  } else {
                    playerController!.methods.playPlaylist(
                      this.data.queue.map((e) => e.track).toList(),
                      'offline',
                      startFromTrackId: item.track.id,
                    );
                  }
                },
                icon: Icon(icon, size: 20),
              );
            },
          ),
      ],
    );

    switch (item.status) {
      case DownloadStatus.queued:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(LucideIcons.hourglass, size: 20),
            const SizedBox(width: 8),
            cancelButton,
          ],
        );
      case DownloadStatus.downloading:
        return cancelButton;
      case DownloadStatus.completed:
        return completedTrailing;
      case DownloadStatus.failed:
      case DownloadStatus.canceled:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [retryButton, deleteButton],
        );
      case DownloadStatus.paused:
        return cancelButton;
    }
  }
}

class CancelToken {
  bool isCanceled = false;
}
