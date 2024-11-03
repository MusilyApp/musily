import 'package:musily/features/_library_module/domain/repositories/library_repository.dart';
import 'package:musily/features/_library_module/domain/usecases/remove_artist_from_library_usecase.dart';

class RemoveArtistFromLibraryUsecaseImpl
    implements RemoveArtistFromLibraryUsecase {
  late final LibraryRepository _libraryRepository;

  RemoveArtistFromLibraryUsecaseImpl({
    required LibraryRepository libraryRepository,
  }) {
    _libraryRepository = libraryRepository;
  }

  @override
  Future<void> exec(String artistId) async {
    return await _libraryRepository.removeArtistFromLibrary(artistId);
  }
}
