import 'package:musily/features/album/domain/entities/album_entity.dart';

abstract class GetArtistAlbumsUsecase {
  Future<List<AlbumEntity>> exec(String artistId);
}
