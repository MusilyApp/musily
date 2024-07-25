import 'package:musily/features/album/domain/entities/album_entity.dart';

abstract class GetAlbumUsecase {
  Future<AlbumEntity?> exec(String id);
}
