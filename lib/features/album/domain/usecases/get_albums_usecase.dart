import 'package:musily/features/album/domain/entities/album_entity.dart';

abstract class GetAlbumsUsecase {
  Future<List<AlbumEntity>> exec(String query);
}
