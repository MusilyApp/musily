import 'package:musily/features/_library_module/domain/entities/library_item_entity.dart';
import 'package:musily/features/_library_module/domain/repositories/library_repository.dart';
import 'package:musily/features/_library_module/domain/usecases/merge_library_usecase.dart';

class MergeLibraryUsecaseImpl implements MergeLibraryUsecase {
  late final LibraryRepository _libraryRepository;

  MergeLibraryUsecaseImpl({
    required LibraryRepository libraryRepository,
  }) {
    _libraryRepository = libraryRepository;
  }

  @override
  Future<void> exec(List<LibraryItemEntity> items) async {
    return _libraryRepository.mergeLibrary(items);
  }
}
