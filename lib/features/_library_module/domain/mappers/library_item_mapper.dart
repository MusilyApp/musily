import 'package:musily/features/_library_module/domain/entities/library_item_entity.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';

abstract class LibraryItemMapper<T> {
  LibraryItemEntity fromMap(
    Map<String, dynamic> map, {
    bool full = false,
  });
  Map<String, dynamic> toMap(T entity);
  Future<LibraryItemEntity> toOffline(
    LibraryItemEntity item,
    DownloaderController downloaderController,
  );
}
