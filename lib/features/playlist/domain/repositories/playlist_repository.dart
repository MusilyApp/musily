import 'package:musily/features/playlist/domain/entities/playlist_entity.dart';

abstract class PlaylistRepository {
  Future<List<PlaylistEntity>> getPlaylists(String query);
  Future<PlaylistEntity?> getPlaylist(String id);
}
