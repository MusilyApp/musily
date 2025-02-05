import 'package:musily/features/player/data/services/musily_audio_handler.dart';
import 'package:musily/features/player/domain/enums/musily_player_action.dart';
import 'package:musily/features/player/domain/enums/musily_player_state.dart';
import 'package:musily/features/player/domain/enums/musily_repeat_mode.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';

abstract class VolumeControl {
  Future<void> setVolume(double volume);
}

abstract class SpeedControl {
  Future<void> setPlaybackSpeed(double speed);
}

abstract class SeekControl {
  Future<void> seek(Duration position);
}

class MusilyPlayer implements MusilyAudioHandler {
  static final MusilyPlayer _instance = MusilyPlayer._internal();
  factory MusilyPlayer() {
    return _instance;
  }
  MusilyPlayer._internal();

  MusilyAudioHandler? _audioHandler;

  // New private fields for enhanced functionality
  double _volume = 1.0; // volume level from 0.0 to 1.0
  bool _isMuted = false;
  Duration? _currentDuration;
  final List<TrackEntity> _playHistory = [];

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
      // Add track to history when played
      _playHistory.add(track);
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
      _audioHandler!.setOnDurationChanged((duration) {
        _currentDuration = duration;
        callback(duration);
      });
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

  // Additional enhanced functions

  Future<void> setVolume(double volume) async {
    // Simulate setting volume. In a real scenario, this would interact with the audio backend.
    if (volume < 0.0) volume = 0.0;
    if (volume > 1.0) volume = 1.0;
    _volume = volume;
    if (_audioHandler != null && _audioHandler is VolumeControl) {
      await (_audioHandler as VolumeControl).setVolume(volume);
    }
  }

  double get volume => _volume;

  Future<void> setPlaybackSpeed(double speed) async {
    // Simulate setting playback speed. In a real scenario, this would interact with the audio backend.
    if (speed <= 0) speed = 1.0;
    if (_audioHandler != null && _audioHandler is SpeedControl) {
      await (_audioHandler as SpeedControl).setPlaybackSpeed(speed);
    }
  }

  Future<void> skipForwardSeconds(int seconds) async {
    // Skip forward relative to current position.
    // This requires current position retrieval; here we simulate using Duration.zero.
    if (_audioHandler != null && _audioHandler is SeekControl) {
      Duration currentPosition = Duration.zero; // Replace with actual current position if available.
      Duration newPosition = currentPosition + Duration(seconds: seconds);
      await (_audioHandler as SeekControl).seek(newPosition);
    }
  }

  Future<void> skipBackwardSeconds(int seconds) async {
    // Skip backward relative to current position.
    if (_audioHandler != null && _audioHandler is SeekControl) {
      Duration currentPosition = Duration.zero; // Replace with actual current position if available.
      Duration newPosition = currentPosition - Duration(seconds: seconds);
      if (newPosition < Duration.zero) newPosition = Duration.zero;
      await (_audioHandler as SeekControl).seek(newPosition);
    }
  }

  Future<void> seekToPercentage(double percentage) async {
    // Seek to a position based on a percentage of the track's duration.
    if (_currentDuration != null && _audioHandler != null && _audioHandler is SeekControl) {
      final totalSeconds = _currentDuration!.inSeconds;
      final newSeconds = (totalSeconds * percentage).toInt();
      await (_audioHandler as SeekControl).seek(Duration(seconds: newSeconds));
    }
  }

  Future<void> mute() async {
    _isMuted = true;
    await setVolume(0.0);
  }

  Future<void> unmute() async {
    _isMuted = false;
    await setVolume(1.0);
  }

  bool get isMuted => _isMuted;

  Future<Map<String, dynamic>> getPlayerStatus() async {
    // Returns a snapshot of the current player status.
    return {
      'isPlaying': isPlaying,
      'queueLength': queueLength,
      'currentTrack': currentTrack,
      'volume': _volume,
      'isMuted': _isMuted,
      'repeatMode': getRepeatMode().toString(),
      'shuffleMode': getShuffleMode(),
    };
  }

  List<TrackEntity> get playHistory => List.unmodifiable(_playHistory);

  Future<void> playNextTrackIfAvailable() async {
    // Play next track if available in the queue.
    final queue = getQueue();
    if (queue.isNotEmpty) {
      final nextTrack = queue.first;
      await playTrack(nextTrack);
    }
  }

  Future<void> playPreviousTrackIfAvailable() async {
    // Play previous track if available in history.
    if (_playHistory.length > 1) {
      // Remove the current track from history and get the last one.
      _playHistory.removeLast();
      final previousTrack = _playHistory.last;
      await playTrack(previousTrack);
    }
  }
}
