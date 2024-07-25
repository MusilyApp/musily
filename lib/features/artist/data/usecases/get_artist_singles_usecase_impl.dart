import 'package:musily/features/album/domain/entities/album_entity.dart';
import 'package:musily/features/artist/domain/repositories/artist_repository.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';

class GetArtistSinglesUsecaseImpl implements GetArtistSinglesUsecase {
  final ArtistRepository artistRepository;

  GetArtistSinglesUsecaseImpl({
    required this.artistRepository,
  });

  @override
  Future<List<AlbumEntity>> exec(String artistId) async {
    final singles = await artistRepository.getArtistSingles(artistId);
    return singles;
  }
}
