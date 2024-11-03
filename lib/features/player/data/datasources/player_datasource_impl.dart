import 'package:musily/core/domain/datasources/base_datasource.dart';
import 'package:musily/core/domain/repositories/musily_repository.dart';
import 'package:musily/features/player/domain/datasources/player_datasource.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';

class PlayerDatasourceImpl extends BaseDatasource implements PlayerDatasource {
  late final MusilyRepository _musilyRepository;

  PlayerDatasourceImpl({
    required MusilyRepository musilyRepository,
  }) {
    _musilyRepository = musilyRepository;
  }

  @override
  Future<List<TrackEntity>> getSmartQueue(List<TrackEntity> queue) async {
    return exec<List<TrackEntity>>(() async {
      final smartQueueTracks = await _musilyRepository.getRelatedTracks(queue);
      return smartQueueTracks;
    });
  }
}
