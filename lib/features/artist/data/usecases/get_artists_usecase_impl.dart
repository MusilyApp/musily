import 'package:musily/features/artist/domain/entitites/artist_entity.dart';
import 'package:musily/features/artist/domain/repositories/artist_repository.dart';
import 'package:musily/features/artist/domain/usecases/get_artists_usecase.dart';

class GetArtistsUsecaseImpl implements GetArtistsUsecase {
  final ArtistRepository artistRepository;
  GetArtistsUsecaseImpl({
    required this.artistRepository,
  });

  @override
  Future<List<ArtistEntity>> exec(String query) async {
    final artists = await artistRepository.getArtists(query);
    return artists;
  }
}
