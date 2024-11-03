import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_download_manager/flutter_download_manager.dart';
import 'package:musily/core/domain/presenter/app_controller.dart';
import 'package:musily/core/presenter/extensions/string.dart';
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

  int _gettingUrl = 0;
  bool _gettingUrlLocked = false;

  final DownloadManager downloadManager = DownloadManager();
  PlayerController? playerController;

  Future<void> init() async {
    await methods.loadStoredQueue();
  }

  void setPlayerController(
    PlayerController playerController,
  ) {
    this.playerController = playerController;
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
        _gettingUrlLocked = true;
        for (final track in tracks) {
          final item = methods.getItem(track);
          if (item?.status == item?.downloadCompleted) {
            continue;
          }
          if (item?.track.url == null) {
            item?.status = DownloadStatus.canceled;
            continue;
          }
          item!.status = item.downloadCanceled;
          await methods.cancelDownload(item.track.url!);
          updateData(
            data.copyWith(
              queue: data.queue
                ..remove(
                  item,
                ),
            ),
          );
        }
        _gettingUrlLocked = false;
        final downloadingItems = data.queue.where(
          (e) => e.status == e.downloadDownloading,
        );
        if (downloadingItems.length >= 5) {
          _gettingUrl = 5;
        } else {
          _gettingUrl = downloadingItems.length;
        }
      },
      cancelDownload: (url) async {
        final item = data.queue.where((e) => e.track.url == url).firstOrNull;
        if (item?.status == item?.downloadCompleted) {
          return;
        }
        if (!url.isUrl) {
          return;
        }
        await downloadManager.cancelDownload(
          url,
        );
      },
      setDownloadingKey: (key) {
        updateData(
          data.copyWith(
            downloadingKey: key,
          ),
        );
      },
      getItem: (track) {
        return data.queue
            .where(
              (e) => (e.track.hash) == track.hash,
            )
            .firstOrNull;
      },
      isOffline: (track) {
        return data.queue
            .where(
              (e) => e.track.hash == track.hash,
            )
            .isNotEmpty;
      },
      loadStoredQueue: () async {
        final prefs = await SharedPreferences.getInstance();
        final queueJson = prefs.getString('downloadQueue');
        if (queueJson != null) {
          final queueList = jsonDecode(queueJson) as List;
          final queue = queueList.map((item) {
            final track = TrackEntity(
              id: item['id'],
              hash: item['hash'],
              title: item['title'],
              artist: SimplifiedArtist(
                id: item['artist']?['id'] ?? '',
                name: item['artist']?['name'] ?? '',
              ),
              album: SimplifiedAlbum(
                id: item['album']?['id'] ?? '',
                title: item['album']?['title'] ?? '',
              ),
              highResImg: item['highResImg'],
              lowResImg: item['lowResImg'],
              url: item['url'],
              duration: Duration(
                seconds: item['duration'],
              ),
              fromSmartQueue: false,
            );
            final status = DownloadStatus.values.byName(item['status']);
            final progress = item['progress'] as double;
            return DownloadingItem(
              track: track,
              status: status,
              progress: progress,
            );
          }).toList();
          final List<DownloadingItem> queueCopy = List.from(queue);
          for (final item in queueCopy) {
            if (item.status != DownloadStatus.completed) {
              final appDir = await getApplicationSupportDirectory();
              final invalidFilePath = path.join(
                appDir.path,
                'media/audios/${item.track.hash}.partial',
              );
              await methods.deleteDownloadedFile(
                path: invalidFilePath,
              );
              queue.removeWhere(
                (e) => e.track.hash == item.track.hash,
              );
            }
          }
          updateData(
            data.copyWith(
              queue: queue,
            ),
          );
        }
      },
      updateStoredQueue: () async {
        final prefs = await SharedPreferences.getInstance();
        final queueJson = jsonEncode(data.queue.map((item) {
          return {
            'id': item.track.id,
            'hash': item.track.hash,
            'title': item.track.title,
            'artist': {
              'id': item.track.artist.id,
              'name': item.track.artist.name,
            },
            'album': {
              'id': item.track.album.id,
              'title': item.track.album.title,
            },
            'highResImg': item.track.highResImg,
            'lowResImg': item.track.lowResImg,
            'duration': item.track.duration.inSeconds,
            'url': item.track.url,
            'status': item.status.name,
            'progress': item.progress,
          };
        }).toList());
        await prefs.setString('downloadQueue', queueJson);
        updateData(data);
      },
      deleteDownloadedFile: ({track, path}) async {
        if ((track?.url ?? path)?.isDirectory ?? false) {
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
          final item = data.queue
              .where((e) =>
                  [e.track.hash, e.track.id].contains(track?.hash ?? track?.id))
              .firstOrNull;
          if (item != null) {
            final index = data.queue.indexOf(item);
            updateData(
              data.copyWith(
                queue: data.queue..removeAt(index),
              ),
            );
            final file = File(track!.url!);
            final invalidFile = File('${track.url!}.partial');
            final md5File = File('${track.url!}.md5');
            if (await invalidFile.exists()) {
              await invalidFile.delete();
            }
            if (await file.exists()) {
              await file.delete();
            }
            if (await md5File.exists()) {
              await md5File.delete();
            }
          }
          track?.url = null;
          await methods.updateStoredQueue();
        }
      },
      trailing: (context, item) {
        final deleteButton = IconButton(
          onPressed: () async {
            await methods.deleteDownloadedFile(
              track: item.track,
            );
          },
          icon: const Icon(
            Icons.delete_rounded,
          ),
        );
        final queuedButton = IconButton(
          onPressed: () {
            downloadManager.cancelDownload(
              item.track.url!,
            );
          },
          icon: const Icon(
            Icons.hourglass_bottom_rounded,
          ),
        );
        final cancelButton = IconButton(
          onPressed: () {
            methods.cancelDownload(item.track.url!);
          },
          icon: const Icon(
            Icons.close_rounded,
          ),
        );
        final pauseButton = IconButton(
          onPressed: () {
            downloadManager.pauseDownload(item.track.url!);
          },
          icon: const Icon(
            Icons.pause_rounded,
          ),
        );
        final resumeButton = IconButton(
          onPressed: () {
            downloadManager.resumeDownload(item.track.url!);
          },
          icon: const Icon(
            Icons.play_arrow_rounded,
          ),
        );

        final downloadingTrailing = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            pauseButton,
            cancelButton,
          ],
        );
        final retryTrailing = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                final itemIndex = data.queue.indexOf(item);
                data.queue.removeAt(itemIndex);
                methods.addDownload(
                  item.track,
                  position: itemIndex,
                );
              },
              icon: const Icon(
                Icons.refresh_rounded,
              ),
            ),
            deleteButton,
          ],
        );
        final queuedTrailing = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            queuedButton,
            cancelButton,
          ],
        );
        final pausedTrailing = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            resumeButton,
            cancelButton,
          ],
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
                    icon = Icons.pause_rounded;
                  } else {
                    icon = Icons.play_arrow_rounded;
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
                        final index = data.queue.indexWhere(
                          (e) => e.hash == item.track.hash,
                        );
                        if (index != -1) {
                          playerController!.methods.queueJumpTo(index);
                        }
                      } else {
                        final index = this.data.queue.indexOf(item);
                        playerController!.methods.playPlaylist(
                          this.data.queue.map((e) => e.track).toList(),
                          'offline',
                          startFrom: index,
                        );
                      }
                    },
                    icon: Icon(
                      icon,
                    ),
                  );
                },
              ),
          ],
        );

        switch (item.status) {
          case DownloadStatus.queued:
            return queuedTrailing;
          case DownloadStatus.downloading:
            return downloadingTrailing;
          case DownloadStatus.completed:
            return completedTrailing;
          case DownloadStatus.failed:
            return retryTrailing;
          case DownloadStatus.paused:
            return pausedTrailing;
          case DownloadStatus.canceled:
            return retryTrailing;
        }
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
        File file = File(path);
        File md5File = File('$path.md5');

        if (!await file.exists()) {
          return false;
        }

        if (!await md5File.exists()) {
          if (!await file.exists()) {
            await file.delete();
          }
          return false;
        }

        try {
          String storedMd5 = await md5File.readAsString();
          String currentMd5 = md5.convert(await file.readAsBytes()).toString();

          if (storedMd5 == currentMd5) {
            return true;
          } else {
            await file.delete();
            await md5File.delete();
            return false;
          }
        } catch (e, stacktrace) {
          throw Exception('Error verifying file integrity: $e - $stacktrace');
        }
      },
      getTrackPath: (track) async {
        final appDir = await getApplicationSupportDirectory();
        final trackDir = path.join(appDir.path, 'media/audios');
        final directory = Directory(trackDir);
        if (!directory.existsSync()) {
          await directory.create(
            recursive: true,
          );
        }
        final downloadDir = path.join(
          trackDir,
          track.hash,
        );
        return downloadDir;
      },
      registerListeners: (task, item, downloadDir) async {
        task.progress.addListener(() async {
          item.progress = task.progress.value;
          item.status = task.status.value;
          updateData(data);
          await methods.updateStoredQueue();
        });
        task.status.addListener(() async {
          item.status = task.status.value;
          updateData(data);
          if (item.status == DownloadStatus.completed) {
            item.track.url = downloadDir;
          }
          if (item.status != item.downloadDownloading &&
              item.status != item.downloadQueued) {
            if (!_gettingUrlLocked) {
              _gettingUrl--;
            }
          }
          await methods.updateStoredQueue();
        });
      },
      downloadFile: (saveDir, url) async {
        if (await Directory(saveDir).exists()) {
          final isValidFile = await methods.checkFileIntegrity(saveDir);
          if (!isValidFile) {
            await methods.deleteDownloadedFile(
              path: saveDir,
            );
            return await methods.downloadFile(saveDir, url);
          }
        } else {
          final task = await downloadManager.addDownload(url, saveDir);
          task?.status.addListener(() async {
            if (task.status.value == DownloadStatus.completed) {
              final file = File(saveDir);
              await methods.saveMd5(file);
            }
          });
          return task;
        }
        return null;
      },
      addDownload: (
        track, {
        position = 0,
      }) async {
        final currentItem = methods.getItem(track);
        if (currentItem != null) {
          updateData(
            data.copyWith(
              queue: data.queue
                ..remove(
                  currentItem,
                ),
            ),
          );
        }
        final downloadItem = DownloadingItem(
          track: track,
          progress: 0,
          status: DownloadStatus.queued,
        );
        updateData(
          data.copyWith(
            queue: data.queue
              ..add(
                downloadItem,
              ),
          ),
        );
        if (track.url == null) {
          while (_gettingUrl >= 5 || _gettingUrlLocked) {
            await Future.delayed(
              const Duration(
                seconds: 1,
              ),
            );
          }
          if (downloadItem.status == downloadItem.downloadCanceled) {
            return;
          }
          _gettingUrl++;
          final item =
              await playerController?.getPlayableItemUsecase.exec(track);
          if (item?.url == null) {
            throw Exception('Error adding download: URL is null');
          }
          track.url = item!.url;
        }
        final downloadDir = await methods.getTrackPath(track);
        final task = await methods.downloadFile(
          downloadDir,
          track.url!,
        );
        if (task == null) {
          throw Exception(
            'Error adding download: Cannot download ${track.url}',
          );
        }
        methods.registerListeners(
          task,
          downloadItem,
          downloadDir,
        );
        await methods.updateStoredQueue();
      },
    );
  }
}
