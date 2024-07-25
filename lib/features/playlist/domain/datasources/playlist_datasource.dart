import 'package:musily/features/playlist/domain/entities/playlist_entity.dart';

abstract class PlaylistDatasource {
  Future<List<PlaylistEntity>> getPlaylists(String query);
  Future<PlaylistEntity?> getPlaylist(String id);
}
