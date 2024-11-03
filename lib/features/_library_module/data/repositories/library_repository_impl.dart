import 'package:musily/features/_library_module/data/dtos/create_playlist_dto.dart';
import 'package:musily/features/_library_module/data/dtos/update_playlist_dto.dart';
import 'package:musily/features/_library_module/domain/datasources/library_datasource.dart';
import 'package:musily/features/_library_module/domain/entities/library_item_entity.dart';
import 'package:musily/features/_library_module/domain/repositories/library_repository.dart';
import 'package:musily/features/album/domain/entities/album_entity.dart';
import 'package:musily/features/artist/domain/entitites/artist_entity.dart';
import 'package:musily/features/playlist/domain/entities/playlist_entity.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';

class LibraryRepositoryImpl implements LibraryRepository {
  late final LibraryDatasource _libraryDatasource;

  LibraryRepositoryImpl({
    required LibraryDatasource libraryDatasource,
  }) {
    _libraryDatasource = libraryDatasource;
  }

  @override
  Future<LibraryItemEntity> addAlbumToLibrary(AlbumEntity album) async {
    final item = await _libraryDatasource.addAlbumToLibrary(album);
    return item;
  }

  @override
  Future<void> addArtistToLibrary(ArtistEntity artist) {
    return _libraryDatasource.addArtistToLibrary(artist);
  }

  @override
  Future<void> addTracksToPlaylist(
      String playlistId, List<TrackEntity> tracks) {
    return _libraryDatasource.addTracksToPlaylist(playlistId, tracks);
  }

  @override
  Future<PlaylistEntity> createPlaylist(CreatePlaylistDTO data) {
    return _libraryDatasource.createPlaylist(data);
  }

  @override
  Future<void> deletePlaylist(String playlistId) {
    return _libraryDatasource.deletePlaylist(playlistId);
  }

  @override
  Future<LibraryItemEntity?> getLibraryItem(String itemId) {
    return _libraryDatasource.getLibraryItem(itemId);
  }

  @override
  Future<List<LibraryItemEntity>> getLibraryItems() {
    return _libraryDatasource.getLibraryItems();
  }

  @override
  Future<void> removeAlbumFromLibrary(String albumId) {
    return _libraryDatasource.removeAlbumFromLibrary(albumId);
  }

  @override
  Future<void> removeArtistFromLibrary(String artistId) {
    return _libraryDatasource.removeArtistFromLibrary(artistId);
  }

  @override
  Future<void> removeTracksFromPlaylist(
      String playlistId, List<String> trackIds) {
    return _libraryDatasource.removeTracksFromPlaylist(playlistId, trackIds);
  }

  @override
  Future<PlaylistEntity?> updatePlaylist(UpdatePlaylistDto data) {
    return _libraryDatasource.updatePlaylist(data);
  }
}
