import 'package:musily/features/player/domain/datasources/player_datasource.dart';
import 'package:musily/features/track/data/models/track_model.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';
import 'package:musily_repository/features/data_fetch/data/mappers/track_mapper.dart';
import 'package:musily_repository/musily_repository.dart';

class PlayerDatasourceImpl implements PlayerDatasource {
  @override
  Future<List<TrackEntity>> getSmartQueue(List<TrackEntity> queue) async {
    try {
      final musilyRepository = MusilyRepository();
      final smartQueueTracks = await musilyRepository.getRelatedTracks(
        [
          ...queue.map(
            (track) => TrackMapper().fromMap(
              TrackModel.toMap(track),
            ),
          ),
        ],
      );
      return [
        ...smartQueueTracks.map(
          (track) => TrackModel.fromMap(
            TrackMapper().toMap(track),
          ),
        ),
      ];
    } catch (e) {
      return queue;
    }
  }
}
