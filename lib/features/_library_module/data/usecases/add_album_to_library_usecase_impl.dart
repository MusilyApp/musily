import 'package:musily/features/_library_module/domain/entities/library_item_entity.dart';
import 'package:musily/features/_library_module/domain/repositories/library_repository.dart';
import 'package:musily/features/_library_module/domain/usecases/add_album_to_library_usecase.dart';
import 'package:musily/features/album/domain/entities/album_entity.dart';

class AddAlbumToLibraryUsecaseImpl implements AddAlbumToLibraryUsecase {
  late final LibraryRepository _libraryRepository;

  AddAlbumToLibraryUsecaseImpl({
    required LibraryRepository libraryRepository,
  }) {
    _libraryRepository = libraryRepository;
  }

  @override
  Future<LibraryItemEntity> exec(AlbumEntity album) async {
    final item = await _libraryRepository.addAlbumToLibrary(album);
    return item;
  }
}
