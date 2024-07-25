import 'package:musily/features/_library_module/domain/entities/library_item_entity.dart';
import 'package:musily/features/_library_module/domain/repositories/library_repository.dart';
import 'package:musily/features/_library_module/domain/usecases/get_library_items_usecase.dart';

class GetLibraryItemsUsecaseImpl implements GetLibraryItemsUsecase {
  late final LibraryRepository _libraryRepository;

  GetLibraryItemsUsecaseImpl({required LibraryRepository libraryRepository}) {
    _libraryRepository = libraryRepository;
  }

  @override
  Future<List<LibraryItemEntity>> exec() async {
    final items = await _libraryRepository.getLibrary();
    return items;
  }
}
