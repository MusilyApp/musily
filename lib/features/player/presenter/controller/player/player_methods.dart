import 'package:musily_player/musily_player.dart';

class PlayerMethods {
  Future<void> Function() play;
  Future<void> Function() resume;
  Future<void> Function() pause;
  Future<void> Function() toggleFavorite;
  Future<void> Function(Duration duration) seek;
  Future<void> Function(
    MusilyTrack track,
    String playingId,
  ) loadAndPlay;

  Future<void> Function() toggleShuffle;
  Future<void> Function() toggleRepeatState;
  Future<void> Function() nextInQueue;
  Future<void> Function() previousInQueue;
  Future<void> Function(List<MusilyTrack> items) addToQueue;
  Future<void> Function(int index) queueJumpTo;
  Future<void> Function(int newIndex, int oldIndex) reorderQueue;
  void Function(String trackId) toggleLyrics;
  Future<String?> Function(String trackId) getLyrics;

  Future<void> Function(
    List<MusilyTrack> items,
    String playingId, {
    int startFrom,
  }) playPlaylist;

  PlayerMethods({
    required this.play,
    required this.resume,
    required this.pause,
    required this.toggleFavorite,
    required this.seek,
    required this.loadAndPlay,
    required this.toggleShuffle,
    required this.toggleRepeatState,
    required this.nextInQueue,
    required this.previousInQueue,
    required this.addToQueue,
    required this.queueJumpTo,
    required this.reorderQueue,
    required this.playPlaylist,
    required this.toggleLyrics,
    required this.getLyrics,
  });
}
