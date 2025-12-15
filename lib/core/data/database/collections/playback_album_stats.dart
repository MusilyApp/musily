import 'package:isar/isar.dart';

part 'playback_album_stats.g.dart';

@Collection()
class PlaybackAlbumStats {
  Id id = Isar.autoIncrement;

  @Index()
  String albumId = '';

  String albumJson = '';

  @Index()
  int year = 0;

  @Index()
  int month = 0;

  @Index()
  int yearMonthKey = 0;

  int secondsPlayed = 0;
  int playCount = 0;

  static int getYearMonthKey(DateTime date) {
    return date.year * 100 + date.month;
  }

  static PlaybackAlbumStats fromDateTime({
    required String albumId,
    required String albumJson,
    required DateTime date,
    required int secondsPlayed,
  }) {
    final stats = PlaybackAlbumStats()
      ..albumId = albumId
      ..albumJson = albumJson
      ..year = date.year
      ..month = date.month
      ..yearMonthKey = getYearMonthKey(date)
      ..secondsPlayed = secondsPlayed
      ..playCount = 1;
    return stats;
  }
}
