import 'package:musily/features/artist/domain/entitites/artist_entity.dart';
import 'package:musily/features/artist/domain/repositories/artist_repository.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';

class GetArtistUsecaseImpl implements GetArtistUsecase {
  final ArtistRepository artistRepository;
  GetArtistUsecaseImpl({
    required this.artistRepository,
  });

  @override
  Future<ArtistEntity?> exec(String id) async {
    final artist = await artistRepository.getArtist(id);
    return artist;
  }
}
