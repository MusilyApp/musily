import 'package:musily/features/_library_module/domain/repositories/library_repository.dart';
import 'package:musily/features/_library_module/domain/usecases/delete_playlist_usecase.dart';

class DeletePlaylistUsecaseImpl implements DeletePlaylistUsecase {
  late final LibraryRepository _libraryRepository;

  DeletePlaylistUsecaseImpl({
    required LibraryRepository libraryRepository,
  }) {
    _libraryRepository = libraryRepository;
  }

  @override
  Future<void> exec(String playlistId) async {
    await _libraryRepository.deletePlaylist(playlistId);
  }
}
