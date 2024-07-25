import 'package:musily/features/_library_module/domain/entities/library_item_entity.dart';

abstract class GetLibraryOffsetLimitUsecase {
  Future<List<LibraryItemEntity>> exec(
    int offset,
    int limit,
  );
}
