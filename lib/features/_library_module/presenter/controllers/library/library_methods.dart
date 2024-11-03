import 'package:musily/features/_library_module/data/dtos/create_playlist_dto.dart';
import 'package:musily/features/_library_module/data/dtos/update_playlist_dto.dart';
import 'package:musily/features/_library_module/domain/entities/library_item_entity.dart';
import 'package:musily/features/album/domain/entities/album_entity.dart';
import 'package:musily/features/artist/domain/entitites/artist_entity.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';

class LibraryMethods {
  // Library
  final Future<void> Function({bool showLoading}) getLibraryItems;
  final Future<LibraryItemEntity?> Function(String itemId) getLibraryItem;

  // Playlist
  final Future<void> Function(CreatePlaylistDTO data) createPlaylist;

  final Future<void> Function(
    String playlistId,
    List<TrackEntity> tracks,
  ) addTracksToPlaylist;

  final Future<void> Function(
    String playlistId,
    List<String> tracksIds,
  ) removeTracksFromPlaylist;

  final Future<void> Function(
    UpdatePlaylistDto data,
  ) updatePlaylist;

  final Future<void> Function(
    String playlistId,
  ) removePlaylistFromLibrary;

  // Artist
  final Future<void> Function(ArtistEntity artist) addArtistToLibrary;

  final Future<void> Function(String artistId) removeArtistFromLibrary;

  // Album
  final Future<void> Function(AlbumEntity album) addAlbumToLibrary;

  final Future<void> Function(String albumId) removeAlbumFromLibrary;

  bool Function(TrackEntity track) isFavorite;
  Future<void> Function() loadFavorites;

  final Future<void> Function(String id) updateLastTimePlayed;

  Future<void> Function(
    List<TrackEntity> tracks,
    String downloadingId,
  ) downloadCollection;

  Future<void> Function(
    List<TrackEntity> tracks,
    String downloadingId,
  ) cancelCollectionDownload;

  LibraryMethods({
    required this.getLibraryItems,
    required this.getLibraryItem,
    required this.createPlaylist,
    required this.addTracksToPlaylist,
    required this.removeTracksFromPlaylist,
    required this.updatePlaylist,
    required this.removePlaylistFromLibrary,
    required this.addArtistToLibrary,
    required this.removeArtistFromLibrary,
    required this.addAlbumToLibrary,
    required this.removeAlbumFromLibrary,
    required this.isFavorite,
    required this.loadFavorites,
    required this.updateLastTimePlayed,
    required this.downloadCollection,
    required this.cancelCollectionDownload,
  });
}
