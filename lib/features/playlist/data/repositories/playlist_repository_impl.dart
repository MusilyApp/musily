import 'package:musily/features/playlist/domain/datasources/playlist_datasource.dart';
import 'package:musily/features/playlist/domain/entities/playlist_entity.dart';
import 'package:musily/features/playlist/domain/repositories/playlist_repository.dart';

class PlaylistRepositoryImpl implements PlaylistRepository {
  final PlaylistDatasource playlistDatasource;
  PlaylistRepositoryImpl({
    required this.playlistDatasource,
  });

  @override
  Future<PlaylistEntity?> getPlaylist(String id) async {
    final playlist = await playlistDatasource.getPlaylist(id);
    return playlist;
  }

  @override
  Future<List<PlaylistEntity>> getPlaylists(String query) async {
    final playlists = await playlistDatasource.getPlaylists(query);
    return playlists;
  }
}
