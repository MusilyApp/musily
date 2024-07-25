import 'package:musily/features/track/domain/entities/track_entity.dart';

abstract class GetTracksUsecase {
  Future<List<TrackEntity>> exec(String query);
}
