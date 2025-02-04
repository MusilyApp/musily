import 'package:musily/features/player/data/services/musily_audio_handler.dart';
import 'package:musily/features/player/domain/enums/musily_player_action.dart';
import 'package:musily/features/player/domain/enums/musily_player_state.dart';
import 'package:musily/features/player/domain/enums/musily_repeat_mode.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';

class MusilyPlayer implements MusilyAudioHandler {
  static final MusilyPlayer _instance = MusilyPlayer._internal();
  factory MusilyPlayer() {
    return _instance;
  }
  MusilyPlayer._internal();

  MusilyAudioHandler? _audioHandler;

  void setAudioHandler(MusilyAudioHandler audioHandler) {
    _audioHandler = audioHandler;
  }

  @override
  Future<void> addToQueue(TrackEntity track) async {
    if (_audioHandler != null) {
      await _audioHandler!.addToQueue(track);
    }
  }

  @override
  Future<void> fastForward() async {
    if (_audioHandler != null) {
      await _audioHandler!.fastForward();
    }
  }

  @override
  Future<void> pause() async {
    if (_audioHandler != null) {
      await _audioHandler!.pause();
    }
  }

  @override
  Future<void> play() async {
    if (_audioHandler != null) {
      await _audioHandler!.play();
    }
  }

  @override
  Future<void> playPlaylist() async {
    if (_audioHandler != null) {
      await _audioHandler!.playPlaylist();
    }
  }

  @override
  Future<void> playTrack(TrackEntity track) async {
    if (_audioHandler != null) {
      await _audioHandler!.playTrack(track);
    }
  }

  @override
  Future<void> removeFromQueue(TrackEntity track) async {
    if (_audioHandler != null) {
      await _audioHandler!.removeFromQueue(track);
    }
  }

  @override
  Future<void> setQueue(List<TrackEntity> items) async {
    if (_audioHandler != null) {
      await _audioHandler!.setQueue(items);
    }
  }

  @override
  Future<void> rewind() async {
    if (_audioHandler != null) {
      await _audioHandler!.rewind();
    }
  }

  @override
  Future<void> seek(Duration position) async {
    if (_audioHandler != null) {
      await _audioHandler!.seek(position);
    }
  }

  @override
  void setOnDurationChanged(Function(Duration duration) callback) {
    if (_audioHandler != null) {
      _audioHandler!.setOnDurationChanged(callback);
    }
  }

  @override
  void setOnPlayerComplete(Function() callback) {
    if (_audioHandler != null) {
      _audioHandler!.setOnPlayerComplete(callback);
    }
  }

  @override
  void setOnPlayerStateChanged(
      Function(MusilyPlayerState playerState) callback) {
    if (_audioHandler != null) {
      _audioHandler!.setOnPlayerStateChanged(callback);
    }
  }

  @override
  void setOnPositionChanged(Function(Duration position) callback) {
    if (_audioHandler != null) {
      _audioHandler!.setOnPositionChanged(callback);
    }
  }

  @override
  Future<void> skipToNext() async {
    if (_audioHandler != null) {
      await _audioHandler!.skipToNext();
    }
  }

  @override
  Future<void> skipToPrevious() async {
    if (_audioHandler != null) {
      await _audioHandler!.skipToPrevious();
    }
  }

  @override
  Future<void> skipToTrack(int newIndex) async {
    if (_audioHandler != null) {
      await _audioHandler!.skipToTrack(newIndex);
    }
  }

  @override
  Future<void> stop() async {
    if (_audioHandler != null) {
      await _audioHandler!.stop();
    }
  }

  @override
  Future<void> toggleRepeatMode(MusilyRepeatMode repeatMode) async {
    if (_audioHandler != null) {
      await _audioHandler!.toggleRepeatMode(repeatMode);
    }
  }

  @override
  Future<void> toggleShuffleMode(bool enabled) async {
    if (_audioHandler != null) {
      await _audioHandler!.toggleShuffleMode(enabled);
    }
  }

  @override
  List<TrackEntity> getQueue() {
    if (_audioHandler != null) {
      final queue = _audioHandler!.getQueue();
      return queue;
    }
    return [];
  }

  @override
  MusilyRepeatMode getRepeatMode() {
    if (_audioHandler != null) {
      return _audioHandler!.getRepeatMode();
    }
    return MusilyRepeatMode.noRepeat;
  }

  @override
  bool getShuffleMode() {
    if (_audioHandler != null) {
      return _audioHandler!.getShuffleMode();
    }
    return false;
  }

  @override
  void setOnAction(Function(MusilyPlayerAction playerAction) callback) {
    if (_audioHandler != null) {
      return _audioHandler!.setOnAction(callback);
    }
  }

  @override
  void setOnRepeatModeChanged(Function(MusilyRepeatMode repeatMode) callback) {
    if (_audioHandler != null) {
      return _audioHandler!.setOnRepeatModeChanged(callback);
    }
  }

  @override
  void setOnShuffleChanged(Function(bool enabled) callback) {
    if (_audioHandler != null) {
      return _audioHandler!.setOnShuffleChanged(callback);
    }
  }

  @override
  void setOnActiveTrackChange(Function(TrackEntity? track) callback) {
    if (_audioHandler != null) {
      return _audioHandler!.setOnActiveTrackChange(callback);
    }
  }

  @override
  void setUriGetter(Future<Uri> Function(TrackEntity track) callback) {
    if (_audioHandler != null) {
      return _audioHandler!.setUriGetter(callback);
    }
  }

  MusilyPlayerState _currentState = MusilyPlayerState.stopped;
  TrackEntity? _currentTrack;

  bool get isPlaying => _currentState == MusilyPlayerState.playing;
  int get queueLength => getQueue().length;
  TrackEntity? get currentTrack => _currentTrack;

  Future<void> togglePlayPause() async {
    if (_audioHandler != null) {
      if (isPlaying) {
        await pause();
      } else {
        await play();
      }
    }
  }

  Future<void> addMultipleToQueue(List<TrackEntity> tracks) async {
    if (_audioHandler != null) {
      for (var track in tracks) {
        await addToQueue(track);
      }
    }
  }

  Future<void> clearQueue() async {
    if (_audioHandler != null) {
      await setQueue([]);
    }
  }

  Future<void> restartTrack() async {
    if (_audioHandler != null) {
      await seek(Duration.zero);
    }
  }

  Future<void> toggleShuffle() async {
    if (_audioHandler != null) {
      await toggleShuffleMode(!getShuffleMode());
    }
  }

  Future<void> cycleRepeatMode() async {
    if (_audioHandler != null) {
      var current = getRepeatMode();
      MusilyRepeatMode next;
      switch (current) {
        case MusilyRepeatMode.noRepeat:
          next = MusilyRepeatMode.repeatAll;
          break;
        case MusilyRepeatMode.repeatAll:
          next = MusilyRepeatMode.repeatOne;
          break;
        case MusilyRepeatMode.repeatOne:
          next = MusilyRepeatMode.noRepeat;
          break;
      }
      await toggleRepeatMode(next);
    }
  }

  void initializeInternalStateListener() {
    if (_audioHandler != null) {
      _audioHandler!.setOnPlayerStateChanged((state) {
        _currentState = state;
      });
    }
  }

  void initializeActiveTrackListener() {
    if (_audioHandler != null) {
      _audioHandler!.setOnActiveTrackChange((track) {
        _currentTrack = track;
      });
    }
  }
}
