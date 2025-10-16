import 'dart:math';

import 'package:musily/core/domain/presenter/app_controller.dart';
import 'package:musily/core/domain/usecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/extensions/string.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/player/data/services/musily_player.dart';
import 'package:musily/features/player/domain/enums/musily_player_action.dart';
import 'package:musily/features/player/domain/enums/musily_player_state.dart';
import 'package:musily/features/player/domain/enums/musily_repeat_mode.dart';
import 'package:musily/features/player/domain/enums/player_mode.dart';
import 'package:musily/features/player/domain/usecases/get_smart_queue_usecase.dart';
import 'package:musily/features/player/presenter/controllers/player/player_data.dart';
import 'package:musily/features/player/presenter/controllers/player/player_methods.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';
import 'package:musily/features/track/domain/usecases/get_timed_lyrics_usecase.dart';
import 'package:musily/features/track/domain/usecases/get_track_lyrics_usecase.dart';

class PlayerController extends BaseController<PlayerData, PlayerMethods> {
  final _downloaderController = DownloaderController();
  final MusilyPlayer _musilyPlayer = MusilyPlayer();

  final GetPlayableItemUsecase getPlayableItemUsecase;
  final GetTrackLyricsUsecase getTrackLyricsUsecase;
  final GetTimedLyricsUsecase getTimedLyricsUsecase;
  final GetSmartQueueUsecase getSmartQueueUsecase;

  PlayerController({
    required this.getPlayableItemUsecase,
    required this.getSmartQueueUsecase,
    required this.getTrackLyricsUsecase,
    required this.getTimedLyricsUsecase,
  }) {
    updateData(
      data.copyWith(
        repeatMode: _musilyPlayer.getRepeatMode(),
        shuffleEnabled: _musilyPlayer.getShuffleMode(),
      ),
    );

    _downloaderController.setPlayerController(this);

    _musilyPlayer.setUriGetter((track) async {
      final offlineItem = _downloaderController.methods.getItem(track);
      if (offlineItem != null) {
        return Uri.parse(offlineItem.track.url!);
      }
      final item = await getPlayableItemUsecase.exec(track);
      return Uri.parse(item.url ?? '');
    });

    _musilyPlayer.setOnPlayerStateChanged((state) {
      updateData(
        data.copyWith(
          isPlaying: state == MusilyPlayerState.playing,
          mediaAvailable: state == MusilyPlayerState.playing ||
              state == MusilyPlayerState.paused,
          isBuffering: state == MusilyPlayerState.buffering,
        ),
      );
    });

    _musilyPlayer.setOnDurationChanged((newDuration) {
      if (data.currentPlayingItem != null) {
        data.currentPlayingItem!.duration = newDuration;
        updateData(data);
      }
    });

    _musilyPlayer.setOnPositionChanged((newPosition) {
      if (data.currentPlayingItem != null) {
        data.currentPlayingItem!.position = newPosition;
        if (data.autoSmartQueue) {
          final duration = data.currentPlayingItem!.duration;
          final position = data.currentPlayingItem!.position;
          if (duration > Duration.zero) {
            final percentage =
                position.inMilliseconds / duration.inMilliseconds;
            if (percentage >= 0.35 && !data.isPositionTriggered) {
              methods.getSmartQueue(customItems: [
                data.currentPlayingItem!,
              ]);
              data = data.copyWith(isPositionTriggered: true);
            }
            if (percentage < 0.35) {
              data = data.copyWith(isPositionTriggered: false);
            }
          }
        }
        updateData(data);
      }
    });

    _musilyPlayer.setOnAction((action) {
      if (action == MusilyPlayerAction.queueChanged) {
        updateData(
          data.copyWith(
            queue: _musilyPlayer.getQueue(),
          ),
        );
      }
    });

    _musilyPlayer.setOnShuffleChanged((enabled) {
      updateData(
        data.copyWith(
          shuffleEnabled: enabled,
        ),
      );
    });

    _musilyPlayer.setOnRepeatModeChanged((repeatMode) {
      updateData(
        data.copyWith(
          repeatMode: repeatMode,
        ),
      );
    });

    _musilyPlayer.setOnActiveTrackChange((track) async {
      updateData(
        data.copyWith(
          currentPlayingItem: track,
        ),
      );
      dispatchEvent(
        BaseControllerEvent<TrackEntity?>(
          id: 'playingItemUpdated',
          data: data.currentPlayingItem,
        ),
      );
      if (data.playerMode == PlayerMode.lyrics) {
        methods.getLyrics(data.currentPlayingItem?.id ?? '');
      }
      final downloadedQueue = DownloaderController().data.queue;
      if (!(data.currentPlayingItem?.lowResImg?.isUrl ?? false)) {
        final item = downloadedQueue
            .where((e) => e.track.hash == data.currentPlayingItem?.hash)
            .firstOrNull;
        if (item != null) {
          final playbleItem = await getPlayableItemUsecase.exec(item.track);
          item.track.highResImg = playbleItem.highResImg;
          item.track.lowResImg = playbleItem.lowResImg;
          data.currentPlayingItem!.lowResImg = playbleItem.lowResImg;
          data.currentPlayingItem!.highResImg = playbleItem.highResImg;
          DownloaderController().methods.updateStoredQueue();
        }
      }
    });
  }
  @override
  PlayerData defineData() {
    return PlayerData(
      playingId: '',
      queue: [],
      loadingTrackData: false,
      isPlaying: false,
      loadRequested: false,
      seeking: false,
      mediaAvailable: true,
      shuffleEnabled: false,
      repeatMode: MusilyRepeatMode.noRepeat,
      isBuffering: false,
      playerMode: PlayerMode.artwork,
      loadingLyrics: false,
      syncedLyrics: true,
      lyrics: Lyrics(
        trackId: '',
        lyrics: null,
        timedLyrics: null,
      ),
      tracksFromSmartQueue: [],
      autoSmartQueue: false,
      loadingSmartQueue: false,
      addingToFavorites: false,
      showDownloadManager: false,
      isPositionTriggered: false,
    );
  }

  @override
  PlayerMethods defineMethods() {
    return PlayerMethods(
      toggleShowDownloadManager: () {
        updateData(
          data.copyWith(
            showDownloadManager: !data.showDownloadManager,
          ),
        );
      },
      toggleSmartQueue: () {
        if (data.tracksFromSmartQueue.isEmpty) {
          updateData(
            data.copyWith(
              autoSmartQueue: !data.autoSmartQueue,
            ),
          );
        } else {
          updateData(
            data.copyWith(
              autoSmartQueue: false,
            ),
          );
          if (data.tracksFromSmartQueue
              .contains(data.currentPlayingItem?.hash)) {
            updateData(
              data.copyWith(
                currentPlayingItem: data.queue.firstOrNull,
              ),
            );
            if (data.queue.isNotEmpty) {
              _musilyPlayer.skipToTrack(0);
            }
          }
          _musilyPlayer.setQueue(
            [
              ...data.queue
                ..removeWhere(
                  (item) => data.tracksFromSmartQueue.contains(
                    item.hash,
                  ),
                ),
            ],
          );
          updateData(
            data.copyWith(
              tracksFromSmartQueue: [],
            ),
          );
        }
      },
      getSmartQueue: ({customItems}) async {
        updateData(
          data.copyWith(
            loadingSmartQueue: true,
          ),
        );
        if (customItems?.isNotEmpty ?? false) {
          final smartItems = await getSmartQueueUsecase.exec(customItems ?? []);
          if (smartItems.isEmpty) {
            updateData(
              data.copyWith(
                loadingSmartQueue: false,
              ),
            );
            return;
          }
          smartItems.removeWhere(
            (item) => data.queue.map((track) => track.hash).contains(item.hash),
          );
          final List<TrackEntity> queueClone = List.from(data.queue);
          final random = Random();
          for (final item in smartItems) {
            late final indexToInsert;

            if (queueClone.length - 1 > 0) {
              indexToInsert = random.nextInt(queueClone.length - 1);
            } else {
              indexToInsert = 0;
            }

            queueClone.insert(
              max(indexToInsert, 0),
              item,
            );
          }
          _musilyPlayer.setQueue(queueClone);
          updateData(
            data.copyWith(
              loadingSmartQueue: false,
              tracksFromSmartQueue: data.tracksFromSmartQueue
                ..addAll(
                  smartItems.map(
                    (item) => item.hash,
                  ),
                ),
            ),
          );
          return;
        }

        final smartQueue = await getSmartQueueUsecase.exec(
          data.queue,
        );
        final tracksFromSmartQueue = smartQueue.where(
          (track) => track.fromSmartQueue,
        );
        updateData(
          data.copyWith(
            tracksFromSmartQueue: [
              ...tracksFromSmartQueue.map(
                (track) => track.hash,
              )
            ],
          ),
        );
        _musilyPlayer.setQueue(smartQueue);
        updateData(
          data.copyWith(
            loadingSmartQueue: false,
          ),
        );
      },
      toggleSyncedLyrics: () {
        updateData(
          data.copyWith(
            syncedLyrics: !data.syncedLyrics,
          ),
        );
      },
      getLyrics: (trackId) async {
        if (data.loadingLyrics) {
          return null;
        }
        if (data.lyrics.trackId == trackId) {
          return data.lyrics.lyrics;
        }
        updateData(
          data.copyWith(
            loadingLyrics: true,
          ),
        );
        final lyrics = await getTrackLyricsUsecase.exec(trackId);
        final timedLyrics = await getTimedLyricsUsecase.exec(trackId);
        updateData(
          data.copyWith(
            lyrics: Lyrics(
              trackId: trackId,
              lyrics: lyrics,
              timedLyrics: timedLyrics,
            ),
            loadingLyrics: false,
          ),
        );
        return data.lyrics.lyrics;
      },
      setPlayerMode: (mode) {
        updateData(
          data.copyWith(
            playerMode: mode,
            showDownloadManager: false,
          ),
        );
        if (mode == PlayerMode.lyrics) {
          methods.getLyrics(data.currentPlayingItem?.id ?? '');
        }
      },
      play: () async {
        await _musilyPlayer.playPlaylist();
      },
      resume: () async {
        await _musilyPlayer.play();
      },
      pause: () async {
        await _musilyPlayer.pause();
      },
      toggleFavorite: () async {
        return;
      },
      seek: (duration) async {
        updateData(
          data.copyWith(
            seeking: true,
          ),
        );
        await _musilyPlayer.seek(duration);
        updateData(
          data.copyWith(
            seeking: false,
          ),
        );
      },
      loadAndPlay: (track, playingId) async {
        if (data.loadRequested) {
          if (track.id != data.currentPlayingItem?.id) {
            updateData(
              data.copyWith(
                loadRequested: false,
                playingId: playingId,
                tracksFromSmartQueue: [],
              ),
            );
            await methods.loadAndPlay(track, playingId);
          }
          return;
        }
        updateData(
          data.copyWith(
            loadingTrackData: true,
            loadRequested: true,
          ),
        );
        updateData(
          data.copyWith(
            loadingTrackData: false,
            playingId: playingId,
            tracksFromSmartQueue: [],
          ),
        );
        await _musilyPlayer.playTrack(track);
      },
      toggleShuffle: () async {
        await _musilyPlayer.toggleShuffleMode(
          !data.shuffleEnabled,
        );
      },
      toggleRepeatState: () async {
        switch (_musilyPlayer.getRepeatMode()) {
          case MusilyRepeatMode.repeat:
            await _musilyPlayer.toggleRepeatMode(MusilyRepeatMode.repeatOne);
            break;
          case MusilyRepeatMode.noRepeat:
            await _musilyPlayer.toggleRepeatMode(MusilyRepeatMode.repeat);
            break;
          case MusilyRepeatMode.repeatOne:
            await _musilyPlayer.toggleRepeatMode(MusilyRepeatMode.noRepeat);
            break;
        }
      },
      nextInQueue: () async {
        if (data.currentPlayingItem != null) {
          await _musilyPlayer.skipToNext();
        }
      },
      previousInQueue: () async {
        if (data.currentPlayingItem != null) {
          final currentPlayingIndex = data.queue.indexOf(
            data.queue.firstWhere(
              (element) => element.id == data.currentPlayingItem!.id,
            ),
          );
          if (currentPlayingIndex > 0) {
            await _musilyPlayer.skipToPrevious();
          }
        }
      },
      addToQueue: (items) async {
        final currentItemsHashs = data.queue.map((element) => element.hash);
        final filteredItems = items.where(
          (element) => !currentItemsHashs.contains(element.hash),
        );
        for (final item in filteredItems) {
          await _musilyPlayer.addToQueue(item);
        }
        if (data.queue.length == 1 || data.currentPlayingItem == null) {
          await _musilyPlayer.playPlaylist();
        }
      },
      queueJumpTo: (int index) async {
        if (data.currentPlayingItem != null) {
          if (data.currentPlayingItem!.id != data.queue[index].id) {
            await _musilyPlayer.skipToTrack(index);
          }
        }
      },
      reorderQueue: (int newIndex, int oldIndex) async {
        if (newIndex > oldIndex) {
          newIndex -= 1;
        }
        List<TrackEntity> queueCopy = List.from(_musilyPlayer.getQueue());
        queueCopy = queueCopy
          ..insert(
            newIndex,
            queueCopy.removeAt(oldIndex),
          );
        _musilyPlayer.setQueue(queueCopy);
      },
      playPlaylist: (
        List<TrackEntity> items,
        String playingId, {
        int startFrom = 1,
      }) async {
        if (items.isEmpty) {
          return;
        }
        await _musilyPlayer.stop();
        await _musilyPlayer.setQueue(items);
        _musilyPlayer.skipToTrack(startFrom);
        if (data.shuffleEnabled) {
          if (playingId != data.playingId) {
            await methods.toggleShuffle();
            await methods.toggleShuffle();
          }
        }
        updateData(
          data.copyWith(
            playingId: playingId,
            tracksFromSmartQueue: [],
          ),
        );
      },
    );
  }
}
