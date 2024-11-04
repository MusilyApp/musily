import 'package:musily/features/_library_module/domain/entities/legacy_library_item_entity.dart';
import 'package:musily/features/_library_module/domain/mappers/legacy_library_item_mapper.dart';
import 'package:musily/features/album/data/models/album_model.dart';
import 'package:musily/features/album/domain/entities/album_entity.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';

class AlbumMapper implements LegacyLibraryItemMapper<AlbumEntity> {
  @override
  LegacyLibraryItemEntity<AlbumEntity> fromMap(
    Map<String, dynamic> map, {
    bool full = false,
  }) {
    return LegacyLibraryItemEntity(
      id: map['id'],
      lastTimePlayed:
          DateTime.tryParse(map['lastTimePlayed']) ?? DateTime.now(),
      value: AlbumModel.fromMap(
        map['value'],
      ),
    );
  }

  @override
  Map<String, dynamic> toMap(AlbumEntity entity) {
    return {
      'id': entity.id,
      'lastTimePlayed': DateTime.now().toIso8601String(),
      'releaseDate': DateTime(entity.year),
      'type': 'album',
      'value': AlbumModel.toMap(entity),
    };
  }

  @override
  Future<LegacyLibraryItemEntity<AlbumEntity>> toOffline(
    LegacyLibraryItemEntity<AlbumEntity> item,
    DownloaderController downloaderController,
  ) async {
    final offlineAlbum = await AlbumModel.toOffline(
      item.value,
      downloaderController,
    );
    return LegacyLibraryItemEntity(
      id: item.id,
      lastTimePlayed: item.lastTimePlayed,
      value: offlineAlbum,
    );
  }
}
