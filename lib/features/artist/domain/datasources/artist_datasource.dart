import 'package:musily/features/album/domain/entities/album_entity.dart';
import 'package:musily/features/artist/domain/entitites/artist_entity.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';

abstract class ArtistDatasource {
  Future<ArtistEntity?> getArtist(String id);
  Future<List<ArtistEntity>> getArtists(String query);
  Future<List<AlbumEntity>> getArtistAlbums(String artistId);
  Future<List<AlbumEntity>> getArtistSingles(String artistId);
  Future<List<TrackEntity>> getArtistTracks(String artistId);
}
