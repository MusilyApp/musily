import 'package:musily/features/_library_module/domain/entities/legacy_library_item_entity.dart';
import 'package:musily/features/_library_module/domain/mappers/legacy_library_item_mapper.dart';
import 'package:musily/features/artist/data/models/artist_model.dart';
import 'package:musily/features/artist/domain/entitites/artist_entity.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';

class ArtistMapper implements LegacyLibraryItemMapper<ArtistEntity> {
  @override
  LegacyLibraryItemEntity<ArtistEntity> fromMap(
    Map<String, dynamic> map, {
    bool full = false,
  }) {
    return LegacyLibraryItemEntity(
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
  Future<LegacyLibraryItemEntity<ArtistEntity>> toOffline(
    LegacyLibraryItemEntity<ArtistEntity> item,
    DownloaderController downloaderController,
  ) async {
    return LegacyLibraryItemEntity(
      id: item.id,
      lastTimePlayed: item.lastTimePlayed,
      value: item.value,
    );
  }
}
