import 'package:musily/features/_library_module/domain/entities/library_item_entity.dart';
import 'package:musily/features/_library_module/domain/mappers/library_item_mapper.dart';
import 'package:musily/features/album/data/models/album_model.dart';
import 'package:musily/features/album/domain/entities/album_entity.dart';
import 'package:musily_player/presenter/controllers/downloader/downloader_controller.dart';

class AlbumMapper implements LibraryItemMapper<AlbumEntity> {
  @override
  LibraryItemEntity<AlbumEntity> fromMap(
    Map<String, dynamic> map, {
    bool full = false,
  }) {
    return LibraryItemEntity(
      id: map['id'],
      lastTimePlayed:
          DateTime.tryParse(map['lastTimePlayed']) ?? DateTime.now(),
      value: AlbumModel.fromMap(
        (map['value'])..['tracks'] = full ? map['value']['tracks'] : [],
      ),
    );
  }

  @override
  Map<String, dynamic> toMap(AlbumEntity entity) {
    return {
      'id': entity.id,
      'lastTimePlayed': DateTime.now().toIso8601String(),
      'type': 'album',
      'value': AlbumModel.toMap(entity),
    };
  }

  @override
  Future<LibraryItemEntity<AlbumEntity>> toOffline(
    LibraryItemEntity<AlbumEntity> item,
    DownloaderController downloaderController,
  ) async {
    final offlineAlbum = await AlbumModel.toOffline(
      item.value,
      downloaderController,
    );
    return LibraryItemEntity(
      id: item.id,
      lastTimePlayed: item.lastTimePlayed,
      value: offlineAlbum,
    );
  }
}
