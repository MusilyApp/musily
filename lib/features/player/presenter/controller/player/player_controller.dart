import 'package:musily/core/domain/presenter/app_controller.dart';
import 'package:musily/core/domain/uasecases/get_playable_item_usecase.dart';
import 'package:musily/features/player/domain/usecases/get_smart_queue_usecase.dart';
import 'package:musily/features/player/presenter/controller/player/player_data.dart';
import 'package:musily/features/player/presenter/controller/player/player_methods.dart';
import 'package:musily/features/track/data/models/track_model.dart';
import 'package:musily/features/track/domain/usecases/get_track_lyrics_usecase.dart';
import 'package:musily_player/musily_player.dart';

class PlayerController extends BaseController<PlayerData, PlayerMethods> {
  late final MusilyPlayer _musilyPlayer;
  final GetTrackLyricsUsecase getTrackLyricsUsecase;
  final GetSmartQueueUsecase getSmartQueueUsecase;

  PlayerController({
    required MusilyPlayer musilyPlayer,
    required GetPlayableItemUsecase getPlayableItemUsecase,
    required this.getTrackLyricsUsecase,
    required this.getSmartQueueUsecase,
  }) {
    _musilyPlayer = musilyPlayer;

    updateData(
      data.copyWith(
        repeatMode: _musilyPlayer.getRepeatMode(),
        shuffleEnabled: _musilyPlayer.getShuffleMode(),
      ),
    );

    _musilyPlayer.setUriGetter((track) async {
      final trackItem = await getPlayableItemUsecase.exec(
        MusilyTrack(
          id: track.id,
          title: track.title ?? '',
          hash: track.hash,
          ytId: track.ytId,
          url: track.url,
          artist: MusilyArtist(
            id: '',
            name: track.artist?.name ?? '',
          ),
          lowResImg: track.lowResImg,
          highResImg: track.highResImg,
        ),
      );
      return Uri.parse(trackItem.filePath ?? trackItem.url ?? '');
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

    _musilyPlayer.setOnActiveTrackChange((track) {
      updateData(
        data.copyWith(
          currentPlayingItem: track,
        ),
      );
      dispatchEvent(
        BaseControllerEvent<MusilyTrack?>(
          id: 'playingItemUpdated',
          data: data.currentPlayingItem,
        ),
      );
      if (data.showLyrics) {
        methods.getLyrics(data.currentPlayingItem?.id ?? '');
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
      showLyrics: false,
      loadingLyrics: false,
      syncedLyrics: true,
      lyrics: Lyrics(
        trackId: '',
        lyrics: null,
      ),
      tracksFromSmartQueue: [],
      loadingSmartQueue: false,
    );
  }

  @override
  PlayerMethods defineMethods() {
    return PlayerMethods(
      toggleSmartQueue: () async {
        if (data.tracksFromSmartQueue.isEmpty) {
          methods.getSmartQueue();
        } else {
          if (data.tracksFromSmartQueue
              .contains(data.currentPlayingItem?.hash)) {
            await _musilyPlayer.skipToTrack(0);
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
      getSmartQueue: () async {
        updateData(
          data.copyWith(
            loadingSmartQueue: true,
          ),
        );
        final smartQueue = await getSmartQueueUsecase.exec(
          [
            ...data.queue.map(
              (track) => TrackModel.fromMusilyTrack(track),
            ),
          ],
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
        _musilyPlayer.setQueue(
          [
            ...smartQueue.map(
              (track) => TrackModel.toMusilyTrack(track),
            ),
          ],
        );
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
        updateData(
          data.copyWith(
            lyrics: Lyrics(
              trackId: trackId,
              lyrics: lyrics,
            ),
            loadingLyrics: false,
          ),
        );
        return data.lyrics.lyrics;
      },
      toggleLyrics: (id) {
        updateData(
          data.copyWith(
            showLyrics: !data.showLyrics,
          ),
        );
        methods.getLyrics(id);
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
        List<MusilyTrack> queueCopy = List.from(_musilyPlayer.getQueue());
        queueCopy = queueCopy
          ..insert(
            newIndex,
            queueCopy.removeAt(oldIndex),
          );
        _musilyPlayer.setQueue(queueCopy);
      },
      playPlaylist: (
        List<MusilyTrack> items,
        String playingId, {
        int startFrom = 1,
      }) async {
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
          ),
        );
      },
    );
  }
}
