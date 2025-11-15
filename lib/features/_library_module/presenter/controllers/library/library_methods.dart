import 'dart:io';

import 'package:musily/core/data/services/library_backup_service.dart';
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
  final Future<void> Function(List<LibraryItemEntity> items) mergeLibrary;

  // Backup
  final Future<void> Function(List<BackupOptions> options) backupLibrary;
  final Future<void> Function(File backupFile) restoreLibrary;
  final Future<File?> Function() pickBackupFile;
  final Future<void> Function() cancelBackup;

  // Playlist
  final Future<void> Function(CreatePlaylistDTO data) createPlaylist;

  final Future<void> Function(String playlistId, List<TrackEntity> tracks)
      addTracksToPlaylist;

  final Future<void> Function(String playlistId, List<String> tracksIds)
      removeTracksFromPlaylist;

  final Future<void> Function(
    String playlistId,
    String trackId,
    TrackEntity updatedTrack,
  ) updateTrackInPlaylist;

  final Future<void> Function(UpdatePlaylistDto data) updatePlaylist;

  final Future<void> Function(String playlistId) removePlaylistFromLibrary;

  // Artist
  final Future<void> Function(ArtistEntity artist) addArtistToLibrary;

  final Future<void> Function(String artistId) removeArtistFromLibrary;

  // Album
  final Future<void> Function(AlbumEntity album) addAlbumToLibrary;

  final Future<void> Function(String albumId) removeAlbumFromLibrary;

  bool Function(TrackEntity track) isFavorite;
  Future<void> Function() loadFavorites;

  final Future<void> Function(String id) updateLastTimePlayed;

  Future<void> Function(List<TrackEntity> tracks, String downloadingId)
      downloadCollection;

  Future<void> Function(List<TrackEntity> tracks, String downloadingId)
      cancelCollectionDownload;

  // Local library folders
  final Future<void> Function(String name, String directoryPath)
      addLocalPlaylistFolder;
  final Future<void> Function(String playlistId) removeLocalPlaylistFolder;
  final Future<void> Function(String playlistId, String newName)
      renameLocalPlaylistFolder;
  final Future<void> Function(String playlistId, String newDirectoryPath)
      updateLocalPlaylistDirectory;
  final Future<List<TrackEntity>> Function(String playlistId)
      getLocalPlaylistTracks;
  final Future<void> Function() refreshLocalPlaylists;

  LibraryMethods({
    required this.getLibraryItems,
    required this.getLibraryItem,
    required this.createPlaylist,
    required this.addTracksToPlaylist,
    required this.removeTracksFromPlaylist,
    required this.updateTrackInPlaylist,
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
    required this.addLocalPlaylistFolder,
    required this.removeLocalPlaylistFolder,
    required this.renameLocalPlaylistFolder,
    required this.updateLocalPlaylistDirectory,
    required this.getLocalPlaylistTracks,
    required this.refreshLocalPlaylists,
    required this.mergeLibrary,
    required this.backupLibrary,
    required this.restoreLibrary,
    required this.pickBackupFile,
    required this.cancelBackup,
  });
}
