import 'package:musily/features/player/domain/datasources/player_datasource.dart';
import 'package:musily/features/track/data/models/track_model.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';
import 'package:musily_repository/musily_repository.dart' as repo;

class PlayerDatasourceImpl implements PlayerDatasource {
  @override
  Future<List<TrackEntity>> getSmartQueue(List<TrackEntity> queue) async {
    try {
      final smartQueueTracks = await repo.getSmartQueue(
        [
          ...queue.map(
            (track) => TrackModel.toMap(track),
          ),
        ],
      );
      return [
        ...smartQueueTracks.map(
          (track) => TrackModel.fromMap(track),
        ),
      ];
    } catch (e) {
      print(e);
      return [];
    }
  }
}
