import 'dart:convert';
import 'dart:developer';

import 'package:musily/features/album/domain/entities/album_entity.dart';
import 'package:musily/features/artist/domain/entitites/artist_entity.dart';
import 'package:musily/features/player/domain/enums/musily_repeat_mode.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlayerPersistedState {
  final List<TrackEntity> queue;
  final List<TrackEntity> shuffledQueue;
  final bool shuffleEnabled;
  final MusilyRepeatMode repeatMode;
  final TrackEntity? currentTrack;
  final String? currentTrackId;
  final String? currentTrackHash;

  PlayerPersistedState({
    required this.queue,
    required this.shuffledQueue,
    required this.shuffleEnabled,
    required this.repeatMode,
    required this.currentTrack,
    required this.currentTrackId,
    required this.currentTrackHash,
  });
}

class PlayerPersistenceService {
  PlayerPersistenceService._();
  static final PlayerPersistenceService _instance =
      PlayerPersistenceService._();
  factory PlayerPersistenceService() => _instance;

  static const _storageKey = 'player_state';

  Future<void> saveState({
    required List<TrackEntity> queue,
    required List<TrackEntity> shuffledQueue,
    required bool shuffleEnabled,
    required MusilyRepeatMode repeatMode,
    required TrackEntity? currentTrack,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final payload = {
        'repeatMode': repeatMode.name,
        'shuffleEnabled': shuffleEnabled,
        'queue': queue.map(_trackToJson).toList(),
        'shuffledQueue': shuffledQueue.map(_trackToJson).toList(),
        'currentTrack':
            currentTrack != null ? _trackToJson(currentTrack) : null,
        'currentTrackId': currentTrack?.id,
        'currentTrackHash': currentTrack?.hash,
      };

      await prefs.setString(_storageKey, jsonEncode(payload));
    } catch (e, stackTrace) {
      log(
        '[PlayerPersistenceService] Failed to save player state',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  Future<PlayerPersistedState?> loadState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_storageKey);
      if (raw == null || raw.isEmpty) {
        return null;
      }

      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) {
        return null;
      }

      final repeatName = decoded['repeatMode'] as String?;
      final repeatMode = MusilyRepeatMode.values.firstWhere(
        (mode) => mode.name == repeatName,
        orElse: () => MusilyRepeatMode.noRepeat,
      );

      final queue = _decodeTrackList(decoded['queue']);
      final shuffledQueue = _decodeTrackList(decoded['shuffledQueue']);
      final currentTrackMap = decoded['currentTrack'];

      TrackEntity? currentTrack;
      if (currentTrackMap is Map<String, dynamic>) {
        currentTrack = _trackFromJson(currentTrackMap);
      }

      return PlayerPersistedState(
        queue: queue,
        shuffledQueue: shuffledQueue,
        shuffleEnabled: decoded['shuffleEnabled'] as bool? ?? false,
        repeatMode: repeatMode,
        currentTrack: currentTrack,
        currentTrackId: decoded['currentTrackId'] as String?,
        currentTrackHash: decoded['currentTrackHash'] as String?,
      );
    } catch (e, stackTrace) {
      log(
        '[PlayerPersistenceService] Failed to load player state',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  Future<void> clear() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_storageKey);
    } catch (e, stackTrace) {
      log(
        '[PlayerPersistenceService] Failed to clear player state',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  static List<TrackEntity> _decodeTrackList(dynamic value) {
    if (value is! List) {
      return [];
    }
    return value.whereType<Map<String, dynamic>>().map(_trackFromJson).toList();
  }

  static Map<String, dynamic> _trackToJson(TrackEntity track) {
    return {
      'id': track.id,
      'orderIndex': track.orderIndex,
      'title': track.title,
      'hash': track.hash,
      'artist': {
        'id': track.artist.id,
        'name': track.artist.name,
      },
      'album': {
        'id': track.album.id,
        'title': track.album.title,
      },
      'highResImg': track.highResImg,
      'lowResImg': track.lowResImg,
      'source': track.source,
      'url': track.isLocal ? track.url : null,
      'fromSmartQueue': track.fromSmartQueue,
      'durationMs': track.duration.inMilliseconds,
      'positionMs': track.position.inMilliseconds,
      'isLocal': track.isLocal,
    };
  }

  static TrackEntity _trackFromJson(Map<String, dynamic> json) {
    final artistMap =
        (json['artist'] as Map<String, dynamic>?) ?? <String, dynamic>{};
    final albumMap =
        (json['album'] as Map<String, dynamic>?) ?? <String, dynamic>{};

    return TrackEntity(
      id: json['id'] as String? ?? '',
      orderIndex: (json['orderIndex'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? '',
      hash: json['hash'] as String? ?? '',
      artist: SimplifiedArtist(
        id: artistMap['id'] as String? ?? '',
        name: artistMap['name'] as String? ?? '',
      ),
      album: SimplifiedAlbum(
        id: albumMap['id'] as String? ?? '',
        title: albumMap['title'] as String? ?? '',
      ),
      highResImg: json['highResImg'] as String?,
      lowResImg: json['lowResImg'] as String?,
      source: json['source'] as String?,
      fromSmartQueue: json['fromSmartQueue'] as bool? ?? false,
      duration: Duration(
        milliseconds: (json['durationMs'] as num?)?.toInt() ?? 0,
      ),
      position: Duration(
        milliseconds: (json['positionMs'] as num?)?.toInt() ?? 0,
      ),
      url: json['url'] as String?,
      isLocal: json['isLocal'] as bool? ?? false,
    );
  }
}
