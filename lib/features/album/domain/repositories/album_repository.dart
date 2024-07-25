import 'package:musily/features/album/domain/entities/album_entity.dart';

abstract class AlbumRepository {
  Future<List<AlbumEntity>> getAlbums(String query);
  Future<AlbumEntity?> getAlbum(String id);
}
