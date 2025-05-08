import 'package:dart_ytmusic_api/dart_ytmusic_api.dart';
import 'package:musily/features/_sections_module/domain/entities/section_entity.dart';
import 'package:musily/features/album/domain/entities/album_entity.dart';
import 'package:musily/features/artist/domain/entitites/artist_entity.dart';
import 'package:musily/features/playlist/domain/entities/playlist_entity.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';

abstract class MusilyRepository {
  // Album Use Cases
  Future<AlbumEntity?> getAlbum(
    String albumId,
  );

  // Artist Use Cases
  Future<ArtistEntity?> getArtist(
    String artistId,
  );
  Future<List<AlbumEntity>> getArtistAlbums(
    String artistId,
  );
  Future<List<AlbumEntity>> getArtistSingles(
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
  Future<TimedLyricsRes?> getTimedLyrics(
    String trackId,
  );

  Future<List<TrackEntity>> getRelatedTracks(
    List<TrackEntity> tracks,
  );

  // Search Use Cases
  Future<List<String>> getSearchSuggestions(
    String query,
  );
  Future<List<AlbumEntity>> searchAlbums(
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
