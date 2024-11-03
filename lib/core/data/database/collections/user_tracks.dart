import 'package:isar/isar.dart';
part 'user_tracks.g.dart';

@collection
class UserTracks {
  Id id = Isar.autoIncrement;
  String musilyId = '';
  String libraryItemId = '';
  String hash = '';
  String userId = 'anonymous';
  int orderIndex = 1;
  String highResImg = '';
  String lowResImg = '';
  String title = '';
  String albumId = '';
  String albumTitle = '';
  String artistId = '';
  String artistName = '';
  int duration = 0;
  DateTime createdAt = DateTime.now();
}
