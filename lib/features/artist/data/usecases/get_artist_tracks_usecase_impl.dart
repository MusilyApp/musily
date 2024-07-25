import 'package:musily/features/artist/domain/repositories/artist_repository.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';

class GetArtistTracksUsecaseImpl implements GetArtistTracksUsecase {
  final ArtistRepository artistRepository;
  GetArtistTracksUsecaseImpl({
    required this.artistRepository,
  });
  @override
  Future<List<TrackEntity>> exec(String artistId) async {
    final tracks = await artistRepository.getArtistTracks(artistId);
    return tracks;
  }
}
