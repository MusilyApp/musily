import 'package:musily/core/domain/errors/musily_error.dart';
import 'package:musily/features/_library_module/domain/entities/library_item_entity.dart';
import 'package:musily/features/_library_module/domain/mappers/library_item_mapper.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/playlist/data/models/playlist_model.dart';
import 'package:musily/features/playlist/domain/entities/playlist_entity.dart';
import 'package:musily/features/track/data/models/track_model.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';

class PlaylistMapper implements LibraryItemMapper<PlaylistEntity> {
  @override
  LibraryItemEntity fromMap(
    Map<String, dynamic> map, {
    bool full = false,
  }) {
    final trackCount = (map['playlist']['trackCount'] ?? 0);
    return LibraryItemEntity(
      id: map['playlist']['id'],
      synced: false,
      lastTimePlayed:
          DateTime.tryParse(map['lastTimePlayed']) ?? DateTime.now(),
      playlist: PlaylistModel.fromMap(
        map['playlist']..['tracks'] = full ? map['playlist']['tracks'] : [],
        trackCount: trackCount,
      ),
      createdAt: DateTime.tryParse(map['createdAt']) ?? DateTime.now(),
    );
  }

  @override
  Map<String, dynamic> toMap(PlaylistEntity entity) {
    return {
      'id': entity.id,
      'lastTimePlayed': DateTime.now().toIso8601String(),
      'playlist': PlaylistModel.toMap(entity),
      'createdAt': DateTime.now().toIso8601String()
    };
  }

  @override
  Future<LibraryItemEntity> toOffline(
    LibraryItemEntity item,
    DownloaderController downloaderController,
  ) async {
    if (item.playlist == null) {
      throw MusilyError(code: 500, id: 'playlist_not_found');
    }
    final offlineTracks = <TrackEntity>[];
    for (final track in item.playlist!.tracks) {
      final offlineTrack = await TrackModel.toOffline(
        track,
        downloaderController,
      );
      offlineTracks.add(offlineTrack);
    }
    return LibraryItemEntity(
      id: item.id,
      lastTimePlayed: item.lastTimePlayed,
      synced: false,
      playlist: item.playlist!..tracks = offlineTracks,
      createdAt: item.createdAt,
    );
  }
}
