import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:collection/collection.dart';
import 'package:crypto/crypto.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_download_manager/flutter_download_manager.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:musily/core/data/database/collections/download_queue.dart';
import 'package:musily/core/data/database/database.dart';
import 'package:musily/core/data/services/library_backup_isolate.dart';
import 'package:musily/core/data/services/user_service.dart';
import 'package:musily/main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:musily/core/domain/presenter/app_controller.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/extensions/string.dart';
import 'package:musily/core/presenter/ui/utils/ly_snackbar.dart';
import 'package:musily/core/presenter/ui/utils/ly_navigator.dart';
import 'package:musily/core/utils/id_generator.dart';
import 'package:musily/features/_library_module/data/models/library_item_model.dart';
import 'package:musily/features/_library_module/data/services/local_library_service.dart';
import 'package:musily/features/_library_module/domain/entities/library_item_entity.dart';
import 'package:musily/features/_library_module/domain/entities/local_library_playlist.dart';
import 'package:musily/features/_library_module/domain/entities/local_track_metadata.dart';
import 'package:musily/features/artist/domain/entitites/artist_entity.dart';
import 'package:musily/features/album/domain/entities/album_entity.dart';
import 'package:musily/features/_library_module/domain/usecases/add_album_to_library_usecase.dart';
import 'package:musily/features/_library_module/domain/usecases/add_artist_to_library_usecase.dart';
import 'package:musily/features/_library_module/domain/usecases/add_tracks_to_playlist_usecase.dart';
import 'package:musily/features/_library_module/domain/usecases/create_playlist_usecase.dart';
import 'package:musily/features/_library_module/domain/usecases/delete_playlist_usecase.dart';
import 'package:musily/features/_library_module/domain/usecases/get_library_item_usecase.dart';
import 'package:musily/features/_library_module/domain/usecases/get_library_items_usecase.dart';
import 'package:musily/features/_library_module/domain/usecases/merge_library_usecase.dart';
import 'package:musily/features/_library_module/domain/usecases/remove_album_from_library_usecase.dart';
import 'package:musily/features/_library_module/domain/usecases/remove_artist_from_library_usecase.dart';
import 'package:musily/features/_library_module/domain/usecases/remove_tracks_from_playlist_usecase.dart';
import 'package:musily/features/_library_module/domain/usecases/update_library_item_usecase.dart';
import 'package:musily/features/_library_module/domain/usecases/update_playlist_usecase.dart';
import 'package:musily/features/_library_module/domain/usecases/update_track_in_playlist_usecase.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_data.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_methods.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_data.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';
import 'package:musily/features/playlist/domain/entities/playlist_entity.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';
import 'package:queue/queue.dart';

class LibraryController extends BaseController<LibraryData, LibraryMethods> {
  late final GetLibraryItemsUsecase _getLibraryItemsUsecase;
  late final GetLibraryItemUsecase _getLibraryItemUsecase;
  late final DownloaderController _downloaderController;
  late final PlayerController _playerController;
  late final UpdatePlaylistUsecase _updatePlaylistUsecase;
  late final AddTracksToPlaylistUsecase _addTracksToPlaylistUsecase;
  late final CreatePlaylistUsecase _createPlaylistUsecase;
  late final RemoveTracksFromPlaylistUsecase _removeTracksFromPlaylistUsecase;
  late final UpdateTrackInPlaylistUsecase _updateTrackInPlaylistUsecase;
  late final AddArtistToLibraryUsecase _addArtistToLibraryUsecase;
  late final RemoveArtistFromLibraryUsecase _removeArtistFromLibraryUsecase;
  late final AddAlbumToLibraryUsecase _addAlbumToLibraryUsecase;
  late final RemoveAlbumFromLibraryUsecase _removeAlbumFromLibraryUsecase;
  late final DeletePlaylistUsecase _deletePlaylistUsecase;
  late final UpdateLibraryItemUsecase _updateLibraryItemUsecase;
  late final MergeLibraryUsecase _mergeLibraryUsecase;

  LibraryController({
    required GetLibraryItemsUsecase getLibraryUsecase,
    required GetLibraryItemUsecase getLibraryItemUsecase,
    required DownloaderController downloaderController,
    required PlayerController playerController,
    required UpdatePlaylistUsecase updatePlaylistUsecase,
    required AddTracksToPlaylistUsecase addTracksToPlaylistUsecase,
    required CreatePlaylistUsecase createPlaylistUsecase,
    required RemoveTracksFromPlaylistUsecase removeTracksFromPlaylistUsecase,
    required UpdateTrackInPlaylistUsecase updateTrackInPlaylistUsecase,
    required AddArtistToLibraryUsecase addArtistToLibraryUsecase,
    required RemoveArtistFromLibraryUsecase removeArtistFromLibraryUsecase,
    required AddAlbumToLibraryUsecase addAlbumToLibraryUsecase,
    required RemoveAlbumFromLibraryUsecase removeAlbumFromLibraryUsecase,
    required DeletePlaylistUsecase deletePlaylistUsecase,
    required UpdateLibraryItemUsecase updateLibraryItemUsecase,
    required MergeLibraryUsecase mergeLibraryUsecase,
  }) {
    _getLibraryItemsUsecase = getLibraryUsecase;
    _getLibraryItemUsecase = getLibraryItemUsecase;
    _downloaderController = downloaderController;
    _playerController = playerController;
    _updatePlaylistUsecase = updatePlaylistUsecase;
    _addTracksToPlaylistUsecase = addTracksToPlaylistUsecase;
    _createPlaylistUsecase = createPlaylistUsecase;
    _removeTracksFromPlaylistUsecase = removeTracksFromPlaylistUsecase;
    _updateTrackInPlaylistUsecase = updateTrackInPlaylistUsecase;
    _addArtistToLibraryUsecase = addArtistToLibraryUsecase;
    _removeArtistFromLibraryUsecase = removeArtistFromLibraryUsecase;
    _addAlbumToLibraryUsecase = addAlbumToLibraryUsecase;
    _removeAlbumFromLibraryUsecase = removeAlbumFromLibraryUsecase;
    _deletePlaylistUsecase = deletePlaylistUsecase;
    _updateLibraryItemUsecase = updateLibraryItemUsecase;
    _mergeLibraryUsecase = mergeLibraryUsecase;

    methods.getLibraryItems();
    _loadLocalPlaylists();
  }

  final queue = Queue(delay: const Duration(milliseconds: 100));
  final LocalLibraryService _localLibraryService = LocalLibraryService();
  Map<String, LocalTrackMetadata> _localTrackMetadataCache = {};
  bool _localTrackMetadataLoaded = false;
  static const Set<String> _supportedAudioExtensions = {
    '.mp3',
    '.aac',
    '.m4a',
    '.wav',
    '.flac',
    '.ogg',
    '.opus',
  };

  // Backup/Restore isolate management
  Isolate? _backupIsolate;
  ReceivePort? _backupReceivePort;
  StreamSubscription? _backupStreamSubscription;

  @override
  LibraryData defineData() {
    return LibraryData(
      loading: true,
      loadedFavoritesHash: [],
      alreadyLoadedFirstFavoriteState: [],
      items: [],
      itemsAddingToLibrary: [],
      itemsAddingToFavorites: [],
      localPlaylists: const [],
    );
  }

  @override
  LibraryMethods defineMethods() {
    return LibraryMethods(
      // Library
      getLibraryItems: ({bool showLoading = true}) async {
        updateData(data.copyWith(loading: showLoading));
        final items = await _getLibraryItemsUsecase.exec();
        await methods.loadFavorites();
        updateData(data.copyWith(items: items, loading: false));
      },
      getLibraryItem: (itemId) async {
        final item = await _getLibraryItemUsecase.exec(itemId);
        if (item == null) {
          return null;
        }
        if (itemId.startsWith('favorites')) {
          updateData(
            data.copyWith(
              loadedFavoritesHash: [
                ...item.playlist!.tracks.map((element) => element.hash),
              ],
            ),
          );
        }
        updateData(
          data.copyWith(
            items: [
              ...data.items.map((e) {
                if (e.id == itemId) {
                  return LibraryItemEntity(
                    id: item.id,
                    synced: true,
                    lastTimePlayed: item.lastTimePlayed,
                    createdAt: item.createdAt,
                    playlist: item.playlist,
                    album: item.album,
                    artist: item.artist,
                  );
                }
                return LibraryItemEntity(
                  id: e.id,
                  synced: true,
                  lastTimePlayed: e.lastTimePlayed,
                  createdAt: e.createdAt,
                  playlist: e.playlist,
                  album: e.album,
                  artist: e.artist,
                );
              }),
            ],
          ),
        );
        return item;
      },
      mergeLibrary: (items) async {
        final originalItems = List<LibraryItemEntity>.from(data.items);

        try {
          await queue.add(() async {
            await _mergeLibraryUsecase.exec(items);
            await methods.getLibraryItems();
          });
        } catch (e) {
          updateData(data.copyWith(items: originalItems));
        }
      },

      // Playlist
      createPlaylist: (data) async {
        final tempId = idGenerator();
        LibraryItemEntity libraryItem = LibraryItemEntity(
          id: tempId,
          lastTimePlayed: DateTime.now(),
          synced: false,
          playlist: PlaylistEntity(
            id: tempId,
            title: data.title,
            trackCount: 0,
            tracks: [],
          ),
          createdAt: DateTime.now(),
        );
        updateData(
          this.data.copyWith(
                items: this.data.items..insert(0, libraryItem),
                itemsAddingToLibrary: this.data.itemsAddingToLibrary
                  ..add(tempId),
              ),
        );
        try {
          final createdPlaylist = await queue.add(() async {
            return await _createPlaylistUsecase.exec(data);
          });
          updateData(
            this.data.copyWith(
                  items: this.data.items
                    ..removeWhere((e) => e.id == tempId)
                    ..insert(
                      0,
                      LibraryItemEntity(
                        id: createdPlaylist.id,
                        lastTimePlayed: DateTime.now(),
                        synced: true,
                        playlist: createdPlaylist,
                        createdAt: DateTime.now(),
                      ),
                    ),
                  itemsAddingToLibrary: this.data.itemsAddingToLibrary
                    ..removeWhere((e) => e == tempId),
                ),
          );
        } catch (e) {
          catchError(e);
        }
      },
      addTracksToPlaylist: (playlistId, tracks) async {
        if (_playerController.data.tracksFromSmartQueue.contains(
              tracks.firstOrNull?.hash,
            ) &&
            _playerController.data.playingId == playlistId) {
          _playerController.updateData(
            _playerController.data.copyWith(
              tracksFromSmartQueue: _playerController.data.tracksFromSmartQueue
                ..removeWhere((item) => item == tracks.firstOrNull?.hash),
            ),
          );
          _playerController.methods.getSmartQueue(customItems: tracks);
        }
        if (playlistId.startsWith('favorites')) {
          if (data.items
              .where((e) => e.id == UserService.favoritesId)
              .isEmpty) {
            data.items.add(
              LibraryItemModel.newInstance(
                id: UserService.favoritesId,
                synced: false,
                playlist: PlaylistEntity(
                  id: UserService.favoritesId,
                  title: 'favorites',
                  tracks: [],
                  trackCount: 0,
                ),
              ),
            );
          }
          updateData(
            data.copyWith(
              itemsAddingToFavorites: data.itemsAddingToFavorites
                ..addAll(tracks.map((e) => e.id)),
              loadedFavoritesHash: data.loadedFavoritesHash
                ..addAll(tracks.map((e) => e.hash)),
            ),
          );
        }
        final currentItem =
            data.items.where((e) => e.id == playlistId).firstOrNull;
        currentItem?.playlist?.tracks.addAll(
          tracks.where(
            (e) => !currentItem.playlist!.tracks
                .map((track) => track.hash)
                .contains(e.hash),
          ),
        );
        updateData(
          data.copyWith(
            itemsAddingToLibrary: data.itemsAddingToLibrary..add(playlistId),
          ),
        );
        try {
          await queue.add(() async {
            await _addTracksToPlaylistUsecase.exec(playlistId, tracks);
            await methods.getLibraryItem(playlistId);
          });
          updateData(
            data.copyWith(
              itemsAddingToLibrary: data.itemsAddingToLibrary
                ..removeWhere((e) => playlistId == e),
              itemsAddingToFavorites: data.itemsAddingToFavorites
                ..removeWhere((e) => tracks.map((e) => e.id).contains(e)),
            ),
          );
        } catch (e) {
          currentItem?.playlist?.tracks.removeWhere((e) => tracks.contains(e));
          if (playlistId.startsWith('favorites')) {
            updateData(
              data.copyWith(
                itemsAddingToLibrary: data.itemsAddingToLibrary
                  ..removeWhere((e) => playlistId == e),
                itemsAddingToFavorites: data.itemsAddingToFavorites
                  ..removeWhere((e) => tracks.map((e) => e.id).contains(e)),
                loadedFavoritesHash: data.loadedFavoritesHash
                  ..removeWhere(
                    (e) => tracks.map((e) => e.hash).contains(e),
                  ),
              ),
            );
          }
          updateData(data);
          catchError(e);
        }
      },
      removeTracksFromPlaylist: (playlistId, tracksIds) async {
        final currentItem =
            data.items.where((e) => e.id == playlistId).firstOrNull;
        final Iterable<Map<String, dynamic>> tracksToRemove = currentItem
                ?.playlist?.tracks
                .where((e) => tracksIds.contains(e.id))
                .map((e) {
              final index = currentItem.playlist?.tracks.indexOf(e);
              return {'index': index, 'item': e};
            }) ??
            [];
        if (playlistId.startsWith('favorites')) {
          updateData(
            data.copyWith(
              itemsAddingToFavorites: data.itemsAddingToFavorites
                ..addAll(tracksIds),
              loadedFavoritesHash: data.loadedFavoritesHash
                ..removeWhere((e) {
                  final trackList = currentItem?.playlist?.tracks.where(
                    (track) => tracksIds.contains(track.id),
                  );
                  return trackList?.map((track) => track.hash).contains(e) ??
                      false;
                }),
            ),
          );
        }
        currentItem?.playlist?.tracks.removeWhere(
          (e) => tracksIds.contains(e.id),
        );
        updateData(data);
        try {
          await queue.add(() async {
            await _removeTracksFromPlaylistUsecase.exec(playlistId, tracksIds);
            await methods.getLibraryItem(playlistId);
          });
          updateData(
            data.copyWith(
              itemsAddingToFavorites: data.itemsAddingToFavorites
                ..removeWhere((e) => tracksIds.contains(e)),
            ),
          );
        } catch (e) {
          currentItem?.playlist?.trackCount += tracksToRemove.length;
          for (final removedItem in tracksToRemove) {
            currentItem?.playlist?.tracks.insert(
              removedItem['index'],
              removedItem['item'],
            );
          }
          if (playlistId.startsWith('favorites')) {
            updateData(
              data.copyWith(
                itemsAddingToFavorites: data.itemsAddingToFavorites
                  ..removeWhere((e) => tracksIds.contains(e)),
                loadedFavoritesHash: data.loadedFavoritesHash
                  ..addAll(
                    tracksToRemove.map(
                      (e) => (e['item'] as TrackEntity).hash,
                    ),
                  ),
              ),
            );
          }
          updateData(data);
          catchError(e);
        }
      },
      updateTrackInPlaylist: (playlistId, trackId, updatedTrack) async {
        final currentItem =
            data.items.where((e) => e.id == playlistId).firstOrNull;
        if (currentItem?.playlist == null) {
          return;
        }

        final trackIndex = currentItem!.playlist!.tracks.indexWhere(
          (track) => track.id == trackId,
        );
        if (trackIndex == -1) {
          return;
        }

        final oldTrack = currentItem.playlist!.tracks[trackIndex];
        currentItem.playlist!.tracks[trackIndex] = updatedTrack;
        updateData(data);

        try {
          await queue.add(() async {
            await _updateTrackInPlaylistUsecase.exec(
              playlistId,
              trackId,
              updatedTrack,
            );
            await methods.getLibraryItem(playlistId);
          });
        } catch (e) {
          currentItem.playlist!.tracks[trackIndex] = oldTrack;
          updateData(data);
          catchError(e);
        }
      },
      updatePlaylist: (data) async {
        final currentItem =
            this.data.items.where((e) => e.id == data.id).firstOrNull;
        final oldName = currentItem?.playlist?.title ?? '';
        currentItem?.playlist?.title = data.title;
        updateData(this.data);
        try {
          await queue.add(() async {
            await _updatePlaylistUsecase.exec(data);
            await methods.getLibraryItems();
          });
        } catch (e) {
          currentItem?.playlist?.title = oldName;
          updateData(this.data);
          catchError(e);
        }
      },

      // Artist
      addArtistToLibrary: (artist) async {
        updateData(
          data.copyWith(
            itemsAddingToLibrary: data.itemsAddingToLibrary..add(artist.id),
            items: data.items
              ..insert(
                0,
                LibraryItemEntity(
                  id: artist.id,
                  lastTimePlayed: DateTime.now(),
                  synced: false,
                  artist: artist,
                  createdAt: DateTime.now(),
                ),
              ),
          ),
        );
        try {
          await queue.add(() async {
            return await _addArtistToLibraryUsecase.exec(artist);
          });
          final currentItem = data.items.firstWhere((e) => e.id == artist.id);
          currentItem.synced = true;
          updateData(
            data.copyWith(
              itemsAddingToLibrary: data.itemsAddingToLibrary
                ..removeWhere((e) => e == artist.id),
            ),
          );
        } catch (e) {
          updateData(
            data.copyWith(
              itemsAddingToLibrary: data.itemsAddingToLibrary
                ..removeWhere((e) => e == artist.id),
              items: data.items..removeWhere((e) => e.id == artist.id),
            ),
          );
          catchError(e);
        }
      },
      removeArtistFromLibrary: (artistId) async {
        final currentItem =
            data.items.where((e) => e.id == artistId).firstOrNull;
        if (currentItem == null) {
          return;
        }
        final index = data.items.indexOf(currentItem);
        updateData(
          data.copyWith(
            itemsAddingToLibrary: data.itemsAddingToLibrary..add(artistId),
            items: data.items..removeWhere((e) => e.id == artistId),
          ),
        );
        try {
          queue.add(() async {
            await _removeArtistFromLibraryUsecase.exec(artistId);
          });
          updateData(
            data.copyWith(
              itemsAddingToLibrary: data.itemsAddingToLibrary
                ..removeWhere((e) => e == artistId),
            ),
          );
        } catch (e) {
          updateData(
            data.copyWith(
              itemsAddingToLibrary: data.itemsAddingToLibrary
                ..removeWhere((e) => e == artistId),
              items: data.items..insert(index, currentItem),
            ),
          );
          catchError(e);
        }
      },

      // Album
      addAlbumToLibrary: (album) async {
        updateData(
          data.copyWith(
            itemsAddingToLibrary: data.itemsAddingToLibrary..add(album.id),
            items: data.items
              ..insert(
                0,
                LibraryItemEntity(
                  id: album.id,
                  lastTimePlayed: DateTime.now(),
                  synced: false,
                  album: album,
                  createdAt: DateTime.now(),
                ),
              ),
          ),
        );
        try {
          await queue.add(() async {
            await _addAlbumToLibraryUsecase.exec(album);
          });
          final currentItem = data.items.firstWhere((e) => e.id == album.id);
          currentItem.synced = true;
          updateData(
            data.copyWith(
              itemsAddingToLibrary: data.itemsAddingToLibrary..remove(album.id),
            ),
          );
        } catch (e) {
          updateData(
            data.copyWith(
              itemsAddingToLibrary: data.itemsAddingToLibrary
                ..removeWhere((e) => e == album.id),
              items: data.items..removeWhere((e) => e.id == album.id),
            ),
          );
          catchError(e);
        }
      },
      removeAlbumFromLibrary: (albumId) async {
        final currentItem =
            data.items.where((e) => e.id == albumId).firstOrNull;
        if (currentItem == null) {
          return;
        }
        final index = data.items.indexOf(currentItem);
        updateData(
          data.copyWith(
            itemsAddingToLibrary: data.itemsAddingToLibrary..add(albumId),
            items: data.items..removeWhere((e) => e.id == albumId),
          ),
        );
        try {
          await queue.add(() async {
            await _removeAlbumFromLibraryUsecase.exec(albumId);
          });
          updateData(
            data.copyWith(
              itemsAddingToLibrary: data.itemsAddingToLibrary
                ..removeWhere((e) => e == albumId),
            ),
          );
        } catch (e) {
          updateData(
            data.copyWith(
              itemsAddingToLibrary: data.itemsAddingToLibrary
                ..removeWhere((e) => e == albumId),
              items: data.items..insert(index, currentItem),
            ),
          );
          catchError(e);
        }
      },
      isFavorite: (track) {
        if (data.loadedFavoritesHash.contains(track.hash)) {
          return true;
        }
        return false;
      },
      loadFavorites: () async {
        final item = await _getLibraryItemUsecase.exec(UserService.favoritesId);
        if (item?.playlist == null) {
          return;
        }
        updateData(
          data.copyWith(
            loadedFavoritesHash: [
              ...item!.playlist!.tracks.map((element) => element.hash),
            ],
          ),
        );
      },
      updateLastTimePlayed: (id) async {
        final index = data.items.indexWhere(
          (e) => e.id == id || e.album?.id == id || e.artist?.id == id,
        );
        if (index < 0) {
          return;
        }
        final lastTimePlayed =
            data.items.elementAtOrNull(index)?.lastTimePlayed;
        try {
          final item = data.items[index];
          item.lastTimePlayed = DateTime.now();
          data.items.sort(
            (a, b) => b.lastTimePlayed.compareTo(a.lastTimePlayed),
          );
          updateData(data);
          await queue.add(() async {
            await _updateLibraryItemUsecase.exec(item);
          });
        } catch (e) {
          if (lastTimePlayed != null) {
            data.items[index].lastTimePlayed = lastTimePlayed;
            data.items.sort(
              (a, b) => b.lastTimePlayed.compareTo(a.lastTimePlayed),
            );
          }
          catchError(e);
        }
      },

      // Download
      downloadCollection: (tracks, downloadingId) async {
        _downloaderController.methods.setDownloadingKey(downloadingId);
        for (final track in tracks) {
          if ((track.url ?? '').isUrl) {
            continue;
          }
          _downloaderController.methods.addDownload(track);
        }
      },
      cancelCollectionDownload: (tracks, downloadingId) async {
        _downloaderController.methods.setDownloadingKey('');
        await _downloaderController.methods.cancelDownloadCollection(tracks);
      },
      addLocalPlaylistFolder: (name, directoryPath) async {
        await _addLocalPlaylistFolder(name, directoryPath);
      },
      removeLocalPlaylistFolder: (playlistId) async {
        await _removeLocalPlaylistFolder(playlistId);
      },
      renameLocalPlaylistFolder: (playlistId, newName) async {
        await _renameLocalPlaylistFolder(playlistId, newName);
      },
      updateLocalPlaylistDirectory: (playlistId, newDirectoryPath) async {
        await _updateLocalPlaylistDirectory(playlistId, newDirectoryPath);
      },
      getLocalPlaylistTracks: (playlistId) async {
        return _getLocalPlaylistTracks(playlistId);
      },
      refreshLocalPlaylists: () async {
        await _refreshAllLocalPlaylists();
      },
      removePlaylistFromLibrary: (String playlistId) async {
        final currentItem =
            data.items.where((e) => e.id == playlistId).firstOrNull;
        if (currentItem == null) {
          return;
        }
        final index = data.items.indexOf(currentItem);
        updateData(
          data.copyWith(
            itemsAddingToLibrary: data.itemsAddingToLibrary..add(playlistId),
            items: data.items..removeWhere((e) => e.id == playlistId),
          ),
        );
        try {
          await queue.add(() async {
            await _deletePlaylistUsecase.exec(playlistId);
          });
          updateData(
            data.copyWith(
              itemsAddingToLibrary: data.itemsAddingToLibrary
                ..removeWhere((e) => e == playlistId),
            ),
          );
        } catch (e) {
          updateData(
            data.copyWith(
              itemsAddingToLibrary: data.itemsAddingToLibrary
                ..removeWhere((e) => e == playlistId),
              items: data.items..insert(index, currentItem),
            ),
          );
          catchError(e);
        }
      },

      // Backup
      backupLibrary: (options) async {
        if (data.backupInProgress) {
          return; // Already backing up
        }

        try {
          updateData(data.copyWith(
            backupInProgress: true,
            backupProgress: 0.0,
            backupMessage: 'Starting backup...',
            backupMessageKey: 'startingBackup',
            backupActivityType: BackupActivityType.backup,
          ));

          // Ensure library is loaded
          if (data.items.isEmpty) {
            await methods.getLibraryItems();
          }

          // Load full library data
          for (final item in data.items) {
            if (item.playlist != null && item.playlist!.tracks.isEmpty) {
              await methods.getLibraryItem(item.id);
            }
            if (item.album != null && item.album!.tracks.isEmpty) {
              await methods.getLibraryItem(item.id);
            }
          }

          // Setup isolate communication
          _backupReceivePort = ReceivePort();

          // Get directory paths (must be done in main isolate, not in background isolate)
          final tempDir = await getTemporaryDirectory();
          final appSupportDir = await getApplicationSupportDirectory();

          Directory? downloadsDir;
          if (Platform.isAndroid) {
            downloadsDir = Directory('/storage/emulated/0/Download/Musily');
          } else if (Platform.isLinux ||
              Platform.isMacOS ||
              Platform.isWindows) {
            final systemDownloadsDir = await getDownloadsDirectory();
            if (systemDownloadsDir != null) {
              downloadsDir =
                  Directory(path.join(systemDownloadsDir.path, 'Musily'));
            }
          }

          if (downloadsDir == null) {
            throw Exception('Could not determine downloads directory');
          }

          final params = BackupIsolateParams(
            sendPort: _backupReceivePort!.sendPort,
            options: options,
            libraryItems: data.items,
            downloads: _downloaderController.data.queue,
            tempDirectoryPath: tempDir.path,
            downloadsDirectoryPath: downloadsDir.path,
            applicationSupportDirectoryPath: appSupportDir.path,
          );

          // Listen to progress updates
          _backupStreamSubscription =
              _backupReceivePort!.listen((message) async {
            if (message is BackupProgressMessage) {
              // Handle Android MediaStore save
              if (Platform.isAndroid &&
                  message.tempFilePath != null &&
                  !message.isComplete) {
                try {
                  final fileName = path.basename(message.tempFilePath!);

                  await mediaStorePlugin.saveFile(
                    dirName: DirName.download,
                    dirType: DirType.download,
                    tempFilePath: message.tempFilePath!,
                    relativePath: path.join('Musily', 'backups'),
                  );

                  // Update with completion
                  updateData(data.copyWith(
                    backupInProgress: false,
                    backupProgress: 1.0,
                    backupMessage: 'Saved to: $fileName',
                    backupMessageKey: 'savedTo',
                    backupMessageParams: {'filename': fileName},
                    clearBackupActivityType: true,
                  ));

                  _cleanupBackupIsolate();
                  return;
                } catch (e) {
                  _cleanupBackupIsolate();
                  updateData(data.copyWith(
                    backupInProgress: false,
                    clearBackupActivityType: true,
                  ));
                  catchError(Exception('Failed to save backup: $e'));
                  return;
                }
              }

              updateData(data.copyWith(
                backupProgress: message.progress,
                backupMessage: message.message,
                backupMessageKey: message.messageKey,
                backupMessageParams: message.messageParams,
              ));

              if (message.isComplete) {
                _cleanupBackupIsolate();

                if (message.error != null) {
                  updateData(data.copyWith(
                    backupInProgress: false,
                    clearBackupActivityType: true,
                  ));
                  catchError(Exception(message.error));
                } else {
                  updateData(data.copyWith(
                    backupInProgress: false,
                    backupProgress: 1.0,
                    backupMessage: message.message,
                    backupMessageKey: message.messageKey,
                    backupMessageParams: message.messageParams,
                    clearBackupActivityType: true,
                  ));

                  final contextStack = ContextManager().contextStack;
                  if (contextStack.isNotEmpty) {
                    final context = contextStack.last.context;
                    LySnackbar.showSuccess(
                      context.localization.backupCompletedSuccessfully,
                    );
                  }
                  if (data.items.isEmpty) {
                    await methods.getLibraryItems();
                  }
                }
              }
            }
          });

          // Start backup isolate
          _backupIsolate = await Isolate.spawn(
            LibraryBackupIsolate.backupLibraryIsolate,
            params,
          );
        } catch (e) {
          _cleanupBackupIsolate();
          updateData(data.copyWith(
            backupInProgress: false,
            clearBackupActivityType: true,
          ));
          catchError(e);
        }
      },

      restoreLibrary: (backupFile) async {
        if (data.backupInProgress) {
          return; // Already restoring
        }

        try {
          updateData(data.copyWith(
            backupInProgress: true,
            backupProgress: 0.0,
            backupMessage: 'Starting restore...',
            backupMessageKey: 'startingRestore',
            backupActivityType: BackupActivityType.restore,
          ));

          // Setup isolate communication
          _backupReceivePort = ReceivePort();

          final existingFavorites =
              data.items.where((e) => e.id.startsWith('favorites')).firstOrNull;

          // Get directory paths (must be done in main isolate)
          final appSupportDir = await getApplicationSupportDirectory();

          final params = RestoreIsolateParams(
            sendPort: _backupReceivePort!.sendPort,
            backupFilePath: backupFile.path,
            existingDownloadHashes: _downloaderController.data.queue
                .map((e) => e.track.hash)
                .toList(),
            existingFavoritesId: existingFavorites?.id,
            applicationSupportDirectoryPath: appSupportDir.path,
          );

          // Listen to progress updates and results
          _backupStreamSubscription =
              _backupReceivePort!.listen((message) async {
            if (message is BackupProgressMessage) {
              updateData(data.copyWith(
                backupProgress: message.progress,
                backupMessage: message.message,
                backupMessageKey: message.messageKey,
                backupMessageParams: message.messageParams,
              ));

              if (message.isComplete) {
                if (message.error != null) {
                  _cleanupBackupIsolate();
                  updateData(data.copyWith(
                    backupInProgress: false,
                    clearBackupActivityType: true,
                  ));
                  catchError(Exception(message.error));
                }
              }
            } else if (message is RestoreResultMessage) {
              // Handle restored data
              if (message.hasLibrary && message.libraryItems != null) {
                if (message.favoritesPlaylist != null) {
                  await methods.addTracksToPlaylist(
                    UserService.favoritesId,
                    message.favoritesPlaylist!.playlist?.tracks ?? [],
                  );
                }
                await methods.mergeLibrary(message.libraryItems!);
              }

              if (message.hasDownloads && message.tracks != null) {
                for (final track in message.tracks!) {
                  if (_downloaderController.methods.getItem(track) == null) {
                    final item = DownloadingItem(
                      track: track,
                      progress: 1,
                      status: DownloadStatus.completed,
                    );

                    _downloaderController.data.queue.add(item);

                    _downloaderController.data.addToMap(item);

                    final isar = Database().isar;
                    await isar.writeTxn(() async {
                      final dbItem = DownloadQueueItem()
                        ..hash = track.hash
                        ..trackId = track.id
                        ..title = track.title
                        ..artistId = track.artist.id
                        ..artistName = track.artist.name
                        ..albumId = track.album.id
                        ..albumTitle = track.album.title
                        ..highResImg = track.highResImg
                        ..lowResImg = track.lowResImg
                        ..url = track.url
                        ..durationSeconds = track.duration.inSeconds
                        ..progress = 1.0
                        ..status = DownloadStatus.completed.name
                        ..addedAt = DateTime.now().millisecondsSinceEpoch;

                      await isar.downloadQueueItems.put(dbItem);
                    });
                  }
                }

                _downloaderController.updateData(_downloaderController.data);
              }
              _cleanupBackupIsolate();
              updateData(data.copyWith(
                backupInProgress: false,
                backupProgress: 1.0,
                clearBackupActivityType: true,
              ));
              await methods.getLibraryItems(showLoading: false);
              final contextStack = ContextManager().contextStack;
              if (contextStack.isNotEmpty) {
                final context = contextStack.last.context;
                LySnackbar.showSuccess(
                  context.localization.backupRestoredSuccessfully,
                );
              }
            }
          });

          // Start restore isolate
          _backupIsolate = await Isolate.spawn(
            LibraryBackupIsolate.restoreLibraryIsolate,
            params,
          );
        } catch (e) {
          _cleanupBackupIsolate();
          updateData(data.copyWith(
            backupInProgress: false,
            clearBackupActivityType: true,
          ));
          catchError(e);
        }
      },

      pickBackupFile: () async {
        try {
          final result = await FilePicker.platform.pickFiles(
            allowMultiple: false,
            type: FileType.any,
          );

          if (result != null && result.files.single.path != null) {
            if (result.files.single.path!.endsWith('.lybak')) {
              return File(result.files.single.path!);
            }
          }
          return null;
        } catch (e) {
          return null;
        }
      },

      cancelBackup: () async {
        _cleanupBackupIsolate();
        updateData(data.copyWith(
          backupInProgress: false,
          backupProgress: 0.0,
          backupMessage: 'Backup cancelled',
          backupMessageKey: 'backupCancelled',
          clearBackupActivityType: true,
        ));
      },
    );
  }

  Future<void> _loadLocalPlaylists() async {
    final playlists = await _localLibraryService.loadPlaylists();
    updateData(data.copyWith(localPlaylists: playlists));
    for (final playlist in playlists) {
      unawaited(_refreshLocalPlaylistMetadata(playlist));
    }
  }

  Future<void> _addLocalPlaylistFolder(
    String name,
    String directoryPath,
  ) async {
    final normalizedPath = _normalizeDirectoryPath(directoryPath);
    if (normalizedPath == null) {
      return;
    }

    final alreadyRegistered = data.localPlaylists.any(
      (element) =>
          element.directoryPath.toLowerCase() == normalizedPath.toLowerCase(),
    );
    if (alreadyRegistered) {
      return;
    }

    final derivedName =
        name.trim().isEmpty ? path.basename(normalizedPath) : name.trim();

    var playlist = LocalLibraryPlaylist(
      id: idGenerator(),
      name: derivedName,
      directoryPath: normalizedPath,
      createdAt: DateTime.now(),
    );

    playlist = await _scanLocalPlaylist(playlist);

    final updated = [...data.localPlaylists, playlist];
    await _persistLocalPlaylists(updated);
  }

  Future<void> _removeLocalPlaylistFolder(String playlistId) async {
    final updated = data.localPlaylists
        .where((element) => element.id != playlistId)
        .toList();
    await _persistLocalPlaylists(updated);
  }

  Future<void> _renameLocalPlaylistFolder(
    String playlistId,
    String newName,
  ) async {
    final trimmed = newName.trim();
    if (trimmed.isEmpty) {
      return;
    }

    final updated = data.localPlaylists.map((playlist) {
      if (playlist.id == playlistId) {
        return playlist.copyWith(
          name: trimmed,
          updatedAt: DateTime.now(),
        );
      }
      return playlist;
    }).toList();

    await _persistLocalPlaylists(updated);
  }

  Future<void> _updateLocalPlaylistDirectory(
    String playlistId,
    String newDirectoryPath,
  ) async {
    final normalizedPath = _normalizeDirectoryPath(newDirectoryPath);
    if (normalizedPath == null) {
      return;
    }

    final playlist =
        data.localPlaylists.firstWhereOrNull((e) => e.id == playlistId);
    if (playlist == null) {
      return;
    }

    var updatedPlaylist = playlist.copyWith(
      directoryPath: normalizedPath,
      updatedAt: DateTime.now(),
    );
    updatedPlaylist = await _scanLocalPlaylist(updatedPlaylist);
    await _replaceLocalPlaylist(updatedPlaylist);
  }

  Future<List<TrackEntity>> _getLocalPlaylistTracks(String playlistId) async {
    final playlist =
        data.localPlaylists.firstWhereOrNull((e) => e.id == playlistId);
    if (playlist == null) {
      return [];
    }
    final tracks = await _buildTracksForPlaylist(playlist);
    final updatedPlaylist = playlist.copyWith(
      trackCount: tracks.length,
      updatedAt: DateTime.now(),
    );
    await _replaceLocalPlaylist(updatedPlaylist);
    return tracks;
  }

  Future<void> _refreshAllLocalPlaylists() async {
    for (final playlist in data.localPlaylists) {
      await _refreshLocalPlaylistMetadata(playlist);
    }
  }

  Future<void> _refreshLocalPlaylistMetadata(
    LocalLibraryPlaylist playlist,
  ) async {
    final scanned = await _scanLocalPlaylist(playlist);
    await _replaceLocalPlaylist(scanned);
  }

  Future<LocalLibraryPlaylist> _scanLocalPlaylist(
    LocalLibraryPlaylist playlist,
  ) async {
    try {
      final files = await _listAudioFiles(playlist.directoryPath);
      return playlist.copyWith(
        trackCount: files.length,
        updatedAt: DateTime.now(),
      );
    } catch (e, stackTrace) {
      log(
        '[LocalLibrary] Error scanning playlist',
        error: e,
        stackTrace: stackTrace,
      );
      return playlist.copyWith(
        trackCount: 0,
        updatedAt: DateTime.now(),
      );
    }
  }

  Future<List<File>> _listAudioFiles(String directoryPath) async {
    final directory = Directory(directoryPath);
    if (!await directory.exists()) {
      return [];
    }
    final files = <File>[];
    try {
      final stream = directory.list(recursive: true, followLinks: false);

      await for (final entity in stream) {
        if (entity is File) {
          final extension = path.extension(entity.path).toLowerCase();
          if (_supportedAudioExtensions.contains(extension)) {
            files.add(entity);
          }
        }
      }
    } catch (e, stackTrace) {
      log(
        '[LocalLibrary] Error scanning directory',
        error: e,
        stackTrace: stackTrace,
      );

      return files;
    }
    return files;
  }

  Future<List<TrackEntity>> _buildTracksForPlaylist(
    LocalLibraryPlaylist playlist,
  ) async {
    final files = await _listAudioFiles(playlist.directoryPath);
    final tracks = <TrackEntity>[];
    for (var i = 0; i < files.length; i++) {
      tracks.add(await _fileToTrack(files[i], i, playlist));
    }
    return tracks;
  }

  Future<TrackEntity> _fileToTrack(
    File file,
    int index,
    LocalLibraryPlaylist playlist,
  ) async {
    final metadata = await _getTrackMetadata(file);
    final fallbackTitle = path.basenameWithoutExtension(file.path);
    final title = metadata?.title ??
        (fallbackTitle.isEmpty ? 'Track ${index + 1}' : fallbackTitle);
    final artistName = _resolveArtistName(metadata);
    final album = SimplifiedAlbum(
      id: playlist.id,
      title: metadata?.album ?? playlist.name,
    );

    return TrackEntity(
      id: 'local_track_${playlist.id}_$index',
      orderIndex: index,
      title: title.isEmpty ? 'Track ${index + 1}' : title,
      hash: file.path,
      artist: SimplifiedArtist(
        id: 'local_artist_${artistName.hashCode}',
        name: artistName,
      ),
      album: album,
      highResImg: metadata?.artworkPath,
      lowResImg: metadata?.artworkPath,
      source: 'local_directory',
      fromSmartQueue: false,
      duration: Duration.zero,
      position: Duration.zero,
      url: file.uri.toString(),
      isLocal: true,
    );
  }

  Future<void> _ensureTrackMetadataCacheLoaded() async {
    if (_localTrackMetadataLoaded) {
      return;
    }
    _localTrackMetadataCache = await _localLibraryService.loadTrackMetadata();
    _localTrackMetadataLoaded = true;
  }

  Future<LocalTrackMetadata?> _getTrackMetadata(File file) async {
    await _ensureTrackMetadataCacheLoaded();
    final cached = _localTrackMetadataCache[file.path];
    if (cached != null) {
      final finalized = await _finalizeMetadataArtwork(cached, file);
      if (!identical(finalized, cached)) {
        _localTrackMetadataCache[file.path] = finalized;
        unawaited(
          _localLibraryService.saveTrackMetadata(_localTrackMetadataCache),
        );
      }
      return finalized;
    }
    final extracted = await _extractTrackMetadata(file);
    if (extracted != null) {
      final finalized = await _finalizeMetadataArtwork(extracted, file);
      _localTrackMetadataCache[file.path] = finalized;
      unawaited(
        _localLibraryService.saveTrackMetadata(_localTrackMetadataCache),
      );
      return finalized;
    }
    return extracted;
  }

  Future<LocalTrackMetadata?> _extractTrackMetadata(File file) async {
    try {
      final metadata = readMetadata(file, getImage: true);

      String? title;
      String? artist;
      String? album;
      String? artworkPath;

      try {
        final dynamic dynMetadata = metadata;

        title = _safeMetadataString(() => dynMetadata.title) ??
            _safeMetadataString(() => dynMetadata.songName) ??
            _safeMetadataString(() => dynMetadata.trackName);

        artist = _safeMetadataString(() => dynMetadata.artist) ??
            _safeMetadataString(() => dynMetadata.albumArtist) ??
            _safeMetadataString(() => dynMetadata.trackArtist) ??
            _safeMetadataString(() => dynMetadata.trackArtistNames);

        album = _safeMetadataString(() => dynMetadata.album) ??
            _safeMetadataString(() => dynMetadata.albumName);

        try {
          List<Picture>? pictures;
          try {
            pictures = dynMetadata.pictures;
          } catch (_) {}

          if (pictures != null && pictures.isNotEmpty) {
            final picture = pictures.first;
            if (picture.bytes.isNotEmpty) {
              String mime = 'image/jpeg';
              try {
                final dynamic dynPic = picture;
                mime = dynPic.mimeType ?? dynPic.mime ?? 'image/jpeg';
              } catch (_) {}
              artworkPath = await _storeArtworkBytes(file, picture.bytes, mime);
            }
          }
        } catch (e) {
          log('[LocalLibrary] Error extracting artwork: $e');
        }
      } catch (e) {
        log('[LocalLibrary] Error accessing metadata properties: $e');
      }

      if (title == null &&
          artist == null &&
          album == null &&
          artworkPath == null) {
        return null;
      }

      final result = LocalTrackMetadata(
        title: title?.trim().isEmpty == true ? null : title?.trim(),
        artist: artist?.trim().isEmpty == true ? null : artist?.trim(),
        album: album?.trim().isEmpty == true ? null : album?.trim(),
        artworkPath: artworkPath,
      );

      return result;
    } catch (e, stackTrace) {
      log(
        '[LocalLibrary] Failed to extract metadata for ${file.path}',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  String? _safeMetadataString(dynamic Function() getter) {
    try {
      final value = getter();
      return _stringifyMetadataField(value);
    } catch (_) {
      return null;
    }
  }

  String? _stringifyMetadataField(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is String) {
      final trimmed = value.trim();
      return trimmed.isEmpty ? null : trimmed;
    }
    if (value is List && value.isNotEmpty) {
      final first = value.first;
      if (first is String) {
        final trimmed = first.trim();
        return trimmed.isEmpty ? null : trimmed;
      }
    }
    return null;
  }

  Future<LocalTrackMetadata> _finalizeMetadataArtwork(
    LocalTrackMetadata metadata,
    File sourceFile,
  ) async {
    var updated = metadata;
    final artworkPath = metadata.artworkPath;
    if (artworkPath == null) {
      return updated;
    }
    if (artworkPath.startsWith('data:')) {
      final stored = await _storeArtworkFromDataUri(sourceFile, artworkPath);
      updated = updated.copyWith(artworkPath: stored);
    } else if (artworkPath.startsWith('file://')) {
      updated = updated.copyWith(
        artworkPath: artworkPath.replaceFirst('file://', ''),
      );
    }

    final normalizedPath = updated.artworkPath;
    if (normalizedPath == null) {
      return updated;
    }

    final exists = await File(normalizedPath).exists();
    if (!exists) {
      return updated.copyWith(artworkPath: null);
    }
    return updated;
  }

  Future<String?> _storeArtworkFromDataUri(
    File sourceFile,
    String dataUri,
  ) async {
    final commaIndex = dataUri.indexOf(',');
    if (commaIndex == -1) {
      return null;
    }
    final header = dataUri.substring(0, commaIndex);
    final base64Part = dataUri.substring(commaIndex + 1);
    final mimeType = header.replaceFirst('data:', '').split(';').first;
    try {
      final bytes = base64Decode(base64Part);
      return _storeArtworkBytes(sourceFile, bytes, mimeType);
    } catch (e) {
      log('[LocalLibrary] Failed to decode legacy artwork data URI', error: e);
      return null;
    }
  }

  Future<String> _storeArtworkBytes(
    File sourceFile,
    Uint8List bytes,
    String? mime,
  ) async {
    final supportDir = await getApplicationSupportDirectory();
    final artworkDir = Directory(path.join(supportDir.path, 'local_artworks'));
    if (!await artworkDir.exists()) {
      await artworkDir.create(recursive: true);
    }

    final lastModified = await sourceFile.lastModified();
    final fingerprint =
        '${sourceFile.path}-${lastModified.millisecondsSinceEpoch}-${bytes.length}';
    final hash = sha1.convert(utf8.encode(fingerprint)).toString();
    final extension = _extensionFromMime(mime);
    final artworkFile = File(path.join(artworkDir.path, '$hash$extension'));
    await artworkFile.writeAsBytes(bytes, flush: true);
    return artworkFile.path;
  }

  String _extensionFromMime(String? mime) {
    switch (mime) {
      case 'image/png':
        return '.png';
      case 'image/webp':
        return '.webp';
      case 'image/gif':
        return '.gif';
      default:
        return '.jpg';
    }
  }

  String _resolveArtistName(LocalTrackMetadata? metadata) {
    final value = metadata?.artist;
    if (value == null || value.trim().isEmpty) {
      return _localizedLocalFilesLabel();
    }
    return value;
  }

  String _localizedLocalFilesLabel() {
    try {
      final contextManager = ContextManager();
      final dialogContext = contextManager.dialogStack.lastOrNull?.context ??
          contextManager.dialogStack.firstOrNull?.context;
      final stackContext = contextManager.contextStack.lastOrNull?.context ??
          contextManager.contextStack.firstOrNull?.context;
      final context = dialogContext ?? stackContext;
      if (context != null) {
        return context.localization.localFilesLabel;
      }
    } catch (_) {
      // ignore and fall back
    }
    return 'Local Files';
  }

  Future<void> _replaceLocalPlaylist(
    LocalLibraryPlaylist updatedPlaylist,
  ) async {
    final updated = data.localPlaylists.map((playlist) {
      if (playlist.id == updatedPlaylist.id) {
        return updatedPlaylist;
      }
      return playlist;
    }).toList();
    await _persistLocalPlaylists(updated);
  }

  Future<void> _persistLocalPlaylists(
    List<LocalLibraryPlaylist> playlists,
  ) async {
    playlists.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );
    await _localLibraryService.savePlaylists(playlists);
    updateData(data.copyWith(localPlaylists: playlists));
  }

  String? _normalizeDirectoryPath(String? rawPath) {
    if (rawPath == null) {
      return null;
    }
    final trimmed = rawPath.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    final normalized = path.normalize(trimmed);
    if (Platform.isWindows) {
      return normalized.replaceAll('/', '\\');
    }
    return normalized.replaceAll('\\', '/');
  }

  void _cleanupBackupIsolate() {
    _backupStreamSubscription?.cancel();
    _backupStreamSubscription = null;
    _backupReceivePort?.close();
    _backupReceivePort = null;
    _backupIsolate?.kill(priority: Isolate.immediate);
    _backupIsolate = null;
  }

  @override
  void dispose() {
    _cleanupBackupIsolate();
    super.dispose();
  }
}
