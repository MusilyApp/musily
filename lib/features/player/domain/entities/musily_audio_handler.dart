import 'package:musily/features/player/domain/enums/musily_player_action.dart';
import 'package:musily/features/player/domain/enums/musily_player_state.dart';
import 'package:musily/features/player/domain/enums/musily_repeat_mode.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';

abstract class MusilyAudioHandler {
  void setOnPlayerStateChanged(
    Function(
      MusilyPlayerState playerState,
    ) callback,
  );
  void setOnDurationChanged(
    Function(
      Duration duration,
    ) callback,
  );
  void setOnPositionChanged(
    Function(Duration position) callback,
  );
  void setOnPlayerComplete(
    Function() callback,
  );
  void setOnAction(
    Function(
      MusilyPlayerAction playerAction,
    ) callback,
  );
  void setOnShuffleChanged(
    Function(
      bool enabled,
    ) callback,
  );
  void setOnRepeatModeChanged(
    Function(
      MusilyRepeatMode repeatMode,
    ) callback,
  );
  void setOnActiveTrackChange(
    Function(
      TrackEntity? track,
    ) callback,
  );

  void setUriGetter(
    Future<Uri> Function(
      TrackEntity track,
    ) callback,
  );

  Future<void> play();
  Future<void> pause();
  Future<void> stop();
  Future<void> seek(Duration position);
  Future<void> fastForward();
  Future<void> rewind();
  Future<void> playTrack(TrackEntity track);

  Future<void> skipToTrack(int newIndex);
  Future<void> skipToNext();
  Future<void> skipToPrevious();

  Future<void> addToQueue(TrackEntity track);
  Future<void> removeFromQueue(TrackEntity track);
  Future<void> setQueue(List<TrackEntity> items);

  Future<void> toggleShuffleMode(bool enabled);
  Future<void> toggleRepeatMode(MusilyRepeatMode repeatMode);
  Future<void> playPlaylist();

  List<TrackEntity> getQueue();
  MusilyRepeatMode getRepeatMode();
  bool getShuffleMode();
}
