import 'package:musily/features/album/data/models/album_model.dart';
import 'package:musily/features/album/domain/entities/album_entity.dart';
import 'package:musily/features/artist/data/models/artist_model.dart';
import 'package:musily/features/artist/domain/datasources/artist_datasource.dart';
import 'package:musily/features/artist/domain/entitites/artist_entity.dart';
import 'package:musily/features/track/data/models/track_model.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';
import 'package:musily_repository/musily_repository.dart' as repo;

class ArtistsDatasourceImpl extends ArtistDatasource {
  @override
  Future<ArtistEntity?> getArtist(String id) async {
    try {
      final artist = await repo.getArtistInfo(id);
      return ArtistModel.fromMap(artist);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<ArtistEntity>> getArtists(String query) async {
    try {
      final artists = await repo.getArtists(query);
      return [
        ...artists.map(
          (map) => ArtistModel.fromMap(map),
        ),
      ];
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<AlbumEntity>> getArtistAlbums(String artistId) async {
    try {
      final data = await repo.getArtistAlbums(artistId);
      return [
        ...data.map(
          (album) => AlbumModel.fromMap(album),
        ),
      ];
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<TrackEntity>> getArtistTracks(String artistId) async {
    try {
      final data = await repo.getArtistTracks(artistId);
      return [
        ...data.map(
          (track) => TrackModel.fromMap(track),
        ),
      ];
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<AlbumEntity>> getArtistSingles(String artistId) async {
    try {
      final data = await repo.getArtistSingles(artistId);
      return [
        ...data.map(
          (album) => AlbumModel.fromMap(album),
        ),
      ];
    } catch (e) {
      return [];
    }
  }
}
