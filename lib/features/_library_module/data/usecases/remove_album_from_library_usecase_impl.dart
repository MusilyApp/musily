import 'package:musily/features/_library_module/domain/repositories/library_repository.dart';
import 'package:musily/features/_library_module/domain/usecases/remove_album_from_library_usecase.dart';

class RemoveAlbumFromLibraryUsecaseImpl
    implements RemoveAlbumFromLibraryUsecase {
  late final LibraryRepository _libraryRepository;

  RemoveAlbumFromLibraryUsecaseImpl({
    required LibraryRepository libraryRepository,
  }) {
    _libraryRepository = libraryRepository;
  }

  @override
  Future<void> exec(String albumId) async {
    await _libraryRepository.removeAlbumFromLibrary(albumId);
  }
}
