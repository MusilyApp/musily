import 'package:musily/features/_library_module/domain/entities/library_item_entity.dart';

abstract class LibraryRepository {
  Future<List<LibraryItemEntity<dynamic>>> getLibrary();
  Future<List<LibraryItemEntity<dynamic>>> getLibraryOffsetLimit(
    int offset,
    int limit,
  );
  Future<LibraryItemEntity<T>?> getLibraryItem<T>(String id);
  Future<void> deleteLibraryItem(String id);
  Future<void> addToLibrary<T>(T item);
  Future<void> updateLibraryItem<T>(String id, LibraryItemEntity<T> item);
}
