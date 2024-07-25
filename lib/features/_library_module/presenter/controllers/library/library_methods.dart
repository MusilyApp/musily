import 'package:musily/features/_library_module/domain/entities/library_item_entity.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';

class LibraryMethods {
  final Future<void> Function<T>(T item) addToLibrary;
  final Future<void> Function() getLibrary;
  final Future<void> Function(
    List<TrackEntity> tracks,
    String playlistId,
  ) addToPlaylist;
  final Future<void> Function(
    String playlistId,
    TrackEntity track,
  ) removeFromPlaylist;
  final Future<void> Function(String id) deleteLibraryItem;
  final Future<void> Function(TrackEntity track) toggleFavorite;
  bool Function(TrackEntity track) isFavorite;
  Future<void> Function() loadFavorites;
  Future<void> Function(
    String id,
    String name,
  ) updatePlaylistName;

  final Future<void> Function(String id) updateLastTimePlayed;

  Future<void> Function(
    List<TrackEntity> tracks,
    String downloadingId,
  ) downloadCollection;
  Future<void> Function(
    List<TrackEntity> tracks,
    String downloadingId,
  ) cancelCollectionDownload;
  Future<LibraryItemEntity?> Function(String id) getLibraryItem;

  LibraryMethods({
    required this.addToLibrary,
    required this.getLibrary,
    required this.addToPlaylist,
    required this.deleteLibraryItem,
    required this.toggleFavorite,
    required this.isFavorite,
    required this.loadFavorites,
    required this.downloadCollection,
    required this.cancelCollectionDownload,
    required this.getLibraryItem,
    required this.updatePlaylistName,
    required this.removeFromPlaylist,
    required this.updateLastTimePlayed,
  });
}
