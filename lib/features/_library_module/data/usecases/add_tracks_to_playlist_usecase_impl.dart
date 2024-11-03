import 'package:musily/features/_library_module/domain/repositories/library_repository.dart';
import 'package:musily/features/_library_module/domain/usecases/add_tracks_to_playlist_usecase.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';

class AddTracksToPlaylistUsecaseImpl implements AddTracksToPlaylistUsecase {
  late final LibraryRepository _libraryRepository;

  AddTracksToPlaylistUsecaseImpl({
    required LibraryRepository libraryRepository,
  }) {
    _libraryRepository = libraryRepository;
  }

  @override
  Future<void> exec(String playlistId, List<TrackEntity> tracks) async {
    await _libraryRepository.addTracksToPlaylist(playlistId, tracks);
  }
}
