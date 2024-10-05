import 'package:musily/features/_library_module/domain/datasources/library_datasource.dart';
import 'package:musily/features/album/data/models/album_model.dart';
import 'package:musily/features/album/domain/datasources/album_datasource.dart';
import 'package:musily/features/album/domain/entities/album_entity.dart';
import 'package:musily_player/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily_repository/features/data_fetch/data/mappers/album_mapper.dart';
import 'package:musily_repository/features/data_fetch/data/mappers/simplified_album_mapper.dart';
import 'package:musily_repository/features/data_fetch/data/repositories/musily_repository.dart';

class AlbumDatasourceImpl implements AlbumDatasource {
  final DownloaderController downloaderController;
  final LibraryDatasource libraryDatasource;

  AlbumDatasourceImpl({
    required this.downloaderController,
    required this.libraryDatasource,
  });

  @override
  Future<AlbumEntity?> getAlbum(String id) async {
    final musilyRepository = MusilyRepository();
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
      final data = await musilyRepository.getAlbum(id);
      if (data == null) {
        return null;
      }
      final album = AlbumModel.fromMap(
        AlbumMapper().toMap(
          data,
        ),
      );
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
      final musilyRepository = MusilyRepository();
      final data = await musilyRepository.searchAlbums(query);
      final albums = data
          .map(
            (element) => AlbumModel.fromMap(
              SimplifiedAlbumMapper().toMap(
                element,
              ),
            ),
          )
          .toList();
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
