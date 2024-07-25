import 'package:musily/core/domain/presenter/app_controller.dart';
import 'package:musily_player/musily_entities.dart';
import 'package:musily_player/musily_player.dart';

class PlayerData extends BaseControllerData {
  List<MusilyTrack> queue;
  String playingId;
  MusilyTrack? currentPlayingItem;
  bool loadingTrackData;
  bool isPlaying;
  bool loadRequested;
  bool seeking;
  bool shuffleEnabled;
  MusilyRepeatMode repeatMode;
  bool isBuffering;

  bool mediaAvailable;

  PlayerData({
    required this.queue,
    required this.playingId,
    this.currentPlayingItem,
    required this.loadingTrackData,
    required this.isPlaying,
    required this.loadRequested,
    required this.seeking,
    required this.mediaAvailable,
    required this.shuffleEnabled,
    required this.repeatMode,
    required this.isBuffering,
  });

  @override
  PlayerData copyWith({
    List<MusilyTrack>? queue,
    MusilyTrack? currentPlayingItem,
    bool? loadingTrackData,
    bool? isPlaying,
    bool? loadRequested,
    bool? seeking,
    bool? mediaAvailable,
    bool? shuffleEnabled,
    MusilyRepeatMode? repeatMode,
    bool? isBuffering,
    String? playingId,
  }) {
    return PlayerData(
      playingId: playingId ?? this.playingId,
      queue: queue ?? this.queue,
      currentPlayingItem: currentPlayingItem ?? this.currentPlayingItem,
      loadingTrackData: loadingTrackData ?? this.loadingTrackData,
      isPlaying: isPlaying ?? this.isPlaying,
      loadRequested: loadRequested ?? this.loadRequested,
      seeking: seeking ?? this.seeking,
      mediaAvailable: mediaAvailable ?? this.mediaAvailable,
      shuffleEnabled: shuffleEnabled ?? this.shuffleEnabled,
      repeatMode: repeatMode ?? this.repeatMode,
      isBuffering: isBuffering ?? this.isBuffering,
    );
  }
}
