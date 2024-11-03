import 'package:musily/features/_library_module/domain/entities/library_item_entity.dart';
import 'package:musily/features/album/domain/entities/album_entity.dart';

abstract class AddAlbumToLibraryUsecase {
  Future<LibraryItemEntity> exec(AlbumEntity album);
}
