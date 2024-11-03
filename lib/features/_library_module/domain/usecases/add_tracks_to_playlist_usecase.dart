import 'package:musily/features/track/domain/entities/track_entity.dart';

abstract class AddTracksToPlaylistUsecase {
  Future<void> exec(String playlistId, List<TrackEntity> tracks);
}
