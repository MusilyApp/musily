import 'package:musily/features/_library_module/domain/repositories/library_repository.dart';
import 'package:musily/features/_library_module/domain/usecases/delete_library_item_usecase.dart';

class DeleteLibraryItemUsecaseImpl implements DeleteLibraryItemUsecase {
  late final LibraryRepository _libraryRepository;

  DeleteLibraryItemUsecaseImpl({
    required LibraryRepository libraryRepository,
  }) {
    _libraryRepository = libraryRepository;
  }

  @override
  Future<void> exec(String id) async {
    await _libraryRepository.deleteLibraryItem(id);
  }
}
