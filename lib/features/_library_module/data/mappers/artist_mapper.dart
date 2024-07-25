import 'package:musily/features/_library_module/domain/entities/library_item_entity.dart';
import 'package:musily/features/_library_module/domain/mappers/library_item_mapper.dart';
import 'package:musily/features/artist/data/models/artist_model.dart';
import 'package:musily/features/artist/domain/entitites/artist_entity.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';

class ArtistMapper implements LibraryItemMapper<ArtistEntity> {
  @override
  LibraryItemEntity<ArtistEntity> fromMap(Map<String, dynamic> map) {
    return LibraryItemEntity(
      id: map['id'],
      lastTimePlayed:
          DateTime.tryParse(map['lastTimePlayed']) ?? DateTime.now(),
      value: ArtistModel.fromMap(map['value']),
    );
  }

  @override
  Map<String, dynamic> toMap(ArtistEntity entity) {
    return {
      'id': entity.id,
      'lastTimePlayed': DateTime.now().toIso8601String(),
      'type': 'artist',
      'value': ArtistModel.toMap(entity),
    };
  }

  @override
  Future<LibraryItemEntity<ArtistEntity>> toOffline(
    LibraryItemEntity<ArtistEntity> item,
    DownloaderController downloaderController,
  ) async {
    return LibraryItemEntity(
      id: item.id,
      lastTimePlayed: item.lastTimePlayed,
      value: item.value,
    );
  }
}
