import 'package:musily/features/artist/domain/entitites/artist_entity.dart';

abstract class AddArtistToLibraryUsecase {
  Future<void> exec(ArtistEntity artist);
}
