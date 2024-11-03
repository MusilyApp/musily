import 'package:musily/features/_library_module/data/dtos/update_playlist_dto.dart';
import 'package:musily/features/_library_module/domain/repositories/library_repository.dart';
import 'package:musily/features/_library_module/domain/usecases/update_playlist_usecase.dart';
import 'package:musily/features/playlist/domain/entities/playlist_entity.dart';

class UpdatePlaylistUsecaseImpl implements UpdatePlaylistUsecase {
  late final LibraryRepository _libraryRepository;

  UpdatePlaylistUsecaseImpl({
    required LibraryRepository libraryRepository,
  }) {
    _libraryRepository = libraryRepository;
  }

  @override
  Future<PlaylistEntity?> exec(
    UpdatePlaylistDto data,
  ) async {
    return await _libraryRepository.updatePlaylist(data);
  }
}
