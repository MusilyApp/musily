import 'package:musily/core/domain/datasources/base_datasource.dart';
import 'package:musily/core/domain/repositories/musily_repository.dart';
import 'package:musily/features/_library_module/domain/datasources/library_datasource.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/playlist/domain/datasources/playlist_datasource.dart';
import 'package:musily/features/playlist/domain/entities/playlist_entity.dart';

class PlaylistDatasourceImpl extends BaseDatasource
    implements PlaylistDatasource {
  late final LibraryDatasource _libraryDatasource;
  late final MusilyRepository _musilyRepository;

  PlaylistDatasourceImpl({
    required LibraryDatasource libraryDatasource,
    required DownloaderController downloaderController,
    required MusilyRepository musilyRepository,
  }) {
    _libraryDatasource = libraryDatasource;
    _musilyRepository = musilyRepository;
  }

  @override
  Future<PlaylistEntity?> getPlaylist(String id) async {
    return exec<PlaylistEntity?>(() async {
      final libraryItem = await _libraryDatasource.getLibraryItem(
        id,
      );
      if (libraryItem?.playlist != null) {
        return libraryItem!.playlist;
      }
      final playlist = await _musilyRepository.getPlaylist(id);
      return playlist;
    });
  }

  // TODO GET PLAYLISTS
  @override
  Future<List<PlaylistEntity>> getPlaylists(String query) {
    throw UnimplementedError();
  }
}
