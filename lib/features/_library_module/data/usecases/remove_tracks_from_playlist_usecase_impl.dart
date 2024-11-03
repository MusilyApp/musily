import 'package:musily/features/_library_module/domain/repositories/library_repository.dart';
import 'package:musily/features/_library_module/domain/usecases/remove_tracks_from_playlist_usecase.dart';

class RemoveTracksFromPlaylistUsecaseImpl
    implements RemoveTracksFromPlaylistUsecase {
  late final LibraryRepository _libraryRepository;

  RemoveTracksFromPlaylistUsecaseImpl({
    required LibraryRepository libraryRepository,
  }) {
    _libraryRepository = libraryRepository;
  }

  @override
  Future<void> exec(String playlistId, List<String> trackIds) async {
    await _libraryRepository.removeTracksFromPlaylist(playlistId, trackIds);
  }
}
