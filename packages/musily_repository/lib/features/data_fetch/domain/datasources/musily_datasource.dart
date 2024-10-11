import 'package:musily_repository/features/data_fetch/domain/entities/album_entity.dart';
import 'package:musily_repository/features/data_fetch/domain/entities/simplified_album_entity.dart';
import 'package:musily_repository/features/data_fetch/domain/entities/artist_entity.dart';
import 'package:musily_repository/features/data_fetch/domain/entities/home_section_entity.dart';
import 'package:musily_repository/features/data_fetch/domain/entities/playlist_entity.dart';
import 'package:musily_repository/features/data_fetch/domain/entities/track_entity.dart';

abstract class MusilyDatasource {
  // Album Use Cases
  Future<AlbumEntity?> getAlbum(
    String albumId,
  );

  // Artist Use Cases
  Future<ArtistEntity?> getArtist(
    String artistId,
  );
  Future<List<SimplifiedAlbumEntity>> getArtistAlbums(
    String artistId,
  );
  Future<List<SimplifiedAlbumEntity>> getArtistSingles(
    String artistId,
  );
  Future<List<TrackEntity>> getArtistTracks(
    String artistId,
  );

  // Playlist Use Cases
  Future<PlaylistEntity?> getPlaylist(
    String playlistId,
  );
  Future<List<PlaylistEntity>> getUserPlaylists();

  // Track Use Cases
  Future<TrackEntity?> getTrack(
    String trackId,
  );
  Future<String?> getTrackLyrics(
    String trackId,
  );
  Future<List<TrackEntity>> getRelatedTracks(
    List<TrackEntity> tracks,
  );

  // Search Use Cases
  Future<List<String>> getSearchSuggestions(
    String query,
  );
  Future<List<SimplifiedAlbumEntity>> searchAlbums(
    String query,
  );
  Future<List<ArtistEntity>> searchArtists(
    String query,
  );
  Future<List<TrackEntity>> searchTracks(
    String query,
  );

  // Home sections
  Future<List<HomeSectionEntity>> getHomeSections();
}
