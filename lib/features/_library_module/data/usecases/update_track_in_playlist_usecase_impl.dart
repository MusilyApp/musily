import 'package:musily/features/_library_module/domain/repositories/library_repository.dart';
import 'package:musily/features/_library_module/domain/usecases/update_track_in_playlist_usecase.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';

class UpdateTrackInPlaylistUsecaseImpl implements UpdateTrackInPlaylistUsecase {
  late final LibraryRepository _libraryRepository;

  UpdateTrackInPlaylistUsecaseImpl({
    required LibraryRepository libraryRepository,
  }) {
    _libraryRepository = libraryRepository;
  }

  @override
  Future<void> exec(
    String playlistId,
    String trackId,
    TrackEntity updatedTrack,
  ) async {
    return await _libraryRepository.updateTrackInPlaylist(
      playlistId,
      trackId,
      updatedTrack,
    );
  }
}
