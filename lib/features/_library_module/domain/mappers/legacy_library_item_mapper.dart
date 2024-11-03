import 'package:musily/features/_library_module/domain/entities/legacy_library_item_entity.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';

abstract class LegacyLibraryItemMapper<T> {
  LegacyLibraryItemEntity<T> fromMap(
    Map<String, dynamic> map, {
    bool full = false,
  });
  Map<String, dynamic> toMap(T entity);
  Future<LegacyLibraryItemEntity<T>> toOffline(
    LegacyLibraryItemEntity<T> item,
    DownloaderController downloaderController,
  );
}
