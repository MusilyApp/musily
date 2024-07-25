import 'package:musily/features/album/domain/entities/album_entity.dart';

abstract class GetArtistSinglesUsecase {
  Future<List<AlbumEntity>> exec(String artistId);
}
