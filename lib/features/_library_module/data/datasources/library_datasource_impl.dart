import 'package:musily/core/domain/adapters/database_adapter.dart';
import 'package:musily/features/_library_module/data/mappers/album_mapper.dart';
import 'package:musily/features/_library_module/data/mappers/artist_mapper.dart';
import 'package:musily/features/_library_module/data/mappers/playlist_mapper.dart';
import 'package:musily/features/_library_module/domain/datasources/library_datasource.dart';
import 'package:musily/features/_library_module/domain/entities/library_item_entity.dart';
import 'package:musily/features/_library_module/domain/mappers/library_item_mapper.dart';
import 'package:musily/features/album/domain/entities/album_entity.dart';
import 'package:musily_player/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/playlist/domain/entities/playlist_entity.dart';

class LibraryDatasourceImpl implements LibraryDatasource {
  late final DatabaseModelAdapter _modelAdapter;

  final DownloaderController downloaderController;

  LibraryDatasourceImpl({
    required DatabaseModelAdapter modelAdapter,
    required this.downloaderController,
  }) {
    _modelAdapter = modelAdapter;
  }

  LibraryItemMapper<T> _getMapper<T>(T item) {
    late final LibraryItemMapper<T> mapper;
    if (item is AlbumEntity) {
      mapper = AlbumMapper() as LibraryItemMapper<T>;
    } else if (item is PlaylistEntity) {
      mapper = PlaylistMapper() as LibraryItemMapper<T>;
    } else {
      mapper = ArtistMapper() as LibraryItemMapper<T>;
    }
    return mapper;
  }

  LibraryItemMapper<T> _getMapperFromKey<T>(Map<String, dynamic> item) {
    late LibraryItemMapper<T> mapper;
    switch (item['type']) {
      case 'album':
        mapper = AlbumMapper() as LibraryItemMapper<T>;
        break;
      case 'playlist':
        mapper = PlaylistMapper() as LibraryItemMapper<T>;
        break;
      default:
        mapper = ArtistMapper() as LibraryItemMapper<T>;
        break;
    }
    return mapper;
  }

  @override
  Future<void> deleteLibraryItem(String id) async {
    await _modelAdapter.findByIdAndDelete(id);
  }

  @override
  Future<List<LibraryItemEntity>> getLibrary() async {
    final items = await _modelAdapter.getAll();
    final libraryItems = <LibraryItemEntity>[];
    for (final item in items) {
      final LibraryItemMapper mapper = _getMapperFromKey(item);
      final libraryItem = mapper.fromMap(item);
      libraryItems.add(libraryItem);
    }
    return libraryItems;
  }

  @override
  Future<LibraryItemEntity<T>?> getLibraryItem<T>(
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
    LibraryItemEntity<T> item,
  ) async {
    final mapper = _getMapper<T>(item.value);
    await _modelAdapter.put(
      mapper.toMap(item.value),
    );
  }

  @override
  Future<List<LibraryItemEntity>> getLibraryOffsetLimit(
      int offset, int limit) async {
    final items = await _modelAdapter.getOffsetLimit(offset, limit);
    final offlineItems = <LibraryItemEntity>[];
    for (final item in items) {
      late final LibraryItemMapper mapper;
      switch (item['type']) {
        case 'album':
          mapper = AlbumMapper() as LibraryItemMapper;
          break;
        case 'playlist':
          mapper = PlaylistMapper();
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
