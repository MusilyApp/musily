import 'package:isar/isar.dart';
part 'database_library.g.dart';

enum LibraryType {
  album,
  playlist,
  artist,
}

@collection
class DatabaseLibrary {
  Id? id;
  String? musilyId;
  @enumerated
  LibraryType type = LibraryType.album;
  String? value;
}
