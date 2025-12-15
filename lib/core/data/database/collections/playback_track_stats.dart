import 'package:isar/isar.dart';

part 'playback_track_stats.g.dart';

@Collection()
class PlaybackTrackStats {
  Id id = Isar.autoIncrement;

  @Index()
  String trackId = '';

  String trackJson = '';

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

  static PlaybackTrackStats fromDateTime({
    required String trackId,
    required String trackJson,
    required DateTime date,
    required int secondsPlayed,
  }) {
    final stats = PlaybackTrackStats()
      ..trackId = trackId
      ..trackJson = trackJson
      ..year = date.year
      ..month = date.month
      ..yearMonthKey = getYearMonthKey(date)
      ..secondsPlayed = secondsPlayed
      ..playCount = 1;
    return stats;
  }
}
