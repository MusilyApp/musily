import 'package:dart_ytmusic_api/types.dart';
import 'package:musily/core/data/datasources/youtube_datasource.dart';
import 'package:musily/core/domain/repositories/musily_repository.dart';
import 'package:musily/features/_sections_module/domain/entities/section_entity.dart';
import 'package:musily/features/album/domain/entities/album_entity.dart';
import 'package:musily/features/artist/domain/entitites/artist_entity.dart';
import 'package:musily/features/playlist/domain/entities/playlist_entity.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MusilyRepositoryImpl implements MusilyRepository {
  static final MusilyRepositoryImpl _instance =
      MusilyRepositoryImpl._internal();
  factory MusilyRepositoryImpl() {
    return _instance;
  }
  MusilyRepositoryImpl._internal();

  late final SharedPreferences sharedPreferences;
  late final YoutubeDatasource youtubeDatasource;

  Future<void> initialize() async {
    sharedPreferences = await SharedPreferences.getInstance();
    youtubeDatasource = YoutubeDatasource();
    await youtubeDatasource.initialize();
  }

  @override
  Future<AlbumEntity?> getAlbum(String albumId) async {
    final album = await youtubeDatasource.getAlbum(albumId);
    return album;
  }

  @override
  Future<ArtistEntity?> getArtist(String artistId) async {
    final artist = await youtubeDatasource.getArtist(artistId);
    return artist;
  }

  @override
  Future<List<AlbumEntity>> getArtistAlbums(String artistId) async {
    final albums = await youtubeDatasource.getArtistAlbums(artistId);
    return albums;
  }

  @override
  Future<List<AlbumEntity>> getArtistSingles(String artistId) async {
    final singles = await youtubeDatasource.getArtistSingles(artistId);
    return singles;
  }

  @override
  Future<List<TrackEntity>> getArtistTracks(String artistId) async {
    final tracks = await youtubeDatasource.getArtistTracks(artistId);
    return tracks;
  }

  @override
  Future<List<HomeSectionEntity>> getHomeSections() async {
    final sections = await youtubeDatasource.getHomeSections();
    return sections;
  }

  @override
  Future<PlaylistEntity?> getPlaylist(String playlistId) async {
    final playlist = await youtubeDatasource.getPlaylist(playlistId);
    return playlist;
  }

  @override
  Future<List<TrackEntity>> getRelatedTracks(List<TrackEntity> tracks) async {
    final relatedTracks = await youtubeDatasource.getRelatedTracks(tracks);
    return relatedTracks;
  }

  @override
  Future<List<String>> getSearchSuggestions(String query) async {
    final suggestions = await youtubeDatasource.getSearchSuggestions(query);
    return suggestions;
  }

  @override
  Future<TrackEntity?> getTrack(String trackId) async {
    final track = await youtubeDatasource.getTrack(trackId);
    return track;
  }

  @override
  Future<String?> getTrackLyrics(String trackId) async {
    final lyrics = await youtubeDatasource.getTrackLyrics(trackId);
    return lyrics;
  }

  @override
  Future<List<PlaylistEntity>> getUserPlaylists() async {
    final playlists = await youtubeDatasource.getUserPlaylists();
    return playlists;
  }

  @override
  Future<List<AlbumEntity>> searchAlbums(String query) async {
    final albums = await youtubeDatasource.searchAlbums(query);
    return albums;
  }

  @override
  Future<List<ArtistEntity>> searchArtists(String query) async {
    final artists = await youtubeDatasource.searchArtists(query);
    return artists;
  }

  @override
  Future<List<TrackEntity>> searchTracks(String query) async {
    final tracks = await youtubeDatasource.searchTracks(query);
    return tracks;
  }

  @override
  Future<TimedLyricsRes?> getTimedLyrics(String trackId) {
    final timedLyrics = youtubeDatasource.getTimedLyrics(trackId);
    return timedLyrics;
  }
}
