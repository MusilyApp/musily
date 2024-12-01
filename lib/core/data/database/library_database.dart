import 'dart:convert';

import 'package:isar/isar.dart';
import 'package:musily/core/data/database/collections/library.dart';
import 'package:musily/core/data/database/database.dart';
import 'package:musily/core/data/services/user_service.dart';
import 'package:musily/core/domain/adapters/database_adapter.dart';

class LibraryDatabase implements DatabaseModelAdapter {
  late final Database _database = Database();

  @override
  Future<Map<String, dynamic>?> findById(String id) async {
    final result = await _database.findById(CollectionType.library, id);
    return result;
  }

  @override
  Future<void> findByIdAndDelete(String id) async {
    await _database.findByIdAndDelete(CollectionType.library, id);
  }

  @override
  Future<List<Map<String, dynamic>>> getAll() async {
    final items = await _database.getAll(CollectionType.library);
    return items;
  }

  @override
  Future<void> put(Map<String, dynamic> value) async {
    await _database.put(CollectionType.library, value);
  }

  @override
  Future<List<Map<String, dynamic>>> getOffsetLimit(
    int offset,
    int limit,
  ) async {
    final items = await _database.getOffsetLimit(
      CollectionType.library,
      offset,
      limit,
    );
    return items;
  }

  Future<void> cleanCloudLibrary() async {
    _database.isar.writeTxn(() async {
      await _database.isar.librarys
          .filter()
          .anonymousEqualTo(false)
          .or()
          .anonymousIsNull()
          .deleteAll();
    });
  }

  @override
  Future<void> putMany(List<Map<String, dynamic>> items) async {
    _database.isar.writeTxn(() async {
      final anonymous = !UserService.loggedIn;

      await _database.isar.librarys.putAll([
        ...items.map(
          (e) => Library()
            ..musilyId = e['id']
            ..value = jsonEncode(e)
            ..synced = e['synced']
            ..anonymous = anonymous
            ..lastTimePlayed = e['lasTimePlayed']
            ..createdAt = e['createdAt'],
        )
      ]);
    });
  }
}
