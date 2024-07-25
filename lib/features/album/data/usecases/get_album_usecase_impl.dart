import 'package:musily/features/album/domain/entities/album_entity.dart';
import 'package:musily/features/album/domain/repositories/album_repository.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';

class GetAlbumUsecaseImpl implements GetAlbumUsecase {
  final AlbumRepository albumRepository;
  GetAlbumUsecaseImpl({
    required this.albumRepository,
  });

  @override
  Future<AlbumEntity?> exec(String id) async {
    final album = await albumRepository.getAlbum(id);
    return album;
  }
}
