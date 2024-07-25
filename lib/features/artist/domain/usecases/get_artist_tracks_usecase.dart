import 'package:musily/features/track/domain/entities/track_entity.dart';

abstract class GetArtistTracksUsecase {
  Future<List<TrackEntity>> exec(String artistId);
}
