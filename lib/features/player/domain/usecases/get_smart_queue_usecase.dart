import 'package:musily/features/track/domain/entities/track_entity.dart';

abstract class GetSmartQueueUsecase {
  Future<List<TrackEntity>> exec(List<TrackEntity> queue);
}
