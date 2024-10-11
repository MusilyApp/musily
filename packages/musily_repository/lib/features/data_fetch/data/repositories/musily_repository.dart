import 'dart:async';

import 'package:musily_repository/core/data/models/musily_user.dart';
import 'package:musily_repository/features/auth/data/datasources/auth_datasource_impl.dart';
import 'package:musily_repository/features/data_fetch/data/datasources/youtube_datasource.dart';
import 'package:musily_repository/features/data_fetch/domain/datasources/musily_datasource.dart';
import 'package:musily_repository/features/data_fetch/domain/enums/source.dart';
import 'package:musily_repository/features/data_fetch/domain/entities/album_entity.dart';
import 'package:musily_repository/features/data_fetch/domain/entities/simplified_album_entity.dart';
import 'package:musily_repository/features/data_fetch/domain/entities/artist_entity.dart';
import 'package:musily_repository/features/data_fetch/domain/entities/home_section_entity.dart';
import 'package:musily_repository/features/data_fetch/domain/entities/playlist_entity.dart';
import 'package:musily_repository/features/data_fetch/domain/entities/track_entity.dart';
import 'package:musily_repository/features/data_fetch/domain/repositories/musily_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MusilyRepository implements AbstractMusilyRepository {
  static final MusilyRepository _instance = MusilyRepository._internal();
  factory MusilyRepository() {
    return _instance;
  }
  MusilyRepository._internal();

  Source source = Source.youtube;
  late final SharedPreferences sharedPreferences;
  late final YoutubeDatasource youtubeDatasource;

  late final AuthDatasource authDatasource;

  Future<void> initialize() async {
    youtubeDatasource = YoutubeDatasource();
    sharedPreferences = await SharedPreferences.getInstance();
    authDatasource = AuthDatasource();
    _currentUser = await authDatasource.getAuthenticatedUser();
    final sourceString = sharedPreferences.getString('source');
    if (sourceString != null) {
      source = Source.values.firstWhere(
        (element) => element.name == sourceString,
      );
    }
    setDefaultSource(
      Source.youtube,
    );
    await youtubeDatasource.initialize();
  }

  MusilyDatasource datasource({Source? source}) {
    return youtubeDatasource;
  }

  MusilyUser? _currentUser;

  MusilyUser? get currentUser => _currentUser;

  @override
  Future<AlbumEntity?> getAlbum(String albumId, {Source? source}) async {
    final albumDatasource = datasource(source: source);
    return await albumDatasource.getAlbum(albumId);
  }

  @override
  Future<ArtistEntity?> getArtist(String artistId, {Source? source}) async {
    final artistDatasource = datasource(source: source);
    return await artistDatasource.getArtist(artistId);
  }

  @override
  Future<List<SimplifiedAlbumEntity>> getArtistAlbums(String artistId,
      {Source? source}) async {
    final artistDatasource = datasource(source: source);
    return await artistDatasource.getArtistAlbums(artistId);
  }

  @override
  Future<List<SimplifiedAlbumEntity>> getArtistSingles(String artistId,
      {Source? source}) async {
    final artistDatasource = datasource(source: source);
    return await artistDatasource.getArtistSingles(artistId);
  }

  @override
  Future<List<TrackEntity>> getArtistTracks(String artistId,
      {Source? source}) async {
    final artistDatasource = datasource(source: source);
    return await artistDatasource.getArtistTracks(artistId);
  }

  @override
  Future<PlaylistEntity?> getPlaylist(String playlistId,
      {Source? source}) async {
    final playlistDatasource = datasource(source: source);
    return await playlistDatasource.getPlaylist(playlistId);
  }

  @override
  Future<List<PlaylistEntity>> getUserPlaylists({Source? source}) async {
    final playlistDatasource = datasource(source: source);
    return await playlistDatasource.getUserPlaylists();
  }

  @override
  Future<List<TrackEntity>> getRelatedTracks(List<TrackEntity> tracks) async {
    final relatedTracksDatasource = datasource(source: source);
    return await relatedTracksDatasource.getRelatedTracks(tracks);
  }

  @override
  Future<List<String>> getSearchSuggestions(String query,
      {Source? source}) async {
    final suggestionsDatasource = datasource(source: source);
    return await suggestionsDatasource.getSearchSuggestions(query);
  }

  @override
  Future<TrackEntity?> getTrack(String trackId, {Source? source}) async {
    final trackDatasource = datasource(source: source);
    return await trackDatasource.getTrack(trackId);
  }

  @override
  Future<String?> getTrackLyrics(String trackId, {Source? source}) async {
    final lyricsDatasource = datasource(source: source);
    return await lyricsDatasource.getTrackLyrics(trackId);
  }

  @override
  Future<bool> loggedIn({Source? source}) async {
    return false;
  }

  @override
  Future<List<SimplifiedAlbumEntity>> searchAlbums(
    String query, {
    Source? source,
  }) async {
    final albumsDatasource = datasource(source: source);
    return await albumsDatasource.searchAlbums(query);
  }

  @override
  Future<List<ArtistEntity>> searchArtists(
    String query, {
    Source? source,
  }) async {
    final artistsDatasource = datasource(source: source);
    return await artistsDatasource.searchArtists(query);
  }

  @override
  Future<List<HomeSectionEntity>> getHomeSections({Source? source}) async {
    final homeDatasource = datasource(
      source: source,
    );
    return await homeDatasource.getHomeSections();
  }

  @override
  Future<List<TrackEntity>> searchTracks(String query, {Source? source}) async {
    final tracksDatasource = datasource(source: source);
    return await tracksDatasource.searchTracks(query);
  }

  @override
  Future<void> setDefaultSource(Source source) async {
    this.source = source;
    await sharedPreferences.setString('source', source.name);
  }

  @override
  Future<MusilyUser> createAccount(
    String name,
    String email,
    String password,
  ) async {
    final user = await authDatasource.createAccount(
      name,
      email,
      password,
    );
    _currentUser = user;
    return user;
  }

  @override
  Future<MusilyUser?> getAuthenticatedUser() async {
    final user = await authDatasource.getAuthenticatedUser();
    _currentUser = user;
    return user;
  }

  @override
  Future<MusilyUser> login(String email, String password) async {
    final user = await authDatasource.login(email, password);
    _currentUser = user;
    return user;
  }

  @override
  Future<void> logout() async {
    _currentUser = null;
    await authDatasource.logout();
  }
}
