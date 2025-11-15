import 'dart:math';
import 'dart:async';

import 'package:musily/core/domain/presenter/app_controller.dart';
import 'package:musily/core/domain/usecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/extensions/string.dart';
import 'package:musily/features/_library_module/domain/usecases/update_track_in_playlist_usecase.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/player/data/services/musily_player.dart';
import 'package:musily/features/player/data/services/player_persistence_service.dart';
import 'package:musily/features/player/domain/enums/musily_player_action.dart';
import 'package:musily/features/player/domain/enums/musily_player_state.dart';
import 'package:musily/features/player/domain/enums/musily_repeat_mode.dart';
import 'package:musily/features/player/domain/enums/player_mode.dart';
import 'package:musily/features/player/domain/usecases/get_smart_queue_usecase.dart';
import 'package:musily/features/player/presenter/controllers/player/player_data.dart';
import 'package:musily/features/player/presenter/controllers/player/player_methods.dart';
import 'package:musily/features/settings/presenter/controllers/settings/settings_controller.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';
import 'package:musily/features/track/domain/usecases/get_timed_lyrics_usecase.dart';
import 'package:musily/features/track/domain/usecases/get_track_lyrics_usecase.dart';

class PlayerController extends BaseController<PlayerData, PlayerMethods> {
  final _downloaderController = DownloaderController();
  final MusilyPlayer _musilyPlayer = MusilyPlayer();
  final PlayerPersistenceService _playerPersistenceService =
      PlayerPersistenceService();

  final GetPlayableItemUsecase getPlayableItemUsecase;
  final GetTrackLyricsUsecase getTrackLyricsUsecase;
  final GetTimedLyricsUsecase getTimedLyricsUsecase;
  final GetSmartQueueUsecase getSmartQueueUsecase;
  final UpdateTrackInPlaylistUsecase updateTrackInPlaylistUsecase;
  final SettingsController settingsController;

  PlayerController({
    required this.getPlayableItemUsecase,
    required this.getSmartQueueUsecase,
    required this.getTrackLyricsUsecase,
    required this.getTimedLyricsUsecase,
    required this.updateTrackInPlaylistUsecase,
    required this.settingsController,
  }) {
    updateData(
      data.copyWith(
        repeatMode: _musilyPlayer.getRepeatMode(),
        shuffleEnabled: _musilyPlayer.getShuffleMode(),
        volume: _musilyPlayer.volume,
      ),
    );

    _downloaderController.setPlayerController(this);

    _musilyPlayer.volumeStream.listen((volume) {
      updateData(data.copyWith(volume: volume));
    });

    _musilyPlayer.setUriGetter((track) async {
      final offlineItem = _downloaderController.methods.getItem(track);

      if (offlineItem != null) {
        final cachedUrl = offlineItem.track.url;
        if (cachedUrl != null && cachedUrl.isNotEmpty) {
          return Uri.parse(cachedUrl);
        }

        final fetchedItem = await getPlayableItemUsecase.exec(track);
        final fetchedUrl = fetchedItem.url;

        if (fetchedUrl != null && fetchedUrl.isNotEmpty) {
          offlineItem.track.url = fetchedUrl;
          await _downloaderController.methods.updateStoredQueue();
          return Uri.parse(fetchedUrl);
        }

        return Uri.parse('');
      }

      final item = await getPlayableItemUsecase.exec(track);
      return Uri.parse(item.url ?? '');
    });

    _musilyPlayer.setOnPlayerStateChanged((state) {
      updateData(
        data.copyWith(
          isPlaying: state == MusilyPlayerState.playing,
          mediaAvailable: data.currentPlayingItem?.url != null,
          isBuffering: state == MusilyPlayerState.buffering,
        ),
      );
    });

    _musilyPlayer.setOnDurationChanged((newDuration) {
      if (data.currentPlayingItem != null) {
        if (data.currentPlayingItem!.duration != newDuration) {
          updateTrackInPlaylistUsecase.exec(
            data.playingId,
            data.currentPlayingItem!.id,
            data.currentPlayingItem!.copyWith(duration: newDuration),
          );
        }
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
              methods.getSmartQueue(customItems: [data.currentPlayingItem!]);
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
        updateData(data.copyWith(queue: _musilyPlayer.getQueue()));
      }
    });

    _musilyPlayer.setOnShuffleChanged((enabled) {
      updateData(data.copyWith(shuffleEnabled: enabled));
    });

    _musilyPlayer.setOnRepeatModeChanged((repeatMode) {
      updateData(data.copyWith(repeatMode: repeatMode));
    });

    _musilyPlayer.setOnActiveTrackChange((track) async {
      if (track != null) {
        settingsController.methods
            .updatePlayerAccentColor(track.highResImg ?? '');
      }
      updateData(data.copyWith(currentPlayingItem: track));
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

    unawaited(_hydrateFromPersistedState());
  }

  Future<void> _hydrateFromPersistedState() async {
    final persistedState = await _playerPersistenceService.loadState();
    if (persistedState == null) {
      return;
    }

    final persistedTrack = _resolvePersistedTrack(persistedState);

    updateData(
      data.copyWith(
        queue: persistedState.queue.isNotEmpty
            ? List<TrackEntity>.from(persistedState.queue)
            : data.queue,
        currentPlayingItem: persistedTrack ?? data.currentPlayingItem,
        shuffleEnabled: persistedState.shuffleEnabled,
        repeatMode: persistedState.repeatMode,
      ),
    );
  }

  TrackEntity? _resolvePersistedTrack(PlayerPersistedState state) {
    final id = state.currentTrackId;
    final hash = state.currentTrackHash;

    for (final track in state.queue) {
      final matchesId = id != null && id.isNotEmpty && track.id == id;
      final matchesHash = hash != null && hash.isNotEmpty && track.hash == hash;
      if (matchesId || matchesHash) {
        return track;
      }
    }
    return state.currentTrack;
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
      mediaAvailable: false,
      shuffleEnabled: false,
      repeatMode: MusilyRepeatMode.noRepeat,
      isBuffering: false,
      playerMode: PlayerMode.artwork,
      loadingLyrics: false,
      syncedLyrics: true,
      lyrics: Lyrics(trackId: '', lyrics: null, timedLyrics: null),
      tracksFromSmartQueue: [],
      autoSmartQueue: false,
      loadingSmartQueue: false,
      addingToFavorites: false,
      showDownloadManager: false,
      isPositionTriggered: false,
      volume: 1.0,
      sleepTimerActive: false,
    );
  }

  Timer? _sleepTimer;

  @override
  PlayerMethods defineMethods() {
    return PlayerMethods(
      toggleShowDownloadManager: () {
        updateData(
          data.copyWith(showDownloadManager: !data.showDownloadManager),
        );
      },
      toggleSmartQueue: () {
        if (data.tracksFromSmartQueue.isEmpty) {
          updateData(data.copyWith(autoSmartQueue: !data.autoSmartQueue));
        } else {
          updateData(data.copyWith(autoSmartQueue: false));
          if (data.tracksFromSmartQueue.contains(
            data.currentPlayingItem?.hash,
          )) {
            updateData(
              data.copyWith(currentPlayingItem: data.queue.firstOrNull),
            );
            if (data.queue.isNotEmpty) {
              _musilyPlayer.skipToTrack(data.queue.first.id);
            }
          }
          _musilyPlayer.setQueue([
            ...data.queue
              ..removeWhere(
                (item) => data.tracksFromSmartQueue.contains(item.hash),
              ),
          ]);
          updateData(data.copyWith(tracksFromSmartQueue: []));
        }
      },
      getSmartQueue: ({customItems}) async {
        updateData(data.copyWith(loadingSmartQueue: true));
        if (customItems?.isNotEmpty ?? false) {
          final smartItems = await getSmartQueueUsecase.exec(customItems ?? []);
          if (smartItems.isEmpty) {
            updateData(data.copyWith(loadingSmartQueue: false));
            return;
          }
          smartItems.removeWhere(
            (item) => data.queue.map((track) => track.hash).contains(item.hash),
          );
          final List<TrackEntity> queueClone = List.from(data.queue);
          final random = Random();
          for (final item in smartItems) {
            late final int indexToInsert;

            if (queueClone.length - 1 > 0) {
              indexToInsert = random.nextInt(queueClone.length - 1);
            } else {
              indexToInsert = 0;
            }

            queueClone.insert(max(indexToInsert, 0), item);
          }
          _musilyPlayer.setQueue(queueClone);
          updateData(
            data.copyWith(
              loadingSmartQueue: false,
              tracksFromSmartQueue: data.tracksFromSmartQueue
                ..addAll(smartItems.map((item) => item.hash)),
            ),
          );
          return;
        }

        final smartQueue = await getSmartQueueUsecase.exec(data.queue);
        final tracksFromSmartQueue = smartQueue.where(
          (track) => track.fromSmartQueue,
        );
        updateData(
          data.copyWith(
            tracksFromSmartQueue: [
              ...tracksFromSmartQueue.map((track) => track.hash),
            ],
          ),
        );
        _musilyPlayer.setQueue(smartQueue);
        updateData(data.copyWith(loadingSmartQueue: false));
      },
      toggleSyncedLyrics: () {
        updateData(data.copyWith(syncedLyrics: !data.syncedLyrics));
      },
      getLyrics: (trackId) async {
        if (data.loadingLyrics) {
          return null;
        }
        if (data.lyrics.trackId == trackId) {
          return data.lyrics.lyrics;
        }
        updateData(data.copyWith(loadingLyrics: true));
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
        updateData(data.copyWith(playerMode: mode, showDownloadManager: false));
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
        updateData(data.copyWith(seeking: true));
        await _musilyPlayer.seek(duration);
        updateData(data.copyWith(seeking: false));
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
        updateData(data.copyWith(loadingTrackData: true, loadRequested: true));
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
        await _musilyPlayer.toggleShuffleMode(!data.shuffleEnabled);
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
        if (data.queue.isNotEmpty && data.queue.first.isLocal) {
          await _musilyPlayer.stop();
          await _musilyPlayer.setQueue([]);
          data = data.copyWith(
            queue: [],
            currentPlayingItem: null,
            playingId: '',
            tracksFromSmartQueue: [],
          );
          updateData(data);
        }
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
      queueJumpTo: (String trackId) async {
        if (data.currentPlayingItem != null) {
          if (data.currentPlayingItem!.id != trackId) {
            await _musilyPlayer.skipToTrack(trackId);
          }
        }
      },
      reorderQueue: (int newIndex, int oldIndex) async {
        _musilyPlayer.reorderQueue(newIndex, oldIndex);
      },
      playPlaylist: (
        List<TrackEntity> items,
        String playingId, {
        String startFromTrackId = '',
      }) async {
        if (items.isEmpty) {
          return;
        }
        await _musilyPlayer.stop();
        await _musilyPlayer.setQueue(items);
        _musilyPlayer.skipToTrack(startFromTrackId);
        if (data.shuffleEnabled) {
          if (playingId != data.playingId) {
            await methods.toggleShuffle();
            await methods.toggleShuffle();
          }
        }
        updateData(
          data.copyWith(playingId: playingId, tracksFromSmartQueue: []),
        );
      },
      setVolume: (volume) {
        _musilyPlayer.setVolume(volume);
        updateData(data.copyWith(volume: volume));
      },
      getVolumeStream: () {
        return _musilyPlayer.volumeStream;
      },
      setSleepTimer: (duration) {
        _sleepTimer?.cancel();
        final endTime = DateTime.now().add(duration);
        updateData(data.copyWith(
          sleepTimerActive: true,
          sleepTimerDuration: duration,
          sleepTimerEndTime: endTime,
        ));

        _sleepTimer = Timer(duration, () async {
          await methods.pause();
          updateData(data.copyWith(
            sleepTimerActive: false,
            clearSleepTimer: true,
          ));
        });
      },
      cancelSleepTimer: () {
        _sleepTimer?.cancel();
        _sleepTimer = null;
        updateData(data.copyWith(
          sleepTimerActive: false,
          clearSleepTimer: true,
        ));
      },
    );
  }

  @override
  void dispose() {
    _sleepTimer?.cancel();
    _sleepTimer = null;
    super.dispose();
  }
}
