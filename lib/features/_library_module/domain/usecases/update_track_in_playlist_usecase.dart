import 'package:musily/features/track/domain/entities/track_entity.dart';

abstract class UpdateTrackInPlaylistUsecase {
  Future<void> exec(
    String playlistId,
    String trackId,
    TrackEntity updatedTrack,
  );
}
