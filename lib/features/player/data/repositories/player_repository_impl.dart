import 'package:musily/features/player/domain/datasources/player_datasource.dart';
import 'package:musily/features/player/domain/repositories/player_repository.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';

class PlayerRepositoryImpl implements PlayerRepository {
  final PlayerDatasource playerDatasource;

  PlayerRepositoryImpl({required this.playerDatasource});

  @override
  Future<List<TrackEntity>> getSmartQueue(List<TrackEntity> queue) async {
    final smartQueue = await playerDatasource.getSmartQueue(queue);
    return smartQueue;
  }
}
