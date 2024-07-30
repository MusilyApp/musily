import 'package:musily/features/track/domain/entities/track_entity.dart';

abstract class PlayerRepository {
  Future<List<TrackEntity>> getSmartQueue(List<TrackEntity> queue);
}
