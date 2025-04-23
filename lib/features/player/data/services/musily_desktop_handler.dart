/*
 *     Copyright (C) 2024 Valeri Gokadze
 *
 *     Musify is free software: you can redistribute it and/or modify
 *     it under the terms of the GNU General Public License as published by
 *     the Free Software Foundation, either version 3 of the License, or
 *     (at your option) any later version.
 *
 *     Musify is distributed in the hope that it will be useful,
 *     but WITHOUT ANY WARRANTY; without even the implied warranty of
 *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *     GNU General Public License for more details.
 *
 *     You should have received a copy of the GNU General Public License
 *     along with this program.  If not, see <https://www.gnu.org/licenses/>.
 *
 *
 *     For more information about Musify, including how to contribute,
 *     please visit: https://github.com/gokadzev/Musify
 */

import 'dart:async';
import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musily/core/data/services/window_service.dart';
import 'package:musily/features/player/data/mappers/media_mapper.dart';
import 'package:musily/features/player/data/services/musily_audio_handler.dart';
import 'package:musily/features/player/domain/enums/musily_player_action.dart';
import 'package:musily/features/player/domain/enums/musily_player_state.dart';
import 'package:musily/features/player/domain/enums/musily_repeat_mode.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';
import 'package:queue/queue.dart';

class MusilyDesktopHandler extends BaseAudioHandler
    implements MusilyAudioHandler {
  MusilyDesktopHandler() {
    _setupEventSubscriptions();
    _updatePlaybackState();
  }

  AudioPlayer audioPlayer = AudioPlayer();
  List<TrackEntity> shuffledQueue = [];
  List<TrackEntity> mediaQueue = [];
  TrackEntity? activeTrack;
  bool shuffleEnabled = false;
  bool loadingTrackAudio = false;
  MusilyRepeatMode repeatMode = MusilyRepeatMode.noRepeat;
  final taskQueue = Queue(
    delay: const Duration(
      microseconds: 10,
    ),
  );

  late StreamSubscription<PlaybackEvent> _playbackEventSubscription;
  late StreamSubscription<Duration?> _durationSubscription;
  late StreamSubscription<int?> _currentIndexSubscription;
  late StreamSubscription<SequenceState?> _sequenceStateSubscription;
  late StreamSubscription<Duration?> _positionChangeSubscription;

  final processingStateMap = {
    ProcessingState.idle: AudioProcessingState.idle,
    ProcessingState.loading: AudioProcessingState.loading,
    ProcessingState.buffering: AudioProcessingState.buffering,
    ProcessingState.ready: AudioProcessingState.ready,
    ProcessingState.completed: AudioProcessingState.completed,
  };

  final repeatModeMap = {
    LoopMode.off: AudioServiceRepeatMode.none,
    LoopMode.one: AudioServiceRepeatMode.one,
    LoopMode.all: AudioServiceRepeatMode.all,
  };

  void Function(
    MusilyPlayerState playerState,
  )? _onPlayerStateChanged;
  void Function(Duration duration)? _onDurationChanged;
  void Function(Duration position)? _onPositionChanged;
  void Function()? _onPlayerComplete;

  void Function(MusilyPlayerAction playerAction)? _onAction;
  void Function(bool enabled)? _onShuffleChanged;
  void Function(MusilyRepeatMode repeatMode)? _onRepeatModeChanged;
  void Function(TrackEntity? track)? _onActiveTrackChanged;

  Future<Uri> Function(TrackEntity track)? _uriGetter;

  @override
  void setOnPlayerStateChanged(
    Function(
      MusilyPlayerState playerState,
    ) callback,
  ) {
    _onPlayerStateChanged = callback;
  }

  @override
  void setOnDurationChanged(
    Function(Duration duration) callback,
  ) {
    _onDurationChanged = callback;
  }

  @override
  void setOnPositionChanged(
    Function(Duration position) callback,
  ) {
    _onPositionChanged = callback;
  }

  @override
  void setOnPlayerComplete(
    Function() callback,
  ) {
    _onPlayerComplete = callback;
  }

  @override
  void setOnAction(Function(MusilyPlayerAction playerAction) callback) {
    _onAction = callback;
  }

  @override
  void setOnShuffleChanged(Function(bool enabled) callback) {
    _onShuffleChanged = callback;
  }

  @override
  void setOnRepeatModeChanged(Function(MusilyRepeatMode repeatMode) callback) {
    _onRepeatModeChanged = callback;
  }

  @override
  void setOnActiveTrackChange(Function(TrackEntity? track) callback) {
    _onActiveTrackChanged = callback;
  }

  void setVolume(double volume) async {
    await audioPlayer.setVolume(volume);
  }

  double get volume => audioPlayer.volume;

  Future<void> _handlePlaybackEvent(PlaybackEvent event) async {
    try {
      shuffleEnabled = audioPlayer.shuffleModeEnabled;
      if (activeTrack != null) {
        WindowService.setWindowTitle(
          '${activeTrack!.title} (${activeTrack!.artist.name}) - Musily',
          defaultTitle: !audioPlayer.playing,
        );
      }
      if (event.processingState == ProcessingState.completed) {
        switch (repeatMode) {
          case MusilyRepeatMode.noRepeat:
            if (hasNext) {
              if (activeTrack == mediaQueue.last) {
                await seek(Duration.zero);
                return;
              }
              await skipToNext();
            } else if (activeTrack != null) {
              await skipToTrack(0);
              if (audioPlayer.playing) {
                await pause();
              }
              if (audioPlayer.duration != Duration.zero) {
                await seek(Duration.zero);
              }
            }
            break;
          case MusilyRepeatMode.repeatOne:
            if (activeTrack != null) {
              await playTrack(activeTrack!);
            }
            if (!audioPlayer.playing) {
              await play();
            }
            break;
          case MusilyRepeatMode.repeat:
            await skipToNext();
            break;
        }
      }
      _updatePlaybackState();
    } catch (e, stackTrace) {
      log(
        '[Error handling playback event]',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  void _handleDurationChange(Duration? duration) {
    try {
      final index = audioPlayer.currentIndex;
      if (index != null && queue.value.isNotEmpty) {
        final newQueue = List<MediaItem>.from(queue.value);
        final oldMediaItem = newQueue[index];
        final newMediaItem = oldMediaItem.copyWith(duration: duration);
        newQueue[index] = newMediaItem;
        queue.add(newQueue);
        mediaItem.add(newMediaItem);
      }
    } catch (e, stackTrace) {
      log(
        '[Error handling duration change]',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  void _handleCurrentSongIndexChanged(int? index) {
    try {
      if (index != null && queue.value.isNotEmpty) {
        final playlist = queue.value;
        mediaItem.add(playlist[index]);
      }
    } catch (e, stackTrace) {
      log(
        '[Error handling current song index change]',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  void _handleSequenceStateChange(SequenceState? sequenceState) {
    try {
      final sequence = sequenceState?.effectiveSequence;
      if (sequence != null && sequence.isNotEmpty) {
        final items =
            sequence.map((source) => source.tag as MediaItem).toList();
        queue.add(items);
      }
    } catch (e, stackTrace) {
      log(
        '[Error handling sequence state change]',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  void _setupEventSubscriptions() {
    _playbackEventSubscription = audioPlayer.playbackEventStream.listen(
      (playbackEvent) async {
        await _handlePlaybackEvent(playbackEvent);
        if (_onPlayerStateChanged != null) {
          MusilyPlayerState playerState = MusilyPlayerState.disposed;
          switch (playbackEvent.processingState) {
            case ProcessingState.idle:
              playerState = MusilyPlayerState.stopped;
              break;
            case ProcessingState.loading:
              playerState = MusilyPlayerState.paused;
            case ProcessingState.buffering:
              playerState = MusilyPlayerState.buffering;
              break;
            case ProcessingState.ready:
              playerState = audioPlayer.playing
                  ? MusilyPlayerState.playing
                  : MusilyPlayerState.paused;
              break;
            case ProcessingState.completed:
              playerState = MusilyPlayerState.completed;
              break;
          }
          _onPlayerStateChanged!.call(playerState);
          if (playerState == MusilyPlayerState.completed) {
            _onPlayerComplete?.call();
          }
        }
      },
    );
    _durationSubscription = audioPlayer.durationStream.listen(
      (duration) {
        if (loadingTrackAudio) {
          return;
        }
        _handleDurationChange(duration);
        _onDurationChanged?.call(duration ?? Duration.zero);
      },
    );
    _currentIndexSubscription =
        audioPlayer.currentIndexStream.listen(_handleCurrentSongIndexChanged);
    _sequenceStateSubscription =
        audioPlayer.sequenceStateStream.listen(_handleSequenceStateChange);
    _positionChangeSubscription = audioPlayer.positionStream.listen(
      (duration) {
        _onPositionChanged?.call(duration);
      },
    );
  }

  void _updatePlaybackState() {
    playbackState.add(
      playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          if (audioPlayer.playing) MediaControl.pause else MediaControl.play,
          MediaControl.skipToNext
        ],
        systemActions: const {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
        },
        androidCompactActionIndices: const [0, 1, 2],
        processingState: processingStateMap[audioPlayer.processingState]!,
        repeatMode: repeatModeMap[audioPlayer.loopMode]!,
        shuffleMode: audioPlayer.shuffleModeEnabled
            ? AudioServiceShuffleMode.all
            : AudioServiceShuffleMode.none,
        playing: audioPlayer.playing,
        updatePosition: audioPlayer.position,
        bufferedPosition: audioPlayer.bufferedPosition,
        speed: audioPlayer.speed,
        queueIndex: audioPlayer.currentIndex ?? 0,
      ),
    );
  }

  @override
  Future<void> onTaskRemoved() async {
    await audioPlayer.stop().then((_) => audioPlayer.dispose());

    await _playbackEventSubscription.cancel();
    await _durationSubscription.cancel();
    await _currentIndexSubscription.cancel();
    await _sequenceStateSubscription.cancel();
    await _positionChangeSubscription.cancel();
    taskQueue.dispose();

    await super.onTaskRemoved();
  }

  int activeTrackIndex() {
    // ignore: no_leading_underscores_for_local_identifiers
    late final List<TrackEntity> _mediaQueue;
    if (shuffleEnabled) {
      _mediaQueue = shuffledQueue;
    } else {
      _mediaQueue = mediaQueue;
    }
    final filteredTrack = _mediaQueue.where(
      (element) => element.id == activeTrack?.id,
    );
    if (filteredTrack.isNotEmpty) {
      return _mediaQueue.indexOf(filteredTrack.first);
    }
    return -1;
  }

  bool get hasNext => activeTrackIndex() + 1 < mediaQueue.length;

  bool get hasPrevious => activeTrackIndex() > 0;

  @override
  Future<void> play() async {
    await audioPlayer.play();
    _onAction?.call(MusilyPlayerAction.play);
  }

  @override
  Future<void> playPlaylist() async {
    if (mediaQueue.isNotEmpty) {
      await playTrack(mediaQueue.first);
    }
  }

  @override
  Future<void> pause() async {
    await audioPlayer.pause();
    _onAction?.call(MusilyPlayerAction.pause);
  }

  @override
  Future<void> stop() async {
    activeTrack = null;
    _onActiveTrackChanged?.call(null);
    await audioPlayer.stop();
    _onAction?.call(MusilyPlayerAction.stop);
  }

  @override
  Future<void> seek(Duration position) async {
    await audioPlayer.seek(position);
  }

  @override
  Future<void> fastForward() => seek(
        Duration(
          seconds: audioPlayer.position.inSeconds + 15,
        ),
      );

  @override
  Future<void> rewind() => seek(
        Duration(
          seconds: audioPlayer.position.inSeconds - 15,
        ),
      );

  @override
  Future<void> playTrack(TrackEntity track) async {
    try {
      late String url;
      if (track.url != null) {
        url = track.url!;
      } else {
        url = '';
      }
      // ignore: no_leading_underscores_for_local_identifiers
      late List<TrackEntity> _mediaQueue;
      if (shuffleEnabled) {
        _mediaQueue = shuffledQueue;
      } else {
        _mediaQueue = mediaQueue;
      }
      activeTrack = track;
      activeTrack?.position = Duration.zero;
      activeTrack?.duration = Duration.zero;
      loadingTrackAudio = true;
      _onActiveTrackChanged?.call(track);
      if (_mediaQueue.where((element) => element.id == track.id).isEmpty) {
        _mediaQueue = [track];
        mediaQueue = [track];
        shuffledQueue = [track];
        updateMediaItemQueue();
        _onAction?.call(MusilyPlayerAction.queueChanged);
      }
      if (url.isEmpty) {
        if (audioPlayer.playing) {
          await audioPlayer.stop();
        }
        if (_uriGetter != null) {
          final uri = await _uriGetter!.call(track);
          if (audioPlayer.playing) {
            await audioPlayer.stop();
          }
          url = uri.toString();
          track.url = uri.toString();
          _onActiveTrackChanged?.call(track);
          if (url.isEmpty) {
            return;
          }
        }
      }

      loadingTrackAudio = false;

      if (activeTrack?.id != track.id) {
        return;
      }

      final audioSource = await buildAudioSource(track, url);
      final queue = ConcatenatingAudioSource(
        children: [audioSource],
      );
      await audioPlayer.setAudioSource(queue, preload: false);
      await audioPlayer.play();
    } catch (e, stackTrace) {
      log(
        '[Error playing song]',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  Future<AudioSource> buildAudioSource(
    TrackEntity track,
    String url,
  ) async {
    final uri = Uri.parse(url);
    final tag = mapToMediaItem(track, url);
    final audioSource = AudioSource.uri(uri, tag: tag);

    return audioSource;
  }

  @override
  void setUriGetter(Future<Uri> Function(TrackEntity track) callback) {
    _uriGetter = callback;
  }

  @override
  Future<void> skipToTrack(int newIndex) async {
    // ignore: no_leading_underscores_for_local_identifiers
    late final List<TrackEntity> _mediaQueue;
    if (shuffleEnabled) {
      _mediaQueue = shuffledQueue;
    } else {
      _mediaQueue = mediaQueue;
    }
    if (newIndex >= 0 && newIndex < _mediaQueue.length) {
      final newTrack = _mediaQueue[newIndex];
      await playTrack(newTrack);
    }
  }

  @override
  Future<void> skipToNext() async {
    // ignore: no_leading_underscores_for_local_identifiers
    late final List<TrackEntity> _mediaQueue;
    if (shuffleEnabled) {
      _mediaQueue = shuffledQueue;
    } else {
      _mediaQueue = mediaQueue;
    }
    if (_mediaQueue[activeTrackIndex()] == _mediaQueue.last) {
      await skipToTrack(0);
      return;
    }
    await skipToTrack(activeTrackIndex() + 1);
  }

  @override
  Future<void> skipToPrevious() async {
    if (audioPlayer.position.inSeconds > 5) {
      await seek(Duration.zero);
      return;
    }
    if (repeatMode == MusilyRepeatMode.repeat) {
      if (mediaQueue[activeTrackIndex()] == mediaQueue.first) {
        await skipToTrack(mediaQueue.length - 1);
        return;
      }
    }
    await skipToTrack(activeTrackIndex() - 1);
  }

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    final shuffleEnabled = shuffleMode != AudioServiceShuffleMode.none;
    await audioPlayer.setShuffleModeEnabled(shuffleEnabled);
    this.shuffleEnabled = shuffleEnabled;
    // ignore: no_leading_underscores_for_local_identifiers
    final List<TrackEntity> _mediaQueue = List.from(mediaQueue);
    shuffledQueue = _mediaQueue..shuffle();
    _onShuffleChanged?.call(shuffleEnabled);
    updateMediaItemQueue();
    _onAction?.call(MusilyPlayerAction.queueChanged);
  }

  Future<void> updateMediaItemQueue() async {
    List<MediaItem> newMediaItemQueue = [];
    for (final item in mediaQueue) {
      final mediaItem = mapToMediaItem(item, item.url ?? '');
      newMediaItemQueue.add(mediaItem);
    }
    queue.add(newMediaItemQueue);
  }

  @override
  Future<void> addToQueue(TrackEntity track) async {
    mediaQueue.add(track);
    shuffledQueue.add(track);
    updateMediaItemQueue();
    _onAction?.call(MusilyPlayerAction.queueChanged);
  }

  @override
  Future<void> removeFromQueue(TrackEntity track) async {
    mediaQueue.removeWhere(
      (element) => element.id == track.id || element.hash == track.hash,
    );
    shuffledQueue.removeWhere(
      (element) => element.id == track.id || element.hash == track.hash,
    );
    updateMediaItemQueue();
    _onAction?.call(MusilyPlayerAction.queueChanged);
  }

  @override
  List<TrackEntity> getQueue() {
    if (shuffleEnabled) {
      return shuffledQueue;
    }
    return mediaQueue;
  }

  @override
  Future<void> setQueue(List<TrackEntity> items) async {
    mediaQueue = [];
    shuffledQueue = [];
    if (items.isEmpty) {
      return;
    }
    for (final item in items) {
      addToQueue(item);
    }
    if (shuffleEnabled) {
      final List<TrackEntity> mediaQueueClone = List.from(mediaQueue);
      final newQueueHash = items.map((element) => element.hash).join('');
      final currentShuffledQueueHash = shuffledQueue
          .map(
            (element) => element.hash,
          )
          .join('');
      if (newQueueHash != currentShuffledQueueHash) {
        shuffledQueue = mediaQueueClone..shuffle();
      }
    }
    updateMediaItemQueue();
    _onAction?.call(MusilyPlayerAction.queueChanged);
  }

  @override
  Future<void> toggleRepeatMode(MusilyRepeatMode repeatMode) async {
    this.repeatMode = repeatMode;
    _onRepeatModeChanged?.call(repeatMode);
  }

  @override
  MusilyRepeatMode getRepeatMode() {
    return repeatMode;
  }

  @override
  bool getShuffleMode() {
    return shuffleEnabled;
  }

  @override
  Future<void> toggleShuffleMode(bool enabled) async {
    await setShuffleMode(
      enabled ? AudioServiceShuffleMode.all : AudioServiceShuffleMode.none,
    );
  }

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    late final LoopMode playerRepeatMode;
    late final MusilyRepeatMode musilyRepeatMode;
    switch (repeatMode) {
      case AudioServiceRepeatMode.none:
        playerRepeatMode = LoopMode.off;
        musilyRepeatMode = MusilyRepeatMode.noRepeat;
        break;
      case AudioServiceRepeatMode.one:
        playerRepeatMode = LoopMode.one;
        musilyRepeatMode = MusilyRepeatMode.repeatOne;
        break;
      case AudioServiceRepeatMode.all:
        playerRepeatMode = LoopMode.all;
        musilyRepeatMode = MusilyRepeatMode.repeat;
        break;
      case AudioServiceRepeatMode.group:
        playerRepeatMode = LoopMode.all;
        musilyRepeatMode = MusilyRepeatMode.repeat;
        break;
    }
    await audioPlayer.setLoopMode(playerRepeatMode);
    this.repeatMode = musilyRepeatMode;
    _onRepeatModeChanged?.call(musilyRepeatMode);
  }
}
