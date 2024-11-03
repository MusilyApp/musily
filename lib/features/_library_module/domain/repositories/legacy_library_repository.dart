import 'package:musily/features/_library_module/domain/entities/legacy_library_item_entity.dart';

abstract class LegacyLibraryRepository {
  Future<List<LegacyLibraryItemEntity<dynamic>>> getLibrary();
  Future<List<LegacyLibraryItemEntity<dynamic>>> getLibraryOffsetLimit(
    int offset,
    int limit,
  );
  Future<LegacyLibraryItemEntity<T>?> getLibraryItem<T>(String id);
  Future<void> deleteLibraryItem(String id);
  Future<void> addToLibrary<T>(T item);
  Future<void> updateLibraryItem<T>(String id, LegacyLibraryItemEntity<T> item);
}
