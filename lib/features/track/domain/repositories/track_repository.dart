import 'package:musily/features/track/domain/entities/track_entity.dart';

abstract class TrackRepository {
  Future<List<TrackEntity>> getTracks(String query);
  Future<TrackEntity?> getTrack(String id);
}
