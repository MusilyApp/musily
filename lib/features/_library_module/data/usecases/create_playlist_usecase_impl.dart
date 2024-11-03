import 'package:musily/features/_library_module/data/dtos/create_playlist_dto.dart';
import 'package:musily/features/_library_module/domain/repositories/library_repository.dart';
import 'package:musily/features/_library_module/domain/usecases/create_playlist_usecase.dart';
import 'package:musily/features/playlist/domain/entities/playlist_entity.dart';

class CreatePlaylistUsecaseImpl implements CreatePlaylistUsecase {
  late final LibraryRepository _libraryRepository;

  CreatePlaylistUsecaseImpl({
    required LibraryRepository libraryRepository,
  }) {
    _libraryRepository = libraryRepository;
  }

  @override
  Future<PlaylistEntity> exec(CreatePlaylistDTO data) async {
    return await _libraryRepository.createPlaylist(data);
  }
}
