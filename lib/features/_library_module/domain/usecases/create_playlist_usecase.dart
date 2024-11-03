import 'package:musily/features/_library_module/data/dtos/create_playlist_dto.dart';
import 'package:musily/features/playlist/domain/entities/playlist_entity.dart';

abstract class CreatePlaylistUsecase {
  Future<PlaylistEntity> exec(CreatePlaylistDTO data);
}
