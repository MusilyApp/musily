import 'package:musily/core/domain/adapters/database_adapter.dart';
import 'package:musily/features/_library_module/data/mappers/album_mapper.dart';
import 'package:musily/features/_library_module/data/mappers/artist_mapper.dart';
import 'package:musily/features/_library_module/data/mappers/legacy_playlist_mapper.dart';
import 'package:musily/features/_library_module/data/mappers/playlist_mapper.dart';
import 'package:musily/features/_library_module/domain/datasources/legacy_library_datasource.dart';
import 'package:musily/features/_library_module/domain/entities/legacy_library_item_entity.dart';
import 'package:musily/features/_library_module/domain/mappers/legacy_library_item_mapper.dart';
import 'package:musily/features/album/domain/entities/album_entity.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/playlist/domain/entities/playlist_entity.dart';

class LegacyLibraryDatasourceImpl implements LegacyLibraryDatasource {
  late final DatabaseModelAdapter _modelAdapter;

  final DownloaderController downloaderController;

  LegacyLibraryDatasourceImpl({
    required DatabaseModelAdapter modelAdapter,
    required this.downloaderController,
  }) {
    _modelAdapter = modelAdapter;
  }

  LegacyLibraryItemMapper<T> _getMapper<T>(T item) {
    late final LegacyLibraryItemMapper<T> mapper;
    if (item is AlbumEntity) {
      mapper = AlbumMapper() as LegacyLibraryItemMapper<T>;
    } else if (item is PlaylistEntity) {
      mapper = PlaylistMapper() as LegacyLibraryItemMapper<T>;
    } else {
      mapper = ArtistMapper() as LegacyLibraryItemMapper<T>;
    }
    return mapper;
  }

  LegacyLibraryItemMapper<T> _getMapperFromKey<T>(Map<String, dynamic> item) {
    late LegacyLibraryItemMapper<T> mapper;
    switch (item['type']) {
      case 'album':
        mapper = AlbumMapper() as LegacyLibraryItemMapper<T>;
        break;
      case 'playlist':
        mapper = PlaylistMapper() as LegacyLibraryItemMapper<T>;
        break;
      default:
        mapper = ArtistMapper() as LegacyLibraryItemMapper<T>;
        break;
    }
    return mapper;
  }

  @override
  Future<void> deleteLibraryItem(String id) async {
    await _modelAdapter.findByIdAndDelete(id);
  }

  @override
  Future<List<LegacyLibraryItemEntity>> getLibrary() async {
    final items = await _modelAdapter.getAll();
    final libraryItems = <LegacyLibraryItemEntity>[];
    for (final item in items) {
      final LegacyLibraryItemMapper mapper = _getMapperFromKey(item);
      final libraryItem = mapper.fromMap(item);
      libraryItems.add(libraryItem);
    }
    return libraryItems;
  }

  @override
  Future<LegacyLibraryItemEntity<T>?> getLibraryItem<T>(
    String id,
  ) async {
    final item = await _modelAdapter.findById(id);
    if (item != null) {
      final mapper = _getMapperFromKey<T>(item);
      return mapper.fromMap(
        item,
        full: true,
      );
    }
    return null;
  }

  @override
  Future<void> addToLibrary<T>(T item) async {
    final mapper = _getMapper<T>(item);
    await _modelAdapter.put(
      mapper.toMap(item),
    );
  }

  @override
  Future<void> updateLibraryItem<T>(
    String id,
    LegacyLibraryItemEntity<T> item,
  ) async {
    final mapper = _getMapper<T>(item.value);
    await _modelAdapter.put(
      mapper.toMap(item.value),
    );
  }

  @override
  Future<List<LegacyLibraryItemEntity>> getLibraryOffsetLimit(
    int offset,
    int limit,
  ) async {
    final items = await _modelAdapter.getOffsetLimit(offset, limit);
    final offlineItems = <LegacyLibraryItemEntity>[];
    for (final item in items) {
      late final LegacyLibraryItemMapper mapper;
      switch (item['type']) {
        case 'album':
          mapper = AlbumMapper() as LegacyLibraryItemMapper;
          break;
        case 'playlist':
          mapper = LegacyPlaylistMapper();
          break;
        default:
          mapper = ArtistMapper();
          break;
      }
      final offlineItem = await mapper.toOffline(
        mapper.fromMap(item),
        downloaderController,
      );
      offlineItems.add(offlineItem);
    }
    return offlineItems;
  }
}
