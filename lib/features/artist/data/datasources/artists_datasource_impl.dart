import 'package:musily/core/domain/datasources/base_datasource.dart';
import 'package:musily/core/domain/repositories/musily_repository.dart';
import 'package:musily/features/album/domain/entities/album_entity.dart';
import 'package:musily/features/artist/domain/datasources/artist_datasource.dart';
import 'package:musily/features/artist/domain/entitites/artist_entity.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';

class ArtistsDatasourceImpl extends BaseDatasource implements ArtistDatasource {
  late final MusilyRepository _musilyRepository;

  ArtistsDatasourceImpl({
    required MusilyRepository musilyRepository,
  }) {
    _musilyRepository = musilyRepository;
  }

  @override
  Future<ArtistEntity?> getArtist(String id) async {
    return exec<ArtistEntity?>(() async {
      final artist = await _musilyRepository.getArtist(id);
      if (artist == null) {
        return null;
      }
      return artist;
    });
  }

  @override
  Future<List<ArtistEntity>> getArtists(String query) async {
    return exec<List<ArtistEntity>>(() async {
      final artists = await _musilyRepository.searchArtists(query);
      return artists;
    });
  }

  @override
  Future<List<AlbumEntity>> getArtistAlbums(String artistId) async {
    return exec<List<AlbumEntity>>(() async {
      final albums = await _musilyRepository.getArtistAlbums(artistId);
      return albums;
    });
  }

  @override
  Future<List<TrackEntity>> getArtistTracks(String artistId) async {
    return exec<List<TrackEntity>>(() async {
      final tracks = await _musilyRepository.getArtistTracks(artistId);
      return tracks;
    });
  }

  @override
  Future<List<AlbumEntity>> getArtistSingles(String artistId) async {
    return exec<List<AlbumEntity>>(() async {
      final albums = await _musilyRepository.getArtistSingles(artistId);
      return albums;
    });
  }
}
