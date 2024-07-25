import 'package:musily/features/playlist/domain/entities/playlist_entity.dart';

abstract class GetPlaylistUsecase {
  Future<PlaylistEntity?> exec(String id);
}
