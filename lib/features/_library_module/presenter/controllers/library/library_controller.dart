import 'package:musily/core/data/services/user_service.dart';
import 'package:musily/core/domain/presenter/app_controller.dart';
import 'package:musily/core/presenter/extensions/string.dart';
import 'package:musily/core/utils/id_generator.dart';
import 'package:musily/features/_library_module/data/models/library_item_model.dart';
import 'package:musily/features/_library_module/domain/entities/library_item_entity.dart';
import 'package:musily/features/_library_module/domain/usecases/add_album_to_library_usecase.dart';
import 'package:musily/features/_library_module/domain/usecases/add_artist_to_library_usecase.dart';
import 'package:musily/features/_library_module/domain/usecases/add_tracks_to_playlist_usecase.dart';
import 'package:musily/features/_library_module/domain/usecases/create_playlist_usecase.dart';
import 'package:musily/features/_library_module/domain/usecases/delete_playlist_usecase.dart';
import 'package:musily/features/_library_module/domain/usecases/get_library_item_usecase.dart';
import 'package:musily/features/_library_module/domain/usecases/get_library_items_usecase.dart';
import 'package:musily/features/_library_module/domain/usecases/remove_album_from_library_usecase.dart';
import 'package:musily/features/_library_module/domain/usecases/remove_artist_from_library_usecase.dart';
import 'package:musily/features/_library_module/domain/usecases/remove_tracks_from_playlist_usecase.dart';
import 'package:musily/features/_library_module/domain/usecases/update_library_item_usecase.dart';
import 'package:musily/features/_library_module/domain/usecases/update_playlist_usecase.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_data.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_methods.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';
import 'package:musily/features/playlist/domain/entities/playlist_entity.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
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
  late final AddArtistToLibraryUsecase _addArtistToLibraryUsecase;
  late final RemoveArtistFromLibraryUsecase _removeArtistFromLibraryUsecase;
  late final AddAlbumToLibraryUsecase _addAlbumToLibraryUsecase;
  late final RemoveAlbumFromLibraryUsecase _removeAlbumFromLibraryUsecase;
  late final DeletePlaylistUsecase _deletePlaylistUsecase;
  late final UpdateLibraryItemUsecase _updateLibraryItemUsecase;

  LibraryController({
    required GetLibraryItemsUsecase getLibraryUsecase,
    required GetLibraryItemUsecase getLibraryItemUsecase,
    required DownloaderController downloaderController,
    required PlayerController playerController,
    required UpdatePlaylistUsecase updatePlaylistUsecase,
    required AddTracksToPlaylistUsecase addTracksToPlaylistUsecase,
    required CreatePlaylistUsecase createPlaylistUsecase,
    required RemoveTracksFromPlaylistUsecase removeTracksFromPlaylistUsecase,
    required AddArtistToLibraryUsecase addArtistToLibraryUsecase,
    required RemoveArtistFromLibraryUsecase removeArtistFromLibraryUsecase,
    required AddAlbumToLibraryUsecase addAlbumToLibraryUsecase,
    required RemoveAlbumFromLibraryUsecase removeAlbumFromLibraryUsecase,
    required DeletePlaylistUsecase deletePlaylistUsecase,
    required UpdateLibraryItemUsecase updateLibraryItemUsecase,
  }) {
    _getLibraryItemsUsecase = getLibraryUsecase;
    _getLibraryItemUsecase = getLibraryItemUsecase;
    _downloaderController = downloaderController;
    _playerController = playerController;
    _updatePlaylistUsecase = updatePlaylistUsecase;
    _addTracksToPlaylistUsecase = addTracksToPlaylistUsecase;
    _createPlaylistUsecase = createPlaylistUsecase;
    _removeTracksFromPlaylistUsecase = removeTracksFromPlaylistUsecase;
    _addArtistToLibraryUsecase = addArtistToLibraryUsecase;
    _removeArtistFromLibraryUsecase = removeArtistFromLibraryUsecase;
    _addAlbumToLibraryUsecase = addAlbumToLibraryUsecase;
    _removeAlbumFromLibraryUsecase = removeAlbumFromLibraryUsecase;
    _deletePlaylistUsecase = deletePlaylistUsecase;
    _updateLibraryItemUsecase = updateLibraryItemUsecase;

    methods.getLibraryItems();
    if (data.loadedFavoritesHash.isEmpty) {
      methods.loadFavorites();
    }
  }

  final queue = Queue(
    delay: const Duration(
      milliseconds: 100,
    ),
  );

  @override
  LibraryData defineData() {
    return LibraryData(
      loading: true,
      loadedFavoritesHash: [],
      alreadyLoadedFirstFavoriteState: [],
      items: [],
      itemsAddingToLibrary: [],
      itemsAddingToFavorites: [],
    );
  }

  @override
  LibraryMethods defineMethods() {
    return LibraryMethods(
      // Library
      getLibraryItems: ({bool showLoading = true}) async {
        updateData(
          data.copyWith(
            loading: showLoading,
          ),
        );
        final items = await _getLibraryItemsUsecase.exec();
        await methods.loadFavorites();
        updateData(
          data.copyWith(
            items: items,
            loading: false,
          ),
        );
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
                items: this.data.items
                  ..insert(
                    0,
                    libraryItem,
                  ),
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
                    ..removeWhere(
                      (e) => e == tempId,
                    ),
                ),
          );
        } catch (e) {
          catchError(e);
        }
      },
      addTracksToPlaylist: (playlistId, tracks) async {
        if (_playerController.data.tracksFromSmartQueue
                .contains(tracks.firstOrNull?.hash) &&
            _playerController.data.playingId == playlistId) {
          _playerController.updateData(
            _playerController.data.copyWith(
              tracksFromSmartQueue: _playerController.data.tracksFromSmartQueue
                ..removeWhere(
                  (item) => item == tracks.firstOrNull?.hash,
                ),
            ),
          );
          _playerController.methods.getSmartQueue(
            customItems: tracks,
          );
        }
        if (playlistId.startsWith('favorites')) {
          if (data.items
              .where(
                (e) => e.id == UserService.favoritesId,
              )
              .isEmpty) {
            data.items.add(LibraryItemModel.newInstance(
              id: UserService.favoritesId,
              synced: false,
              playlist: PlaylistEntity(
                id: UserService.favoritesId,
                title: 'favorites',
                tracks: [],
                trackCount: 0,
              ),
            ));
          }
          updateData(
            data.copyWith(
              itemsAddingToFavorites: data.itemsAddingToFavorites
                ..addAll(
                  tracks.map(
                    (e) => e.id,
                  ),
                ),
              loadedFavoritesHash: data.loadedFavoritesHash
                ..addAll(
                  tracks.map((e) => e.hash),
                ),
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
            itemsAddingToLibrary: data.itemsAddingToLibrary
              ..add(
                playlistId,
              ),
          ),
        );
        try {
          await queue.add(() async {
            await _addTracksToPlaylistUsecase.exec(
              playlistId,
              tracks,
            );
            await methods.getLibraryItem(playlistId);
          });
          updateData(
            data.copyWith(
              itemsAddingToLibrary: data.itemsAddingToLibrary
                ..removeWhere(
                  (e) => playlistId == e,
                ),
              itemsAddingToFavorites: data.itemsAddingToFavorites
                ..removeWhere(
                  (e) => tracks
                      .map(
                        (e) => e.id,
                      )
                      .contains(e),
                ),
            ),
          );
        } catch (e) {
          currentItem?.playlist?.tracks.removeWhere((e) => tracks.contains(e));
          if (playlistId.startsWith('favorites')) {
            updateData(
              data.copyWith(
                itemsAddingToLibrary: data.itemsAddingToLibrary
                  ..removeWhere(
                    (e) => playlistId == e,
                  ),
                itemsAddingToFavorites: data.itemsAddingToFavorites
                  ..removeWhere(
                    (e) => tracks
                        .map(
                          (e) => e.id,
                        )
                        .contains(e),
                  ),
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
              return {
                'index': index,
                'item': e,
              };
            }) ??
            [];
        if (playlistId.startsWith('favorites')) {
          updateData(
            data.copyWith(
              itemsAddingToFavorites: data.itemsAddingToFavorites
                ..addAll(tracksIds),
              loadedFavoritesHash: data.loadedFavoritesHash
                ..removeWhere(
                  (e) {
                    final trackList = currentItem?.playlist?.tracks.where(
                      (track) => tracksIds.contains(track.id),
                    );
                    return trackList?.map((track) => track.hash).contains(e) ??
                        false;
                  },
                ),
            ),
          );
        }
        currentItem?.playlist?.tracks
            .removeWhere((e) => tracksIds.contains(e.id));
        updateData(data);
        try {
          await queue.add(() async {
            await _removeTracksFromPlaylistUsecase.exec(playlistId, tracksIds);
            await methods.getLibraryItem(playlistId);
          });
          updateData(
            data.copyWith(
              itemsAddingToFavorites: data.itemsAddingToFavorites
                ..removeWhere(
                  (e) => tracksIds.contains(e),
                ),
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
                  ..removeWhere(
                    (e) => tracksIds.contains(e),
                  ),
                loadedFavoritesHash: data.loadedFavoritesHash
                  ..addAll(
                    tracksToRemove.map((e) => (e['item'] as TrackEntity).hash),
                  ),
              ),
            );
          }
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
              items: data.items
                ..removeWhere(
                  (e) => e.id == artist.id,
                ),
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
                ..removeWhere(
                  (e) => e == artistId,
                ),
            ),
          );
        } catch (e) {
          updateData(
            data.copyWith(
              itemsAddingToLibrary: data.itemsAddingToLibrary
                ..removeWhere(
                  (e) => e == artistId,
                ),
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
                ..removeWhere(
                  (e) => e == albumId,
                ),
            ),
          );
        } catch (e) {
          updateData(
            data.copyWith(
              itemsAddingToLibrary: data.itemsAddingToLibrary
                ..removeWhere(
                  (e) => e == albumId,
                ),
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
        final lastTimePlayed =
            data.items.elementAtOrNull(index)?.lastTimePlayed;
        try {
          if (index > 0) {
            final item = data.items[index];
            item.lastTimePlayed = DateTime.now();
            updateData(data);
            await queue.add(() async {
              await _updateLibraryItemUsecase.exec(item);
            });
          }
        } catch (e) {
          if (lastTimePlayed != null) {
            data.items[index].lastTimePlayed = lastTimePlayed;
            updateData(data);
          }
          catchError(e);
        }
      },

      // Download
      downloadCollection: (tracks, downloadingId) async {
        _downloaderController.methods.setDownloadingKey(
          downloadingId,
        );
        for (final track in tracks) {
          if ((track.url ?? '').isUrl) {
            continue;
          }
          _downloaderController.methods.addDownload(
            track,
          );
        }
      },
      cancelCollectionDownload: (tracks, downloadingId) async {
        _downloaderController.methods.setDownloadingKey('');
        await _downloaderController.methods.cancelDownloadCollection(
          tracks,
        );
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
                ..removeWhere(
                  (e) => e == playlistId,
                ),
            ),
          );
        } catch (e) {
          updateData(
            data.copyWith(
              itemsAddingToLibrary: data.itemsAddingToLibrary
                ..removeWhere(
                  (e) => e == playlistId,
                ),
              items: data.items..insert(index, currentItem),
            ),
          );
          catchError(e);
        }
      },
    );
  }
}
