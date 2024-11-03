import 'package:musily/features/_library_module/domain/repositories/library_repository.dart';
import 'package:musily/features/_library_module/domain/usecases/add_artist_to_library_usecase.dart';
import 'package:musily/features/artist/domain/entitites/artist_entity.dart';

class AddArtistToLibraryUsecaseImpl implements AddArtistToLibraryUsecase {
  late final LibraryRepository _libraryRepository;

  AddArtistToLibraryUsecaseImpl({
    required LibraryRepository libraryRepository,
  }) {
    _libraryRepository = libraryRepository;
  }

  @override
  Future<void> exec(ArtistEntity artist) async {
    await _libraryRepository.addArtistToLibrary(artist);
  }
}
