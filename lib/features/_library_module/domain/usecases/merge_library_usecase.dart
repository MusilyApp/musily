import 'package:musily/features/_library_module/domain/entities/library_item_entity.dart';

abstract class MergeLibraryUsecase {
  Future<void> exec(List<LibraryItemEntity> items);
}
