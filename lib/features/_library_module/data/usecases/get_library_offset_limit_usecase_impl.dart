import 'package:musily/features/_library_module/domain/entities/library_item_entity.dart';
import 'package:musily/features/_library_module/domain/repositories/library_repository.dart';
import 'package:musily/features/_library_module/domain/usecases/get_library_offset_limit_usecase.dart';

class GetLibraryOffsetLimitUsecaseImpl implements GetLibraryOffsetLimitUsecase {
  final LibraryRepository libraryRepository;
  GetLibraryOffsetLimitUsecaseImpl({
    required this.libraryRepository,
  });

  @override
  Future<List<LibraryItemEntity>> exec(int offset, int limit) async {
    final items = await libraryRepository.getLibraryOffsetLimit(
      offset,
      limit,
    );
    return items;
  }
}
