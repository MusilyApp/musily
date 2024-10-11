import 'package:musily_repository/core/data/models/musily_user.dart';
import 'package:musily_repository/features/data_fetch/domain/enums/source.dart';
import 'package:musily_repository/features/data_fetch/domain/entities/album_entity.dart';
import 'package:musily_repository/features/data_fetch/domain/entities/simplified_album_entity.dart';
import 'package:musily_repository/features/data_fetch/domain/entities/artist_entity.dart';
import 'package:musily_repository/features/data_fetch/domain/entities/home_section_entity.dart';
import 'package:musily_repository/features/data_fetch/domain/entities/playlist_entity.dart';
import 'package:musily_repository/features/data_fetch/domain/entities/track_entity.dart';

abstract class AbstractMusilyRepository {
  // Auth Use Cases
  Future<MusilyUser> login(
    String email,
    String password,
  );
  Future<MusilyUser?> getAuthenticatedUser();
  Future<MusilyUser> createAccount(
    String name,
    String email,
    String password,
  );
  Future<void> logout();

  // Album Use Cases
  Future<AlbumEntity?> getAlbum(
    String albumId, {
    Source? source,
  });

  // Artist Use Cases
  Future<ArtistEntity?> getArtist(
    String artistId, {
    Source? source,
  });
  Future<List<SimplifiedAlbumEntity>> getArtistAlbums(
    String artistId, {
    Source? source,
  });
  Future<List<SimplifiedAlbumEntity>> getArtistSingles(
    String artistId, {
    Source? source,
  });
  Future<List<TrackEntity>> getArtistTracks(
    String artistId, {
    Source? source,
  });

  // Playlist Use Cases
  Future<PlaylistEntity?> getPlaylist(
    String playlistId, {
    Source? source,
  });
  Future<List<PlaylistEntity>> getUserPlaylists({
    Source? source,
  });

  // Track Use Cases
  Future<TrackEntity?> getTrack(
    String trackId, {
    Source? source,
  });
  Future<String?> getTrackLyrics(
    String trackId, {
    Source? source,
  });
  Future<List<TrackEntity>> getRelatedTracks(
    List<TrackEntity> tracks,
  );

  // Search Use Cases
  Future<List<String>> getSearchSuggestions(
    String query, {
    Source? source,
  });
  Future<List<SimplifiedAlbumEntity>> searchAlbums(
    String query, {
    Source? source,
  });
  Future<List<ArtistEntity>> searchArtists(
    String query, {
    Source? source,
  });
  Future<List<TrackEntity>> searchTracks(
    String query, {
    Source? source,
  });

  // Home sections
  Future<List<HomeSectionEntity>> getHomeSections({
    Source? source,
  });

  // Repository methods
  Future<void> setDefaultSource(Source source);
  Future<bool> loggedIn({Source? source});
}
