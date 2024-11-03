import 'package:isar/isar.dart';
part 'library.g.dart';

@collection
class Library {
  Id id = Isar.autoIncrement;
  String? musilyId;
  bool? anonymous;
  String? lastTimePlayed;
  bool? synced;
  String? value;
  String? createdAt;
}
