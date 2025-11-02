import 'dart:convert';

import 'package:isar/isar.dart';
import 'package:musily/core/data/database/collections/database_library.dart';
import 'package:musily/core/data/database/collections/download_queue.dart';
import 'package:musily/core/data/database/collections/library.dart';
import 'package:musily/core/data/database/collections/user_tracks.dart';
import 'package:musily/core/data/services/user_service.dart';
import 'package:path_provider/path_provider.dart';

enum CollectionType {
  library,
  legacyLibrary,
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
      [
        LibrarySchema,
        DatabaseLibrarySchema,
        UserTracksSchema,
        DownloadQueueItemSchema,
      ],
      directory: databaseDirectory.path,
    );
  }

  Future<void> put(
    CollectionType collection,
    Map<String, dynamic> value,
  ) async {
    await isar.writeTxn(() async {
      final anonymous = !UserService.loggedIn;
      switch (collection) {
        case CollectionType.library:
          final existingItem = await isar.librarys
              .filter()
              .musilyIdEqualTo(value['id'])
              .findFirst();
          if (existingItem != null) {
            final updatedItem = existingItem
              ..value = jsonEncode(value)
              ..lastTimePlayed = value['lastTimePlayed']
              ..synced = value['synced']
              ..anonymous = anonymous
              ..createdAt = value['createdAt'];
            await isar.librarys.put(updatedItem);
            return;
          }
          final newLibraryItem = Library()
            ..musilyId = value['id']
            ..value = jsonEncode(value)
            ..synced = value['synced']
            ..anonymous = anonymous
            ..lastTimePlayed = value['lastTimePlayed']
            ..createdAt = value['createdAt'];
          await isar.librarys.put(newLibraryItem);
          break;
        case CollectionType.legacyLibrary:
          return;
      }
    });
  }

  Future<List<Map<String, dynamic>>> getAll(CollectionType collection) async {
    switch (collection) {
      case CollectionType.library:
        late final List<Library> items;
        if (UserService.loggedIn) {
          items = await isar.librarys
              .filter()
              .anonymousEqualTo(false)
              .sortByLastTimePlayedDesc()
              .findAll();
        } else {
          items = await isar.librarys
              .filter()
              .anonymousEqualTo(true)
              .sortByLastTimePlayedDesc()
              .findAll();
        }
        return [
          ...items.map(
            (element) =>
                (jsonDecode(element.value ?? '{}') as Map<String, dynamic>),
          ),
        ];
      case CollectionType.legacyLibrary:
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
        final items =
            await isar.librarys.where().offset(offset).limit(limit).findAll();
        return items
            .map(
              (element) =>
                  (jsonDecode(element.value ?? '{}') as Map<String, dynamic>),
            )
            .toList();
      case CollectionType.legacyLibrary:
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
        final filteredItem =
            await isar.librarys.filter().musilyIdEqualTo(id).findFirst();
        if (filteredItem != null) {
          return jsonDecode(filteredItem.value ?? '{}') as Map<String, dynamic>;
        }
        return null;
      case CollectionType.legacyLibrary:
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
          final itemsToDelete =
              await isar.librarys.filter().musilyIdEqualTo(id).findAll();
          for (final item in itemsToDelete) {
            isar.librarys.delete(item.id);
          }
        case CollectionType.legacyLibrary:
          final itemsToDelete = await isar.databaseLibrarys
              .filter()
              .musilyIdEqualTo(id)
              .findAll();
          for (final item in itemsToDelete) {
            isar.databaseLibrarys.delete(item.id!);
          }
      }
    });
  }
}
