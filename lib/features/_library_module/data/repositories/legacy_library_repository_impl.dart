import 'package:musily/features/_library_module/domain/datasources/legacy_library_datasource.dart';
import 'package:musily/features/_library_module/domain/entities/legacy_library_item_entity.dart';
import 'package:musily/features/_library_module/domain/repositories/legacy_library_repository.dart';

class LegacyLibraryRepositoryImpl implements LegacyLibraryRepository {
  late final LegacyLibraryDatasource _legacyLibraryDatasource;
  LegacyLibraryRepositoryImpl({
    required LegacyLibraryDatasource legacyLibraryDatasource,
  }) {
    _legacyLibraryDatasource = legacyLibraryDatasource;
  }
  @override
  Future<void> deleteLibraryItem(String id) async {
    await _legacyLibraryDatasource.deleteLibraryItem(id);
  }

  @override
  Future<List<LegacyLibraryItemEntity>> getLibrary() async {
    final items = await _legacyLibraryDatasource.getLibrary();
    return items;
  }

  @override
  Future<LegacyLibraryItemEntity<T>?> getLibraryItem<T>(String id) async {
    final item = await _legacyLibraryDatasource.getLibraryItem<T>(id);
    return item;
  }

  @override
  Future<void> addToLibrary<T>(T item) async {
    await _legacyLibraryDatasource.addToLibrary(item);
  }

  @override
  Future<void> updateLibraryItem<T>(
    String id,
    LegacyLibraryItemEntity<T> item,
  ) async {
    await _legacyLibraryDatasource.updateLibraryItem(id, item);
  }

  @override
  Future<List<LegacyLibraryItemEntity>> getLibraryOffsetLimit(
    int offset,
    int limit,
  ) async {
    final items = _legacyLibraryDatasource.getLibraryOffsetLimit(offset, limit);
    return items;
  }
}
