import 'package:musily/features/artist/domain/entitites/artist_entity.dart';

abstract class GetArtistUsecase {
  Future<ArtistEntity?> exec(String id);
}
