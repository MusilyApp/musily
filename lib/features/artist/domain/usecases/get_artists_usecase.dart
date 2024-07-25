import 'package:musily/features/artist/domain/entitites/artist_entity.dart';

abstract class GetArtistsUsecase {
  Future<List<ArtistEntity>> exec(String query);
}
