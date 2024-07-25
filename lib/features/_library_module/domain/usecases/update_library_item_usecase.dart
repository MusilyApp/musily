import 'package:musily/features/_library_module/domain/entities/library_item_entity.dart';

abstract class UpdateLibraryItemUsecase {
  Future<void> exec<T>(
    String id,
    LibraryItemEntity<T> updatedItem,
  );
}
