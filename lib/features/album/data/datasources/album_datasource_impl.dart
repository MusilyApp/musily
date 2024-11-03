import 'package:musily/core/domain/datasources/base_datasource.dart';
import 'package:musily/core/domain/repositories/musily_repository.dart';
import 'package:musily/features/_library_module/domain/datasources/library_datasource.dart';
import 'package:musily/features/album/data/models/album_model.dart';
import 'package:musily/features/album/domain/datasources/album_datasource.dart';
import 'package:musily/features/album/domain/entities/album_entity.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';

class AlbumDatasourceImpl extends BaseDatasource implements AlbumDatasource {
  late final DownloaderController _downloaderController;
  late final LibraryDatasource _libraryDatasource;
  late final MusilyRepository _musilyRepository;

  AlbumDatasourceImpl({
    required DownloaderController downloaderController,
    required LibraryDatasource libraryDatasource,
    required MusilyRepository musilyRepository,
  }) {
    _downloaderController = downloaderController;
    _libraryDatasource = libraryDatasource;
    _musilyRepository = musilyRepository;
  }

  @override
  Future<AlbumEntity?> getAlbum(String id) async {
    return exec<AlbumEntity?>(() async {
      final libraryItem = await _libraryDatasource.getLibraryItem(
        id,
      );
      if (libraryItem?.album != null) {
        final offlineLibraryItem = await AlbumModel.toOffline(
          libraryItem!.album!,
          _downloaderController,
        );
        return offlineLibraryItem;
      }
      final album = await _musilyRepository.getAlbum(id);
      if (album == null) {
        return null;
      }
      final offlineAlbum = await AlbumModel.toOffline(
        album,
        _downloaderController,
      );
      return offlineAlbum;
    });
  }

  @override
  Future<List<AlbumEntity>> getAlbums(String query) async {
    return exec<List<AlbumEntity>>(() async {
      final albums = await _musilyRepository.searchAlbums(query);
      final offlineAlbums = <AlbumEntity>[];
      for (final album in albums) {
        final offilneAlbum = await AlbumModel.toOffline(
          album,
          _downloaderController,
        );
        offlineAlbums.add(offilneAlbum);
      }
      return offlineAlbums;
    });
  }
}
