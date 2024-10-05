import 'package:musily/features/album/data/models/album_model.dart';
import 'package:musily/features/album/domain/entities/album_entity.dart';
import 'package:musily/features/artist/data/models/artist_model.dart';
import 'package:musily/features/artist/domain/datasources/artist_datasource.dart';
import 'package:musily/features/artist/domain/entitites/artist_entity.dart';
import 'package:musily/features/track/data/models/track_model.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';
import 'package:musily_repository/features/data_fetch/data/mappers/artist_mapper.dart';
import 'package:musily_repository/features/data_fetch/data/mappers/simplified_album_mapper.dart';
import 'package:musily_repository/features/data_fetch/data/mappers/track_mapper.dart';
import 'package:musily_repository/musily_repository.dart';

class ArtistsDatasourceImpl extends ArtistDatasource {
  @override
  Future<ArtistEntity?> getArtist(String id) async {
    try {
      final musilyRepository = MusilyRepository();
      final artist = await musilyRepository.getArtist(id);
      if (artist == null) {
        return null;
      }
      return ArtistModel.fromMap(
        ArtistMapper().toMap(artist),
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<ArtistEntity>> getArtists(String query) async {
    try {
      final musilyRepository = MusilyRepository();
      final artists = await musilyRepository.searchArtists(query);
      return [
        ...artists.map(
          (artist) => ArtistModel.fromMap(
            ArtistMapper().toMap(
              artist,
            ),
          ),
        ),
      ];
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<AlbumEntity>> getArtistAlbums(String artistId) async {
    try {
      final musilyRepository = MusilyRepository();
      final data = await musilyRepository.getArtistAlbums(artistId);
      return [
        ...data.map(
          (album) => AlbumModel.fromMap(
            SimplifiedAlbumMapper().toMap(
              album,
            ),
          ),
        ),
      ];
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<TrackEntity>> getArtistTracks(String artistId) async {
    try {
      final musilyRepository = MusilyRepository();
      final data = await musilyRepository.getArtistTracks(artistId);
      return [
        ...data.map(
          (track) => TrackModel.fromMap(
            TrackMapper().toMap(
              track,
            ),
          ),
        ),
      ];
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<AlbumEntity>> getArtistSingles(String artistId) async {
    try {
      final musilyRepository = MusilyRepository();
      final data = await musilyRepository.getArtistSingles(artistId);
      return [
        ...data.map(
          (album) => AlbumModel.fromMap(
            SimplifiedAlbumMapper().toMap(
              album,
            ),
          ),
        ),
      ];
    } catch (e) {
      return [];
    }
  }
}
