import 'package:musily/features/album/domain/entities/album_entity.dart';
import 'package:musily/features/album/domain/repositories/album_repository.dart';
import 'package:musily/features/album/domain/usecases/get_albums_usecase.dart';

class GetAlbumsUsecaseImpl implements GetAlbumsUsecase {
  final AlbumRepository albumRepository;
  GetAlbumsUsecaseImpl({
    required this.albumRepository,
  });

  @override
  Future<List<AlbumEntity>> exec(String query) async {
    final albums = await albumRepository.getAlbums(query);
    return albums;
  }
}
