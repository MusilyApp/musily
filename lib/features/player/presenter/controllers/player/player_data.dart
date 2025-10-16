import 'package:dart_ytmusic_api/types.dart';
import 'package:flutter/material.dart';
import 'package:musily/core/domain/presenter/app_controller.dart';
import 'package:musily/features/player/domain/enums/musily_repeat_mode.dart';
import 'package:musily/features/player/domain/enums/player_mode.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';

class Lyrics {
  final String trackId;
  final String? lyrics;
  final TimedLyricsRes? timedLyrics;

  Lyrics({
    required this.trackId,
    required this.lyrics,
    required this.timedLyrics,
  });
}

class PlayerData implements BaseControllerData {
  List<TrackEntity> queue;
  String playingId;
  TrackEntity? currentPlayingItem;
  bool loadingTrackData;
  bool isPlaying;
  bool loadRequested;
  bool seeking;
  bool shuffleEnabled;
  MusilyRepeatMode repeatMode;
  bool isBuffering;

  PlayerMode playerMode;
  bool loadingLyrics;
  Lyrics lyrics;
  bool syncedLyrics;

  bool mediaAvailable;
  List<String> tracksFromSmartQueue;
  bool autoSmartQueue;
  bool isPositionTriggered;
  bool loadingSmartQueue;

  bool addingToFavorites;
  bool showDownloadManager;

  ThemeMode? themeMode;

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
    required this.playerMode,
    required this.loadingLyrics,
    required this.lyrics,
    required this.syncedLyrics,
    required this.tracksFromSmartQueue,
    required this.loadingSmartQueue,
    required this.addingToFavorites,
    required this.showDownloadManager,
    required this.autoSmartQueue,
    required this.isPositionTriggered,
    this.themeMode,
  });

  @override
  PlayerData copyWith({
    List<TrackEntity>? queue,
    String? playingId,
    TrackEntity? currentPlayingItem,
    bool? loadingTrackData,
    bool? isPlaying,
    bool? loadRequested,
    bool? seeking,
    bool? shuffleEnabled,
    MusilyRepeatMode? repeatMode,
    bool? isBuffering,
    PlayerMode? playerMode,
    bool? loadingLyrics,
    Lyrics? lyrics,
    bool? syncedLyrics,
    bool? mediaAvailable,
    List<String>? tracksFromSmartQueue,
    bool? autoSmartQueue,
    bool? isPositionTriggered,
    bool? loadingSmartQueue,
    bool? addingToFavorites,
    bool? showDownloadManager,
    ThemeMode? themeMode,
  }) {
    return PlayerData(
      queue: queue ?? this.queue,
      playingId: playingId ?? this.playingId,
      currentPlayingItem: currentPlayingItem ?? this.currentPlayingItem,
      loadingTrackData: loadingTrackData ?? this.loadingTrackData,
      isPlaying: isPlaying ?? this.isPlaying,
      loadRequested: loadRequested ?? this.loadRequested,
      seeking: seeking ?? this.seeking,
      shuffleEnabled: shuffleEnabled ?? this.shuffleEnabled,
      repeatMode: repeatMode ?? this.repeatMode,
      isBuffering: isBuffering ?? this.isBuffering,
      playerMode: playerMode ?? this.playerMode,
      loadingLyrics: loadingLyrics ?? this.loadingLyrics,
      lyrics: lyrics ?? this.lyrics,
      syncedLyrics: syncedLyrics ?? this.syncedLyrics,
      mediaAvailable: mediaAvailable ?? this.mediaAvailable,
      tracksFromSmartQueue: tracksFromSmartQueue ?? this.tracksFromSmartQueue,
      loadingSmartQueue: loadingSmartQueue ?? this.loadingSmartQueue,
      addingToFavorites: addingToFavorites ?? this.addingToFavorites,
      showDownloadManager: showDownloadManager ?? this.showDownloadManager,
      themeMode: themeMode ?? this.themeMode,
      autoSmartQueue: autoSmartQueue ?? this.autoSmartQueue,
      isPositionTriggered: isPositionTriggered ?? this.isPositionTriggered,
    );
  }
}
