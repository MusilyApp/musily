import 'package:musily/features/_library_module/domain/entities/library_item_entity.dart';

abstract class GetLibraryItemsUsecase {
  Future<List<LibraryItemEntity>> exec();
}
