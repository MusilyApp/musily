import 'package:musily/features/_library_module/data/dtos/update_playlist_dto.dart';
import 'package:musily/features/playlist/domain/entities/playlist_entity.dart';

abstract class UpdatePlaylistUsecase {
  Future<PlaylistEntity?> exec(
    UpdatePlaylistDto data,
  );
}
