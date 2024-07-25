import 'package:musily/features/_library_module/domain/entities/library_item_entity.dart';
import 'package:musily/features/_library_module/domain/repositories/library_repository.dart';
import 'package:musily/features/_library_module/domain/usecases/get_library_item_usecase.dart';

class GetLibraryItemUsecaseImpl implements GetLibraryItemUsecase {
  late final LibraryRepository _libraryRepository;

  GetLibraryItemUsecaseImpl({
    required LibraryRepository libraryRepository,
  }) {
    _libraryRepository = libraryRepository;
  }
  @override
  Future<LibraryItemEntity<T>?> exec<T>(String id) async {
    final item = await _libraryRepository.getLibraryItem<T>(id);
    return item;
  }
}
