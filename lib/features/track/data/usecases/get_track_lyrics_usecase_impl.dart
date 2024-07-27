import 'package:musily/features/track/domain/repositories/track_repository.dart';
import 'package:musily/features/track/domain/usecases/get_track_lyrics_usecase.dart';

class GetTrackLyricsUsecaseImpl implements GetTrackLyricsUsecase {
  final TrackRepository trackRepository;

  GetTrackLyricsUsecaseImpl({
    required this.trackRepository,
  });

  @override
  Future<String?> exec(String id) async {
    final lyrics = trackRepository.getTrackLyrics(id);
    return lyrics;
  }
}
