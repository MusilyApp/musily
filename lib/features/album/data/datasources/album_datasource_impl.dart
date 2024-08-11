import 'package:musily/features/_library_module/domain/datasources/library_datasource.dart';
import 'package:musily/features/album/data/models/album_model.dart';
import 'package:musily/features/album/domain/datasources/album_datasource.dart';
import 'package:musily/features/album/domain/entities/album_entity.dart';
import 'package:musily_player/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily_repository/musily_repository.dart' as repo;

class AlbumDatasourceImpl implements AlbumDatasource {
  final DownloaderController downloaderController;
  final LibraryDatasource libraryDatasource;

  AlbumDatasourceImpl({
    required this.downloaderController,
    required this.libraryDatasource,
  });

  @override
  Future<AlbumEntity?> getAlbum(String id) async {
    try {
      final libraryItem = await libraryDatasource.getLibraryItem<AlbumEntity>(
        id,
      );
      if (libraryItem != null) {
        final offlineLibraryItem = await AlbumModel.toOffline(
          libraryItem.value,
          downloaderController,
        );
        return offlineLibraryItem;
      }
      final data = await repo.getAlbumInfo(id);
      final album = AlbumModel.fromMap(data);
      final offlineAlbum = await AlbumModel.toOffline(
        album,
        downloaderController,
      );
      return offlineAlbum;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<AlbumEntity>> getAlbums(String query) async {
    try {
      final data = await repo.getAlbums(query);
      final albums =
          (data as List).map((element) => AlbumModel.fromMap(element)).toList();
      final offlineAlbums = <AlbumEntity>[];
      for (final album in albums) {
        final offilneAlbum = await AlbumModel.toOffline(
          album,
          downloaderController,
        );
        offlineAlbums.add(offilneAlbum);
      }
      return offlineAlbums;
    } catch (e) {
      return [];
    }
  }
}
