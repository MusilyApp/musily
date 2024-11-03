import 'package:musily/features/_library_module/domain/entities/library_item_entity.dart';

abstract class GetLibraryItemUsecase {
  Future<LibraryItemEntity?> exec(String itemId);
}
