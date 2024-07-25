import 'package:musily/features/track/domain/entities/track_entity.dart';
import 'package:musily/features/track/domain/repositories/track_repository.dart';
import 'package:musily/features/track/domain/usecases/get_track_usecase.dart';

class GetTrackUsecaseImpl implements GetTrackUsecase {
  final TrackRepository trackRepository;
  GetTrackUsecaseImpl({
    required this.trackRepository,
  });
  @override
  Future<TrackEntity?> exec(String id) async {
    final track = await trackRepository.getTrack(id);
    return track;
  }
}
