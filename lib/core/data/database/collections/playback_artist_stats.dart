import 'package:isar/isar.dart';

part 'playback_artist_stats.g.dart';

@Collection()
class PlaybackArtistStats {
  Id id = Isar.autoIncrement;

  @Index()
  String artistId = '';

  String artistJson = '';

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

  static PlaybackArtistStats fromDateTime({
    required String artistId,
    required String artistJson,
    required DateTime date,
    required int secondsPlayed,
  }) {
    final stats = PlaybackArtistStats()
      ..artistId = artistId
      ..artistJson = artistJson
      ..year = date.year
      ..month = date.month
      ..yearMonthKey = getYearMonthKey(date)
      ..secondsPlayed = secondsPlayed
      ..playCount = 1;
    return stats;
  }
}
