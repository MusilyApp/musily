import 'package:musily/features/playlist/domain/entities/playlist_entity.dart';
import 'package:musily/features/playlist/domain/repositories/playlist_repository.dart';
import 'package:musily/features/playlist/domain/usecases/get_playlist_usecase.dart';

class GetPlaylistUsecaseImpl implements GetPlaylistUsecase {
  final PlaylistRepository playlistRepository;
  GetPlaylistUsecaseImpl({
    required this.playlistRepository,
  });

  @override
  Future<PlaylistEntity?> exec(String id) async {
    final playlist = await playlistRepository.getPlaylist(id);
    return playlist;
  }
}
