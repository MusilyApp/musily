import 'package:musily/features/player/domain/repositories/player_repository.dart';
import 'package:musily/features/player/domain/usecases/get_smart_queue_usecase.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';

class GetSmartQueueUsecaseImpl implements GetSmartQueueUsecase {
  final PlayerRepository playerRepository;

  GetSmartQueueUsecaseImpl({
    required this.playerRepository,
  });

  @override
  Future<List<TrackEntity>> exec(List<TrackEntity> queue) async {
    final smartQueue = await playerRepository.getSmartQueue(queue);
    return smartQueue;
  }
}
