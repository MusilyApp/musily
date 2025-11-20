import 'dart:convert';
import 'dart:developer';

import 'package:isar/isar.dart';
import 'package:musily/core/data/database/collections/player_state.dart';
import 'package:musily/core/data/database/database.dart';
import 'package:musily/features/album/domain/entities/album_entity.dart';
import 'package:musily/features/artist/domain/entitites/artist_entity.dart';
import 'package:musily/features/player/domain/enums/musily_repeat_mode.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';

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

  static const _stateKey = 'player_state';
  final _db = Database();

  Future<void> saveState({
    required List<TrackEntity> queue,
    required List<TrackEntity> shuffledQueue,
    required bool shuffleEnabled,
    required MusilyRepeatMode repeatMode,
    required TrackEntity? currentTrack,
  }) async {
    try {
      await _db.isar.writeTxn(() async {
        final state = PlayerState()
          ..stateKey = _stateKey
          ..repeatMode = repeatMode.name
          ..shuffleEnabled = shuffleEnabled
          ..currentTrackId = currentTrack?.id
          ..currentTrackHash = currentTrack?.hash
          ..currentTrackJson = currentTrack != null
              ? jsonEncode(_trackToJson(currentTrack))
              : null
          ..lastUpdated = DateTime.now().millisecondsSinceEpoch;

        await _db.isar.playerStates.putByStateKey(state);

        final normalTracksToDelete = await _db.isar.queueTracks
            .filter()
            .queueTypeEqualTo('normal')
            .findAll();
        await _db.isar.queueTracks
            .deleteAll(normalTracksToDelete.map((e) => e.id).toList());

        final shuffledTracksToDelete = await _db.isar.queueTracks
            .filter()
            .queueTypeEqualTo('shuffled')
            .findAll();
        await _db.isar.queueTracks
            .deleteAll(shuffledTracksToDelete.map((e) => e.id).toList());

        final normalQueueTracks = <QueueTrack>[];
        for (var i = 0; i < queue.length; i++) {
          final track = queue[i];
          final queueTrack = QueueTrack()
            ..queueType = 'normal'
            ..orderIndex = i
            ..trackId = track.id
            ..hash = track.hash
            ..title = track.title
            ..artistId = track.artist.id
            ..artistName = track.artist.name
            ..albumId = track.album.id
            ..albumTitle = track.album.title
            ..highResImg = track.highResImg
            ..lowResImg = track.lowResImg
            ..source = track.source
            ..url = track.isLocal ? track.url : null
            ..fromSmartQueue = track.fromSmartQueue
            ..durationMs = track.duration.inMilliseconds
            ..positionMs = track.position.inMilliseconds
            ..isLocal = track.isLocal;

          normalQueueTracks.add(queueTrack);
        }
        if (normalQueueTracks.isNotEmpty) {
          await _db.isar.queueTracks.putAll(normalQueueTracks);
        }

        final shuffledQueueTracks = <QueueTrack>[];
        for (var i = 0; i < shuffledQueue.length; i++) {
          final track = shuffledQueue[i];
          final queueTrack = QueueTrack()
            ..queueType = 'shuffled'
            ..orderIndex = i
            ..trackId = track.id
            ..hash = track.hash
            ..title = track.title
            ..artistId = track.artist.id
            ..artistName = track.artist.name
            ..albumId = track.album.id
            ..albumTitle = track.album.title
            ..highResImg = track.highResImg
            ..lowResImg = track.lowResImg
            ..source = track.source
            ..url = track.isLocal ? track.url : null
            ..fromSmartQueue = track.fromSmartQueue
            ..durationMs = track.duration.inMilliseconds
            ..positionMs = track.position.inMilliseconds
            ..isLocal = track.isLocal;

          shuffledQueueTracks.add(queueTrack);
        }
        if (shuffledQueueTracks.isNotEmpty) {
          await _db.isar.queueTracks.putAll(shuffledQueueTracks);
        }
      });
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
      final state = await _db.isar.playerStates.getByStateKey(_stateKey);

      if (state == null) {
        return null;
      }

      final repeatMode = MusilyRepeatMode.values.firstWhere(
        (mode) => mode.name == state.repeatMode,
        orElse: () => MusilyRepeatMode.noRepeat,
      );

      final allQueueTracks = await _db.isar.queueTracks.where().findAll();

      final normalQueueTracks = allQueueTracks
          .where((t) => t.queueType == 'normal')
          .toList()
        ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));

      final shuffledQueueTracks = allQueueTracks
          .where((t) => t.queueType == 'shuffled')
          .toList()
        ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));

      final queue = normalQueueTracks.map(_queueTrackToEntity).toList();
      final shuffledQueue =
          shuffledQueueTracks.map(_queueTrackToEntity).toList();

      TrackEntity? currentTrack;
      if (state.currentTrackJson != null) {
        try {
          final json =
              jsonDecode(state.currentTrackJson!) as Map<String, dynamic>;
          currentTrack = _trackFromJson(json);
        } catch (e) {
          log('[PlayerPersistenceService] Failed to parse current track JSON',
              error: e);
        }
      }

      return PlayerPersistedState(
        queue: queue,
        shuffledQueue: shuffledQueue,
        shuffleEnabled: state.shuffleEnabled,
        repeatMode: repeatMode,
        currentTrack: currentTrack,
        currentTrackId: state.currentTrackId,
        currentTrackHash: state.currentTrackHash,
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
      await _db.isar.writeTxn(() async {
        await _db.isar.playerStates.deleteByStateKey(_stateKey);

        final normalTracksToDelete = await _db.isar.queueTracks
            .filter()
            .queueTypeEqualTo('normal')
            .findAll();
        await _db.isar.queueTracks
            .deleteAll(normalTracksToDelete.map((e) => e.id).toList());

        final shuffledTracksToDelete = await _db.isar.queueTracks
            .filter()
            .queueTypeEqualTo('shuffled')
            .findAll();
        await _db.isar.queueTracks
            .deleteAll(shuffledTracksToDelete.map((e) => e.id).toList());
      });
    } catch (e, stackTrace) {
      log(
        '[PlayerPersistenceService] Failed to clear player state',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  static TrackEntity _queueTrackToEntity(QueueTrack queueTrack) {
    return TrackEntity(
      id: queueTrack.trackId,
      orderIndex: queueTrack.orderIndex,
      title: queueTrack.title,
      hash: queueTrack.hash,
      artist: SimplifiedArtist(
        id: queueTrack.artistId,
        name: queueTrack.artistName,
      ),
      album: SimplifiedAlbum(
        id: queueTrack.albumId,
        title: queueTrack.albumTitle,
      ),
      highResImg: queueTrack.highResImg,
      lowResImg: queueTrack.lowResImg,
      source: queueTrack.source,
      fromSmartQueue: queueTrack.fromSmartQueue,
      duration: Duration(milliseconds: queueTrack.durationMs),
      position: Duration(milliseconds: queueTrack.positionMs),
      url: queueTrack.url,
      isLocal: queueTrack.isLocal,
    );
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
