import 'dart:convert';

import 'package:isar/isar.dart';
import 'package:musily/core/data/database/collections/library.dart';
import 'package:path_provider/path_provider.dart';

enum CollectionType {
  library,
}

class Database {
  static final Database _instance = Database._internal();
  factory Database() {
    return _instance;
  }
  Database._internal();

  late final Isar isar;
  Future<void> init() async {
    final databaseDirectory = await getApplicationSupportDirectory();
    isar = await Isar.open(
      [DatabaseLibrarySchema],
      directory: databaseDirectory.path,
    );
  }

  Future<void> put(
    CollectionType collection,
    Map<String, dynamic> value,
  ) async {
    await isar.writeTxn(() async {
      switch (collection) {
        case CollectionType.library:
          final existingItem = await isar.databaseLibrarys
              .filter()
              .musilyIdEqualTo(value['id'])
              .findFirst();
          if (existingItem != null) {
            final updatedItem = existingItem..value = jsonEncode(value);
            await isar.databaseLibrarys.put(updatedItem);
            return;
          }
          final newLibraryItem = DatabaseLibrary()
            ..musilyId = value['id']
            ..value = jsonEncode(value);
          await isar.databaseLibrarys.put(newLibraryItem);
          break;
      }
    });
  }

  Future<List<Map<String, dynamic>>> getAll(CollectionType collection) async {
    switch (collection) {
      case CollectionType.library:
        final items = await isar.databaseLibrarys.where().findAll();
        return items
            .map(
              (element) =>
                  (jsonDecode(element.value ?? '{}') as Map<String, dynamic>),
            )
            .toList();
    }
  }

  Future<List<Map<String, dynamic>>> getOffsetLimit(
      CollectionType collection, int offset, int limit) async {
    switch (collection) {
      case CollectionType.library:
        final items = await isar.databaseLibrarys
            .where()
            .offset(offset)
            .limit(limit)
            .findAll();
        return items
            .map(
              (element) =>
                  (jsonDecode(element.value ?? '{}') as Map<String, dynamic>),
            )
            .toList();
    }
  }

  Future<Map<String, dynamic>?> findById(
    CollectionType collection,
    String id,
  ) async {
    switch (collection) {
      case CollectionType.library:
        final filteredItem = await isar.databaseLibrarys
            .filter()
            .musilyIdEqualTo(id)
            .findFirst();
        if (filteredItem != null) {
          return jsonDecode(filteredItem.value ?? '{}') as Map<String, dynamic>;
        }
        return null;
    }
  }

  Future<void> findByIdAndDelete(
    CollectionType collection,
    String id,
  ) async {
    await isar.writeTxn(() async {
      switch (collection) {
        case CollectionType.library:
          final itemToDelete = await isar.databaseLibrarys
              .filter()
              .musilyIdEqualTo(id)
              .findFirst();
          if (itemToDelete != null) {
            await isar.databaseLibrarys.delete(itemToDelete.id!);
          }
      }
    });
  }
}
