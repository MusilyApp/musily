import 'package:musily/core/data/database/database.dart';
import 'package:musily/core/domain/adapters/database_adapter.dart';

class LegacyLibraryDatabase implements DatabaseModelAdapter {
  final Database _database = Database();

  @override
  Future<Map<String, dynamic>?> findById(String id) async {
    final result = await _database.findById(CollectionType.legacyLibrary, id);
    return result;
  }

  @override
  Future<void> findByIdAndDelete(String id) async {
    await _database.findByIdAndDelete(CollectionType.legacyLibrary, id);
  }

  @override
  Future<List<Map<String, dynamic>>> getAll() async {
    final items = await _database.getAll(CollectionType.legacyLibrary);
    return items;
  }

  @override
  Future<void> put(Map<String, dynamic> value) async {
    await _database.put(CollectionType.legacyLibrary, value);
  }

  @override
  Future<List<Map<String, dynamic>>> getOffsetLimit(
    int offset,
    int limit,
  ) async {
    final items = await _database.getOffsetLimit(
      CollectionType.legacyLibrary,
      offset,
      limit,
    );
    return items;
  }
}
