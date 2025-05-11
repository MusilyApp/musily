import 'package:smtc_windows/smtc_windows.dart';

enum MusilyPlayerState {
  playing,
  stopped,
  paused,
  completed,
  disposed,
  loading,
  buffering;

  PlaybackStatus toPlaybackStatus() {
    switch (this) {
      case MusilyPlayerState.paused:
        return PlaybackStatus.paused;
      case MusilyPlayerState.playing:
        return PlaybackStatus.playing;
      case MusilyPlayerState.buffering:
        return PlaybackStatus.changing;
      case MusilyPlayerState.completed:
        return PlaybackStatus.stopped;
      case MusilyPlayerState.stopped:
        return PlaybackStatus.stopped;
      case MusilyPlayerState.disposed:
        return PlaybackStatus.closed;
      case MusilyPlayerState.loading:
        return PlaybackStatus.changing;
    }
  }
}
