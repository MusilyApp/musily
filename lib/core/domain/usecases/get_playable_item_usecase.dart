import 'package:musily/features/track/domain/entities/track_entity.dart';

abstract class GetPlayableItemUsecase {
  Future<TrackEntity> exec(
    TrackEntity track,
  );
}
