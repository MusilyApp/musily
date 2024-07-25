import 'package:musily/features/album/domain/datasources/album_datasource.dart';
import 'package:musily/features/album/domain/entities/album_entity.dart';
import 'package:musily/features/album/domain/repositories/album_repository.dart';

class AlbumRepositoryImpl implements AlbumRepository {
  final AlbumDatasource albumDatasource;
  AlbumRepositoryImpl({
    required this.albumDatasource,
  });

  @override
  Future<AlbumEntity?> getAlbum(String id) async {
    final album = await albumDatasource.getAlbum(id);
    return album;
  }

  @override
  Future<List<AlbumEntity>> getAlbums(String query) async {
    final albums = await albumDatasource.getAlbums(query);
    return albums;
  }
}
