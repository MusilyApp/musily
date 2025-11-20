import 'package:musily/features/track/domain/entities/track_entity.dart';

abstract class GetUpNextUsecase {
  Future<List<TrackEntity>> exec(TrackEntity track);
}
