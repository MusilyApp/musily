import 'package:musily/core/domain/repositories/musily_repository.dart';
import 'package:musily/core/domain/usecases/get_upnext_usecase.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';

class GetUpNextUsecaseImpl implements GetUpNextUsecase {
  late final MusilyRepository _musilyRepository;

  GetUpNextUsecaseImpl({
    required MusilyRepository musilyRepository,
  }) {
    _musilyRepository = musilyRepository;
  }

  @override
  Future<List<TrackEntity>> exec(TrackEntity track) async {
    final upNextTracks = await _musilyRepository.getUpNext(track);
    return upNextTracks;
  }
}
