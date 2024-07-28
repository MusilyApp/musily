import 'package:musily/features/_library_module/domain/entities/library_item_entity.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';

abstract class LibraryItemMapper<T> {
  LibraryItemEntity<T> fromMap(
    Map<String, dynamic> map, {
    bool full = false,
  });
  Map<String, dynamic> toMap(T entity);
  Future<LibraryItemEntity<T>> toOffline(
    LibraryItemEntity<T> item,
    DownloaderController downloaderController,
  );
}
