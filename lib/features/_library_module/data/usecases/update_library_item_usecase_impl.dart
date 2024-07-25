import 'package:musily/features/_library_module/domain/entities/library_item_entity.dart';
import 'package:musily/features/_library_module/domain/repositories/library_repository.dart';
import 'package:musily/features/_library_module/domain/usecases/update_library_item_usecase.dart';

class UpdateLibraryItemUsecaseImpl implements UpdateLibraryItemUsecase {
  late final LibraryRepository _libraryRepository;

  UpdateLibraryItemUsecaseImpl({
    required LibraryRepository libraryRepository,
  }) {
    _libraryRepository = libraryRepository;
  }

  @override
  Future<void> exec<T>(String id, LibraryItemEntity<T> updatedItem) async {
    await _libraryRepository.updateLibraryItem(id, updatedItem);
  }
}
