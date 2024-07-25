import 'package:musily/features/track/domain/entities/track_entity.dart';
import 'package:musily/features/track/domain/repositories/track_repository.dart';
import 'package:musily/features/track/domain/usecases/get_tracks_usecase.dart';

class GetTracksUsecaseImpl implements GetTracksUsecase {
  final TrackRepository trackRepository;
  GetTracksUsecaseImpl({
    required this.trackRepository,
  });

  @override
  Future<List<TrackEntity>> exec(String query) async {
    final tracks = await trackRepository.getTracks(query);
    return tracks;
  }
}
