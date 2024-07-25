import 'package:musily/features/_library_module/domain/repositories/library_repository.dart';
import 'package:musily/features/_library_module/domain/usecases/add_to_library_usecase.dart';

class AddToLibraryUsecaseImpl implements AddToLibraryUsecase {
  late final LibraryRepository _libraryRepository;
  AddToLibraryUsecaseImpl({required LibraryRepository libraryRepository}) {
    _libraryRepository = libraryRepository;
  }
  @override
  Future<void> exec<T>(T item) async {
    await _libraryRepository.addToLibrary(item);
  }
}
