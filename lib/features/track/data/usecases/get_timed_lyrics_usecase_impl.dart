import 'package:dart_ytmusic_api/types.dart';
import 'package:musily/features/track/domain/repositories/track_repository.dart';
import 'package:musily/features/track/domain/usecases/get_timed_lyrics_usecase.dart';

class GetTimedLyricsUsecaseImpl implements GetTimedLyricsUsecase {
  final TrackRepository trackRepository;

  GetTimedLyricsUsecaseImpl({
    required this.trackRepository,
  });

  @override
  Future<TimedLyricsRes?> exec(String id) {
    final timedLyrics = trackRepository.getTimedLyrics(id);
    return timedLyrics;
  }
}
