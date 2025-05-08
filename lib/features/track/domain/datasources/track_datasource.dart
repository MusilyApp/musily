import 'package:dart_ytmusic_api/dart_ytmusic_api.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';

abstract class TrackDatasource {
  Future<List<TrackEntity>> getTracks(String query);
  Future<TrackEntity?> getTrack(String id);
  Future<String?> getTrackLyrics(String id);
  Future<TimedLyricsRes?> getTimedLyrics(String id);
}
