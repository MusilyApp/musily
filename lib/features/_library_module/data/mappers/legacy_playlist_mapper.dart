import 'package:musily/features/_library_module/domain/entities/legacy_library_item_entity.dart';
import 'package:musily/features/_library_module/domain/mappers/legacy_library_item_mapper.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/playlist/data/models/playlist_model.dart';
import 'package:musily/features/playlist/domain/entities/playlist_entity.dart';
import 'package:musily/features/track/data/models/track_model.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';

class LegacyPlaylistMapper implements LegacyLibraryItemMapper<PlaylistEntity> {
  @override
  LegacyLibraryItemEntity<PlaylistEntity> fromMap(
    Map<String, dynamic> map, {
    bool full = false,
  }) {
    final trackCount = ((map['value']['tracks'] ?? []) as List).length;
    return LegacyLibraryItemEntity(
      id: map['id'],
      lastTimePlayed:
          DateTime.tryParse(map['lastTimePlayed']) ?? DateTime.now(),
      value: PlaylistModel.fromMap(
        map['value']..['tracks'] = full ? map['value']['tracks'] : [],
        trackCount: trackCount,
      ),
    );
  }

  @override
  Map<String, dynamic> toMap(PlaylistEntity entity) {
    return {
      'id': entity.id,
      'lastTimePlayed': DateTime.now().toIso8601String(),
      'type': 'playlist',
      'value': PlaylistModel.toMap(entity),
    };
  }

  @override
  Future<LegacyLibraryItemEntity<PlaylistEntity>> toOffline(
    LegacyLibraryItemEntity<PlaylistEntity> item,
    DownloaderController downloaderController,
  ) async {
    final offlineTracks = <TrackEntity>[];
    for (final track in item.value.tracks) {
      final offlineTrack = await TrackModel.toOffline(
        track,
        downloaderController,
      );
      offlineTracks.add(offlineTrack);
    }
    return LegacyLibraryItemEntity(
      id: item.id,
      lastTimePlayed: item.lastTimePlayed,
      value: item.value..tracks = offlineTracks,
    );
  }
}
