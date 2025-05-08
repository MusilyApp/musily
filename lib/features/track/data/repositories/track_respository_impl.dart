import 'package:dart_ytmusic_api/types.dart';
import 'package:musily/features/track/domain/datasources/track_datasource.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';
import 'package:musily/features/track/domain/repositories/track_repository.dart';

class TrackRespositoryImpl implements TrackRepository {
  final TrackDatasource trackDatasource;
  TrackRespositoryImpl({
    required this.trackDatasource,
  });
  @override
  Future<TrackEntity?> getTrack(String id) async {
    final track = await trackDatasource.getTrack(id);
    return track;
  }

  @override
  Future<List<TrackEntity>> getTracks(String query) async {
    final tracks = await trackDatasource.getTracks(query);
    return tracks;
  }

  @override
  Future<String?> getTrackLyrics(String id) async {
    final lyrics = await trackDatasource.getTrackLyrics(id);
    return lyrics;
  }

  @override
  Future<TimedLyricsRes?> getTimedLyrics(String id) {
    final timedLyrics = trackDatasource.getTimedLyrics(id);
    return timedLyrics;
  }
}
