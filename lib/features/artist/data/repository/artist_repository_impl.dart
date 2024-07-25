import 'package:musily/features/album/domain/entities/album_entity.dart';
import 'package:musily/features/artist/domain/datasources/artist_datasource.dart';
import 'package:musily/features/artist/domain/entitites/artist_entity.dart';
import 'package:musily/features/artist/domain/repositories/artist_repository.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';

class ArtistRepositoryImpl implements ArtistRepository {
  final ArtistDatasource artistDatasource;
  ArtistRepositoryImpl({
    required this.artistDatasource,
  });
  @override
  Future<ArtistEntity?> getArtist(String id) async {
    final artist = await artistDatasource.getArtist(id);
    return artist;
  }

  @override
  Future<List<ArtistEntity>> getArtists(String query) async {
    final artists = await artistDatasource.getArtists(query);
    return artists;
  }

  @override
  Future<List<AlbumEntity>> getArtistAlbums(String artistId) async {
    final albums = await artistDatasource.getArtistAlbums(artistId);
    return albums;
  }

  @override
  Future<List<TrackEntity>> getArtistTracks(String artistId) async {
    final tracks = await artistDatasource.getArtistTracks(artistId);
    return tracks;
  }

  @override
  Future<List<AlbumEntity>> getArtistSingles(String artistId) async {
    final singles = await artistDatasource.getArtistSingles(artistId);
    return singles;
  }
}
