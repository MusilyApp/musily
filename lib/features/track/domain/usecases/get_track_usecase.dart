import 'package:musily/features/track/domain/entities/track_entity.dart';

abstract class GetTrackUsecase {
  Future<TrackEntity?> exec(String id);
}
