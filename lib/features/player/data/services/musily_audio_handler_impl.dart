import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musily/core/data/services/window_service.dart';
import 'package:musily/features/player/data/mappers/media_mapper.dart';
import 'package:musily/features/player/data/services/player_persistence_service.dart';
import 'package:musily/features/player/domain/entities/musily_audio_handler.dart';
import 'package:musily/features/player/domain/enums/musily_player_action.dart';
import 'package:musily/features/player/domain/enums/musily_player_state.dart';
import 'package:musily/features/player/domain/enums/musily_repeat_mode.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';
import 'package:path_provider/path_provider.dart';

class MusilyAudioHandlerImpl extends BaseAudioHandler
    implements MusilyAudioHandler {
  MusilyAudioHandlerImpl() {
    _setupEventSubscriptions();
    _updatePlaybackState();

    if (Platform.isAndroid) {
      _setupAudioSession();
    }

    loadPlaceholderAudioPath();
    unawaited(_restorePersistedState());
  }

  final _audioPlayer = AudioPlayer();
  final _persistenceService = PlayerPersistenceService();

  List<TrackEntity> _queue = [];
  List<TrackEntity> _shuffledQueue = [];
  TrackEntity? _activeTrack;
  bool _shuffleEnabled = false;
  bool hasStopped = false;
  MusilyRepeatMode _repeatMode = MusilyRepeatMode.noRepeat;
  MusilyPlayerState _playerState = MusilyPlayerState.disposed;
  bool _loadingTrackUrl = false;

  Future<Uri> Function(TrackEntity track)? _uriGetter;

  void Function(MusilyPlayerAction playerAction)? _onAction;
  void Function(bool enabled)? _onShuffleChanged;
  void Function(MusilyRepeatMode repeatMode)? _onRepeatModeChanged;
  void Function(TrackEntity? track)? _onActiveTrackChanged;

  void Function(
    MusilyPlayerState playerState,
  )? _onPlayerStateChanged;
  void Function(Duration duration)? _onDurationChanged;
  void Function(Duration position)? _onPositionChanged;
  void Function()? _onPlayerComplete;

  late StreamSubscription<PlaybackEvent> _playbackEventSubscription;
  late StreamSubscription<Duration?> _durationSubscription;
  late StreamSubscription<int?> _currentIndexSubscription;
  late StreamSubscription<SequenceState?> _sequenceStateSubscription;
  late StreamSubscription<Duration?> _positionChangeSubscription;

  final _processingStateMap = {
    ProcessingState.idle: AudioProcessingState.idle,
    ProcessingState.loading: AudioProcessingState.loading,
    ProcessingState.buffering: AudioProcessingState.buffering,
    ProcessingState.ready: AudioProcessingState.ready,
    ProcessingState.completed: AudioProcessingState.completed,
  };

  final _repeatModeMap = {
    LoopMode.off: AudioServiceRepeatMode.none,
    LoopMode.one: AudioServiceRepeatMode.one,
    LoopMode.all: AudioServiceRepeatMode.all,
  };

  void setVolume(double volume) {
    _audioPlayer.setVolume(volume);
  }

  double get volume => _audioPlayer.volume;

  Stream<double> get volumeStream => _audioPlayer.volumeStream;

  void _setupEventSubscriptions() {
    _playbackEventSubscription = _audioPlayer.playbackEventStream.listen(
      (playbackEvent) async {
        await _handlePlaybackEvent(playbackEvent);
        if (_onPlayerStateChanged != null) {
          _playerState = MusilyPlayerState.disposed;
          switch (playbackEvent.processingState) {
            case ProcessingState.idle:
              _playerState = MusilyPlayerState.stopped;
              break;
            case ProcessingState.loading:
              _playerState = MusilyPlayerState.paused;
            case ProcessingState.buffering:
              _playerState = MusilyPlayerState.buffering;
              break;
            case ProcessingState.ready:
              _playerState = _audioPlayer.playing
                  ? MusilyPlayerState.playing
                  : MusilyPlayerState.paused;
              break;
            case ProcessingState.completed:
              _playerState = MusilyPlayerState.completed;
              break;
          }
          _onPlayerStateChanged!.call(_playerState);
          if (_playerState == MusilyPlayerState.completed) {
            _onPlayerComplete?.call();
          }
        }
      },
    );
    _durationSubscription = _audioPlayer.durationStream.listen(
      (duration) {
        _handleDurationChange(duration);
        _onDurationChanged?.call(duration ?? Duration.zero);
      },
    );
    _currentIndexSubscription =
        _audioPlayer.currentIndexStream.listen(_handleCurrentSongIndexChanged);
    _sequenceStateSubscription =
        _audioPlayer.sequenceStateStream.listen(_handleSequenceStateChange);
    _positionChangeSubscription = _audioPlayer.positionStream.listen(
      (duration) {
        _onPositionChanged?.call(duration);
      },
    );
  }

  Future<void> _restorePersistedState() async {
    final persisted = await _persistenceService.loadState();
    if (persisted == null) {
      return;
    }

    _repeatMode = persisted.repeatMode;
    _shuffleEnabled = persisted.shuffleEnabled;
    _queue = List<TrackEntity>.from(persisted.queue);
    _shuffledQueue = persisted.shuffledQueue.isNotEmpty
        ? List<TrackEntity>.from(persisted.shuffledQueue)
        : List<TrackEntity>.from(persisted.queue);

    _activeTrack = _resolveActiveTrack(
      persisted.currentTrack,
      persisted.currentTrackId,
      persisted.currentTrackHash,
    );

    _onRepeatModeChanged?.call(_repeatMode);
    _onShuffleChanged?.call(_shuffleEnabled);
    _onAction?.call(MusilyPlayerAction.queueChanged);
    if (_activeTrack != null) {
      _onActiveTrackChanged?.call(_activeTrack);
    }
  }

  TrackEntity? _resolveActiveTrack(
    TrackEntity? fallback,
    String? id,
    String? hash,
  ) {
    for (final track in _queue) {
      final matchesId = id != null && id.isNotEmpty && track.id == id;
      final matchesHash = hash != null && hash.isNotEmpty && track.hash == hash;
      if (matchesId || matchesHash) {
        return track;
      }
    }
    return fallback;
  }

  Future<void> _persistPlayerState() {
    return _persistenceService.saveState(
      queue: List<TrackEntity>.from(_queue),
      shuffledQueue: List<TrackEntity>.from(_shuffledQueue),
      shuffleEnabled: _shuffleEnabled,
      repeatMode: _repeatMode,
      currentTrack: _activeTrack,
    );
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

  Future<void> _handlePlaybackEvent(PlaybackEvent event) async {
    const maxRetries = 3;
    int attempt = 0;

    while (attempt < maxRetries) {
      try {
        _shuffleEnabled = _audioPlayer.shuffleModeEnabled;
        if (event.processingState == ProcessingState.completed) {
          switch (_repeatMode) {
            case MusilyRepeatMode.noRepeat:
              if (hasNext) {
                if (_activeTrack == _queue.last) {
                  await seek(Duration.zero);
                  return;
                }
                await skipToNext();
              } else if (_activeTrack != null) {
                final trackId = _queue.first.id;
                await skipToTrack(trackId);
                if (_audioPlayer.playing) {
                  await pause();
                }
                if (_audioPlayer.duration != Duration.zero) {
                  await seek(Duration.zero);
                }
              }
              break;
            case MusilyRepeatMode.repeatOne:
              if (_activeTrack != null) {
                await playTrack(_activeTrack!);
              }
              if (!_audioPlayer.playing) {
                await play();
              }
              break;
            case MusilyRepeatMode.repeat:
              await skipToNext();
              break;
          }
        }
        _updatePlaybackState();
        return;
      } catch (e, stackTrace) {
        attempt++;
        if (attempt >= maxRetries) {
          log(
            '[Error handling playback event] - Failed after $maxRetries attempts',
            error: e,
            stackTrace: stackTrace,
          );
          return;
        }
        log(
          '[Error handling playback event] - Attempt $attempt/$maxRetries failed, retrying...',
          error: e,
          stackTrace: stackTrace,
        );
        await Future.delayed(Duration(milliseconds: 100 * attempt));
      }
    }
  }

  void _updatePlaybackState() {
    playbackState.add(
      playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          if (_audioPlayer.playing) MediaControl.pause else MediaControl.play,
          MediaControl.skipToNext
        ],
        systemActions: const {
          MediaAction.seek,
        },
        androidCompactActionIndices: const [0, 1, 2],
        processingState: _processingStateMap[_audioPlayer.processingState]!,
        repeatMode: _repeatModeMap[_audioPlayer.loopMode]!,
        shuffleMode: _shuffleEnabled
            ? AudioServiceShuffleMode.all
            : AudioServiceShuffleMode.none,
        playing: _audioPlayer.playing,
        updatePosition: _audioPlayer.position,
        bufferedPosition: _audioPlayer.bufferedPosition,
        speed: _audioPlayer.speed,
        queueIndex: _audioPlayer.currentIndex ?? 0,
      ),
    );
  }

  void _handleDurationChange(Duration? duration) {
    try {
      final index = _audioPlayer.currentIndex;
      if (index != null && _queue.isNotEmpty) {
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

  Future<void> _setupAudioSession() async {
    final session = await AudioSession.instance;
    try {
      await session.configure(const AudioSessionConfiguration.music());
      session.interruptionEventStream.listen((event) async {
        if (event.begin) {
          switch (event.type) {
            case AudioInterruptionType.duck:
              await _audioPlayer.setVolume(0.5);
              break;
            case AudioInterruptionType.pause:
              await _audioPlayer.pause();
              _onAction?.call(MusilyPlayerAction.pause);
              break;
            case AudioInterruptionType.unknown:
              await _audioPlayer.pause();
              _onAction?.call(MusilyPlayerAction.pause);
              break;
          }
        } else {
          switch (event.type) {
            case AudioInterruptionType.duck:
              await _audioPlayer.setVolume(1);
              break;
            case AudioInterruptionType.pause:
              break;
            case AudioInterruptionType.unknown:
              await playTrack(_activeTrack!);
              _onAction?.call(MusilyPlayerAction.play);
              break;
          }
        }
      });
    } catch (e, stackTrace) {
      log(
        '[Error initializing audio session]',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> addToQueue(TrackEntity track) async {
    _queue.add(track);
    _shuffledQueue.add(track);
    _onAction?.call(MusilyPlayerAction.queueChanged);
    unawaited(_persistPlayerState());
  }

  @override
  Future<void> fastForward() {
    return seek(
      const Duration(seconds: 10),
    );
  }

  @override
  List<TrackEntity> getQueue() {
    if (_shuffleEnabled) {
      return _shuffledQueue;
    }
    return _queue;
  }

  @override
  MusilyRepeatMode getRepeatMode() {
    return _repeatMode;
  }

  @override
  bool getShuffleMode() {
    return _shuffleEnabled;
  }

  @override
  Future<void> pause() async {
    if (_loadingTrackUrl) {
      return;
    }
    await _audioPlayer.pause();
    _onAction?.call(MusilyPlayerAction.pause);
  }

  @override
  Future<void> play() async {
    if (_loadingTrackUrl) {
      return;
    }
    if (hasStopped) {
      await playTrack(_activeTrack!);
      return;
    }
    await _audioPlayer.play();
    _onAction?.call(MusilyPlayerAction.play);
  }

  @override
  Future<void> playPlaylist() async {
    if (_queue.isNotEmpty) {
      await playTrack(_queue.first);
    }
  }

  @override
  Future<void> playTrack(
    TrackEntity track, {
    bool isPlaceholder = false,
  }) async {
    try {
      late String url;
      final placeholderAudioPath = await loadPlaceholderAudioPath();

      if (track.url != null) {
        url = track.url!;
      } else {
        url = '';
      }

      List<TrackEntity> queue = getQueue();

      final originalTrack = track;
      if (!isPlaceholder) {
        _activeTrack = track;
        _activeTrack!.position = Duration.zero;
        _activeTrack!.duration = Duration.zero;
        final existingUrl = _activeTrack?.url;
        if (existingUrl != null && existingUrl.isNotEmpty) {
          track.url = existingUrl;
          url = existingUrl;
        }

        if (url.isEmpty) {
          _loadingTrackUrl = true;
          final placeholderTrack = track.copyWith(
            url: placeholderAudioPath,
          );
          await _playPlaceholderForRepeatOne(placeholderTrack);
          _activeTrack = originalTrack;
        }
      } else {
        if (url.isNotEmpty) {
          final audioSource = await buildAudioSource(track, url);
          final audioPlayerQueue = ConcatenatingAudioSource(
            children: [audioSource],
          );
          await _audioPlayer.setAudioSource(audioPlayerQueue, preload: false);
          await _audioPlayer.play();
        }
        return;
      }
      _onActiveTrackChanged?.call(track);
      if (queue.where((element) => element.id == track.id).isEmpty) {
        queue = [track];
        _queue = [track];
        _shuffledQueue = [track];
        _onAction?.call(MusilyPlayerAction.queueChanged);
      }
      if (url.isEmpty) {
        if (_audioPlayer.playing) {
          await _audioPlayer.stop();
          hasStopped = true;
        }
        if (track.id != _activeTrack!.id) {
          return;
        }
        if (_uriGetter != null) {
          final uri = await _uriGetter!.call(track);
          if (_audioPlayer.playing) {
            if (track.id != _activeTrack!.id) {
              return;
            }
            await _audioPlayer.stop();
            hasStopped = true;
          }
          url = uri.toString();
          track.url = uri.toString();
          if (_activeTrack != null && track.id == _activeTrack!.id) {
            _activeTrack!.url = url;
            _onActiveTrackChanged?.call(_activeTrack);
          } else {
            _onActiveTrackChanged?.call(track);
          }
          if (url.isEmpty) {
            return;
          }
        }
      }

      if (!isPlaceholder) {
        _loadingTrackUrl = false;
      }
      if (track.id != _activeTrack!.id) {
        return;
      }
      final audioSource = await buildAudioSource(track, url);
      final audioPlayerQueue = ConcatenatingAudioSource(
        children: [audioSource],
      );
      if (track.id != _activeTrack!.id) {
        return;
      }
      await _audioPlayer.setAudioSource(audioPlayerQueue, preload: false);
      if (track.id != _activeTrack!.id) {
        return;
      }
      await _audioPlayer.play();
      hasStopped = false;
      unawaited(_persistPlayerState());
    } catch (e, stackTrace) {
      log(
        '[Error playing song]',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _playPlaceholderForRepeatOne(
      TrackEntity placeholderTrack) async {
    try {
      final url = placeholderTrack.url!;
      final audioSource = await buildAudioSource(placeholderTrack, url);
      final audioPlayerQueue = ConcatenatingAudioSource(
        children: [audioSource],
      );
      await _audioPlayer.setAudioSource(audioPlayerQueue, preload: false);
      await play();
    } catch (e, stackTrace) {
      log(
        '[Error playing placeholder for repeat one]',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  Future<String> loadPlaceholderAudioPath() async {
    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/placeholder.mp3');
    final filesExists = await tempFile.exists();
    if (filesExists) {
      return tempFile.path;
    }
    final audioBytes = await rootBundle.load('assets/audio/placeholder.mp3');
    await tempFile.writeAsBytes(audioBytes.buffer.asUint8List());
    return tempFile.path;
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
  Future<void> removeFromQueue(TrackEntity track) async {
    _queue.removeWhere(
      (element) => element.id == track.id || element.hash == track.hash,
    );
    _shuffledQueue.removeWhere(
      (element) => element.id == track.id || element.hash == track.hash,
    );
    _onAction?.call(MusilyPlayerAction.queueChanged);
    unawaited(_persistPlayerState());
  }

  @override
  Future<void> rewind() {
    return seek(
      const Duration(seconds: -10),
    );
  }

  @override
  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  @override
  void setOnAction(Function(MusilyPlayerAction playerAction) callback) {
    _onAction = callback;
  }

  void updateWindowTitle(TrackEntity? track) {
    if (track != null) {
      late final String windowTitle;
      late final String artistName;
      if (track.title.length > 20) {
        windowTitle = '${track.title.substring(0, 20).trim()}...';
      } else {
        windowTitle = track.title;
      }
      if (track.artist.name.length > 15) {
        artistName = '${track.artist.name.substring(0, 15).trim()}...';
      } else {
        artistName = track.artist.name;
      }
      WindowService.setWindowTitle(
        'Musily - $windowTitle ($artistName)',
      );
    } else {
      WindowService.setWindowTitle('Musily');
    }
  }

  @override
  void setOnActiveTrackChange(Function(TrackEntity? track) callback) {
    _onActiveTrackChanged = (track) {
      callback(track);
      updateWindowTitle(track);
    };
  }

  @override
  void setOnDurationChanged(Function(Duration duration) callback) {
    _onDurationChanged = callback;
  }

  @override
  void setOnPlayerComplete(Function() callback) {
    _onPlayerComplete = callback;
  }

  @override
  void setOnPlayerStateChanged(
      Function(MusilyPlayerState playerState) callback) {
    _onPlayerStateChanged = callback;
  }

  @override
  void setOnPositionChanged(Function(Duration position) callback) {
    _onPositionChanged = callback;
  }

  @override
  void setOnRepeatModeChanged(Function(MusilyRepeatMode repeatMode) callback) {
    _onRepeatModeChanged = callback;
  }

  @override
  void setOnShuffleChanged(Function(bool enabled) callback) {
    _onShuffleChanged = callback;
  }

  @override
  Future<void> setQueue(List<TrackEntity> items) async {
    _queue = [];
    _shuffledQueue = [];
    if (items.isEmpty) {
      return;
    }
    for (final item in items) {
      addToQueue(item);
    }
    if (_shuffleEnabled) {
      final List<TrackEntity> queueClone = List.from(_queue);
      _shuffledQueue = queueClone..shuffle();
    }
    _onAction?.call(MusilyPlayerAction.queueChanged);
    unawaited(_persistPlayerState());
  }

  @override
  Future<void> setShuffledQueue(List<TrackEntity> items) async {
    _shuffledQueue = items;
    _onAction?.call(MusilyPlayerAction.queueChanged);
    unawaited(_persistPlayerState());
  }

  @override
  void setUriGetter(Future<Uri> Function(TrackEntity track) callback) {
    _uriGetter = callback;
  }

  int activeTrackIndex() {
    late final List<TrackEntity> queue;
    if (_shuffleEnabled) {
      queue = _shuffledQueue;
    } else {
      queue = _queue;
    }

    final filteredTrack = queue.where(
      (element) => element.id == _activeTrack?.id,
    );
    if (filteredTrack.isNotEmpty) {
      return queue.indexOf(filteredTrack.first);
    }
    return -1;
  }

  @override
  Future<void> skipToNext() async {
    late final List<TrackEntity> queue = getQueue();
    if (queue[activeTrackIndex()] == queue.last) {
      final trackId = queue.first.id;
      await skipToTrack(trackId);
      return;
    }
    final trackId = queue[activeTrackIndex() + 1].id;
    await skipToTrack(trackId);
  }

  @override
  Future<void> reorderQueue(int newIndex, int oldIndex) async {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final queueCopy = List.from(getQueue());
    final newQueue = queueCopy..insert(newIndex, queueCopy.removeAt(oldIndex));
    if (_shuffleEnabled) {
      _shuffledQueue = List.from(newQueue);
    } else {
      _queue = List.from(newQueue);
    }
    _onAction?.call(MusilyPlayerAction.queueChanged);
    unawaited(_persistPlayerState());
  }

  @override
  Future<void> skipToPrevious() async {
    final queue = getQueue();
    if (_audioPlayer.position.inSeconds > 5) {
      await seek(Duration.zero);
      return;
    }
    if (queue[activeTrackIndex()] == queue.first) {
      final trackId = queue.last.id;
      await skipToTrack(trackId);
      return;
    }
    final trackId = queue[activeTrackIndex() - 1].id;
    await skipToTrack(trackId);
  }

  @override
  Future<void> skipToTrack(String trackId) async {
    late final List<TrackEntity> queue = getQueue();
    if (queue.any((element) => element.id == trackId)) {
      final newTrack = queue.firstWhere((element) => element.id == trackId);
      await playTrack(newTrack);
    }
  }

  @override
  Future<void> stop() async {
    if (hasStopped) {
      return;
    }
    await _audioPlayer.stop();
    _onAction?.call(MusilyPlayerAction.stop);
    hasStopped = true;
    unawaited(_persistPlayerState());
  }

  bool get hasNext => activeTrackIndex() + 1 < _queue.length;

  bool get hasPrevious => activeTrackIndex() > 0;

  @override
  Future<void> toggleRepeatMode(MusilyRepeatMode repeatMode) async {
    _repeatMode = repeatMode;
    _onRepeatModeChanged?.call(repeatMode);
    unawaited(_persistPlayerState());
  }

  @override
  Future<void> toggleShuffleMode(bool enabled) async {
    await setShuffleMode(
      enabled ? AudioServiceShuffleMode.all : AudioServiceShuffleMode.none,
    );
    unawaited(_persistPlayerState());
  }

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    final shuffleEnabled = shuffleMode != AudioServiceShuffleMode.none;
    await _audioPlayer.setShuffleModeEnabled(shuffleEnabled);
    _shuffleEnabled = shuffleEnabled;
    final List<TrackEntity> queue = List.from(_queue);
    _shuffledQueue = queue..shuffle();
    _onShuffleChanged?.call(shuffleEnabled);
    _onAction?.call(MusilyPlayerAction.queueChanged);
  }

  @override
  Future<void> onTaskRemoved() async {
    await _audioPlayer.stop().then((_) => _audioPlayer.dispose());

    await _playbackEventSubscription.cancel();
    await _durationSubscription.cancel();
    await _currentIndexSubscription.cancel();
    await _sequenceStateSubscription.cancel();
    await _positionChangeSubscription.cancel();
    await super.onTaskRemoved();
  }
}
