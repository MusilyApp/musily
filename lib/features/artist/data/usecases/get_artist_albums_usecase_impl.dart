import 'package:musily/features/album/domain/entities/album_entity.dart';
import 'package:musily/features/artist/domain/repositories/artist_repository.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';

class GetArtistAlbumsUsecaseImpl implements GetArtistAlbumsUsecase {
  final ArtistRepository artistRepository;

  GetArtistAlbumsUsecaseImpl({
    required this.artistRepository,
  });

  @override
  Future<List<AlbumEntity>> exec(String artistId) async {
    final albums = await artistRepository.getArtistAlbums(artistId);
    return albums;
  }
}
