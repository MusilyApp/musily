import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musily/features/player/data/mappers/media_mapper.dart';
import 'package:musily/features/player/domain/entities/musily_audio_handler.dart';
import 'package:musily/features/player/domain/enums/musily_player_action.dart';
import 'package:musily/features/player/domain/enums/musily_player_state.dart';
import 'package:musily/features/player/domain/enums/musily_repeat_mode.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smtc_windows/smtc_windows.dart';

class MusilyAudioHandlerImpl extends BaseAudioHandler
    implements MusilyAudioHandler {
  MusilyAudioHandlerImpl() {
    _setupEventSubscriptions();
    _updatePlaybackState();

    if (Platform.isAndroid) {
      _setupAudioSession();
    }

    loadPlaceholderAudioPath();
  }

  final _audioPlayer = AudioPlayer();
  SMTCWindows? _smtc;

  List<TrackEntity> _queue = [];
  List<TrackEntity> _shuffledQueue = [];
  TrackEntity? _activeTrack;
  bool _shuffleEnabled = false;
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
    if (Platform.isWindows) {
      _smtc = SMTCWindows(
        metadata: const MusicMetadata(
          album: '',
          albumArtist: '',
          artist: '',
          thumbnail: '',
          title: '',
        ),
        repeatMode: _repeatMode.toSMTC(),
        shuffleEnabled: _shuffleEnabled,
        status: _playerState.toPlaybackStatus(),
        timeline: const PlaybackTimeline(
          startTimeMs: 0,
          endTimeMs: 0,
          positionMs: 0,
        ),
        config: const SMTCConfig(
          playEnabled: true,
          pauseEnabled: true,
          stopEnabled: false,
          nextEnabled: true,
          prevEnabled: true,
          fastForwardEnabled: false,
          rewindEnabled: false,
        ),
        enabled: false,
      );
      _smtc!.buttonPressStream.listen(
        (event) async {
          switch (event) {
            case PressedButton.play:
              if (_loadingTrackUrl) {
                return;
              }
              await play();
              break;
            case PressedButton.next:
              await skipToNext();
              break;
            case PressedButton.previous:
              await skipToPrevious();
              break;
            case PressedButton.pause:
              if (_loadingTrackUrl) {
                return;
              }
              await pause();
              break;
            default:
              break;
          }
        },
      );
    }
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
              await skipToTrack(0);
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
    } catch (e, stackTrace) {
      log('[Error handling playback event]', error: e, stackTrace: stackTrace);
    }
  }

  void _updatePlaybackState() {
    if (Platform.isWindows && _activeTrack != null) {
      if (_smtc!.metadata.title != _activeTrack!.title) {
        _smtc!.setTitle(_activeTrack!.title);
      }

      if (_loadingTrackUrl) {
        _smtc!.setIsPauseEnabled(false);
      }
      if (_loadingTrackUrl) {
        _smtc!.setIsPlayEnabled(false);
      }
      if (!_loadingTrackUrl) {
        _smtc!.setIsPauseEnabled(true);
      }
      if (!_loadingTrackUrl) {
        _smtc!.setIsPlayEnabled(true);
      }

      if (_smtc!.metadata.album != _activeTrack!.album.title) {
        _smtc!.setAlbum(_activeTrack!.album.title);
      }

      if (_smtc!.metadata.artist != _activeTrack!.artist.name) {
        _smtc!.setArtist(_activeTrack!.artist.name);
      }

      if (_smtc!.metadata.thumbnail != _activeTrack!.highResImg!) {
        _smtc!.setThumbnail(_activeTrack!.highResImg!);
      }

      if (_smtc!.metadata.albumArtist != _activeTrack!.artist.name) {
        _smtc!.setAlbumArtist(_activeTrack!.artist.name);
      }

      if (_smtc!.timeline.endTimeMs != _activeTrack!.duration.inMilliseconds) {
        _smtc!.setEndTime(_activeTrack!.duration);
      }

      if (_smtc!.timeline.startTimeMs != 0) {
        _smtc!.setStartTime(const Duration(seconds: 0));
      }

      if (_smtc!.timeline.positionMs != _activeTrack!.position.inMilliseconds) {
        _smtc!.setPosition(_activeTrack!.position);
      }

      if (_smtc!.repeatMode != _repeatMode.toSMTC()) {
        _smtc!.setRepeatMode(_repeatMode.toSMTC());
      }

      if (_smtc!.isShuffleEnabled != _shuffleEnabled) {
        _smtc!.setShuffleEnabled(_shuffleEnabled);
      }

      _smtc!.setIsNextEnabled(
        hasNext || _shuffleEnabled || _repeatMode == MusilyRepeatMode.repeat,
      );

      _smtc!.setIsPrevEnabled(
        hasPrevious ||
            _shuffleEnabled ||
            _repeatMode == MusilyRepeatMode.repeat,
      );

      if (_smtc!.status != _playerState.toPlaybackStatus()) {
        _smtc!.setPlaybackStatus(_playerState.toPlaybackStatus());
      }

      _smtc!.enableSmtc();
    } else if (Platform.isWindows && _activeTrack == null) {
      _smtc!.disableSmtc();
    } else {
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
    await _audioPlayer.play();
    _onAction?.call(MusilyPlayerAction.play);
  }

  @override
  Future<void> playPlaylist() async {
    if (_queue.isEmpty) {
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

      late List<TrackEntity> queue;
      if (_shuffleEnabled) {
        queue = _shuffledQueue;
      } else {
        queue = _queue;
      }
      _activeTrack = track;
      _activeTrack!.position = Duration.zero;
      _activeTrack!.duration = Duration.zero;
      if (!isPlaceholder) {
        _loadingTrackUrl = true;
        await playTrack(
          track.copyWith(
            url: placeholderAudioPath,
          ),
          isPlaceholder: true,
        );
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
          }
          url = uri.toString();
          track.url = uri.toString();
          if (track.id == _activeTrack!.id) {
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
    } catch (e, stackTrace) {
      log(
        '[Error playing song]',
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

  @override
  void setOnActiveTrackChange(Function(TrackEntity? track) callback) {
    _onActiveTrackChanged = callback;
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
    late final List<TrackEntity> queue;
    if (_shuffleEnabled) {
      queue = _shuffledQueue;
    } else {
      queue = _queue;
    }
    if (queue[activeTrackIndex()] == queue.last) {
      await skipToTrack(0);
      return;
    }
    await skipToTrack(activeTrackIndex() + 1);
  }

  @override
  Future<void> skipToPrevious() async {
    if (_audioPlayer.position.inSeconds > 5) {
      await seek(Duration.zero);
      return;
    }
    if (_queue[activeTrackIndex()] == _queue.first) {
      await skipToTrack(_queue.length - 1);
      return;
    }
    await skipToTrack(activeTrackIndex() - 1);
  }

  @override
  Future<void> skipToTrack(int newIndex) async {
    late final List<TrackEntity> queue;
    if (_shuffleEnabled) {
      queue = _shuffledQueue;
    } else {
      queue = _queue;
    }
    if (newIndex >= 0 && newIndex < queue.length) {
      final newTrack = queue[newIndex];
      await playTrack(newTrack);
    }
  }

  @override
  Future<void> stop() async {
    _activeTrack = null;
    _onActiveTrackChanged?.call(null);
    await _audioPlayer.stop();
    _onAction?.call(MusilyPlayerAction.stop);
  }

  bool get hasNext => activeTrackIndex() + 1 < _queue.length;

  bool get hasPrevious => activeTrackIndex() > 0;

  @override
  Future<void> toggleRepeatMode(MusilyRepeatMode repeatMode) async {
    _repeatMode = repeatMode;
    _onRepeatModeChanged?.call(repeatMode);
    if (Platform.isWindows) {
      _smtc!.setIsNextEnabled(
          _shuffleEnabled || hasNext || repeatMode == MusilyRepeatMode.repeat);
      _smtc!.setIsPrevEnabled(_shuffleEnabled ||
          hasPrevious ||
          repeatMode == MusilyRepeatMode.repeat);
    }
  }

  @override
  Future<void> toggleShuffleMode(bool enabled) async {
    await setShuffleMode(
      enabled ? AudioServiceShuffleMode.all : AudioServiceShuffleMode.none,
    );
  }

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    final shuffleEnabled = shuffleMode != AudioServiceShuffleMode.none;
    await _audioPlayer.setShuffleModeEnabled(shuffleEnabled);
    _shuffleEnabled = shuffleEnabled;
    final List<TrackEntity> queue = List.from(_queue);
    _shuffledQueue = queue..shuffle();
    _onShuffleChanged?.call(shuffleEnabled);
    if (Platform.isWindows) {
      _smtc!.setIsNextEnabled(
          shuffleEnabled || hasNext || _repeatMode == MusilyRepeatMode.repeat);
      _smtc!.setIsPrevEnabled(shuffleEnabled ||
          hasPrevious ||
          _repeatMode == MusilyRepeatMode.repeat);
    }
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
    if (Platform.isWindows) {
      _smtc!.disableSmtc();
      _smtc!.dispose();
    }
    await super.onTaskRemoved();
  }
}
