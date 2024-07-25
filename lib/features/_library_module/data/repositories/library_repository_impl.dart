import 'package:musily/features/_library_module/domain/datasources/library_datasource.dart';
import 'package:musily/features/_library_module/domain/entities/library_item_entity.dart';
import 'package:musily/features/_library_module/domain/repositories/library_repository.dart';

class LibraryRepositoryImpl implements LibraryRepository {
  late final LibraryDatasource _libraryDatasource;
  LibraryRepositoryImpl({
    required LibraryDatasource libraryDatasource,
  }) {
    _libraryDatasource = libraryDatasource;
  }
  @override
  Future<void> deleteLibraryItem(String id) async {
    await _libraryDatasource.deleteLibraryItem(id);
  }

  @override
  Future<List<LibraryItemEntity>> getLibrary() async {
    final items = await _libraryDatasource.getLibrary();
    return items;
  }

  @override
  Future<LibraryItemEntity<T>?> getLibraryItem<T>(String id) async {
    final item = await _libraryDatasource.getLibraryItem<T>(id);
    return item;
  }

  @override
  Future<void> addToLibrary<T>(T item) async {
    await _libraryDatasource.addToLibrary(item);
  }

  @override
  Future<void> updateLibraryItem<T>(
    String id,
    LibraryItemEntity<T> item,
  ) async {
    await _libraryDatasource.updateLibraryItem(id, item);
  }

  @override
  Future<List<LibraryItemEntity>> getLibraryOffsetLimit(
    int offset,
    int limit,
  ) async {
    final items = _libraryDatasource.getLibraryOffsetLimit(offset, limit);
    return items;
  }
}
