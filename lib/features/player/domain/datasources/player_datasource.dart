import 'package:musily/features/track/domain/entities/track_entity.dart';

abstract class PlayerDatasource {
  Future<List<TrackEntity>> getSmartQueue(List<TrackEntity> queue);
}
