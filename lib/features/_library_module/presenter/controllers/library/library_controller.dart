import 'package:musily/core/domain/presenter/app_controller.dart';
import 'package:musily/features/_library_module/domain/entities/library_item_entity.dart';
import 'package:musily/features/_library_module/domain/usecases/add_to_library_usecase.dart';
import 'package:musily/features/_library_module/domain/usecases/delete_library_item_usecase.dart';
import 'package:musily/features/_library_module/domain/usecases/get_library_item_usecase.dart';
import 'package:musily/features/_library_module/domain/usecases/get_library_items_usecase.dart';
import 'package:musily/features/_library_module/domain/usecases/update_library_item_usecase.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_data.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_methods.dart';
import 'package:musily_player/core/utils/is_valid_directory.dart';
import 'package:musily_player/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/track/data/models/track_model.dart';
import 'package:musily_player/presenter/controllers/player/player_controller.dart';
import 'package:musily/features/playlist/domain/entities/playlist_entity.dart';

class LibraryController extends BaseController<LibraryData, LibraryMethods> {
  late final GetLibraryItemsUsecase _getLibraryItemsUsecase;
  late final AddToLibraryUsecase _addToLibraryUsecase;
  late final UpdateLibraryItemUsecase _updateLibraryItemUsecase;
  late final GetLibraryItemUsecase _getLibraryItemUsecase;
  late final DeleteLibraryItemUsecase _deleteLibraryItemUsecase;
  late final DownloaderController _downloaderController;
  late final PlayerController _playerController;

  LibraryController({
    required GetLibraryItemsUsecase getLibraryUsecase,
    required AddToLibraryUsecase addToLibraryUsecase,
    required UpdateLibraryItemUsecase updateLibraryItemUsecase,
    required GetLibraryItemUsecase getLibraryItemUsecase,
    required DeleteLibraryItemUsecase deleteLibraryItemUsecase,
    required DownloaderController downloaderController,
    required PlayerController playerController,
  }) {
    _getLibraryItemsUsecase = getLibraryUsecase;
    _addToLibraryUsecase = addToLibraryUsecase;
    _updateLibraryItemUsecase = updateLibraryItemUsecase;
    _getLibraryItemUsecase = getLibraryItemUsecase;
    _deleteLibraryItemUsecase = deleteLibraryItemUsecase;
    _downloaderController = downloaderController;
    _playerController = playerController;
    methods.getLibrary();
    if (data.loadedFavoritesHash.isEmpty) {
      methods.loadFavorites();
    }
  }

  @override
  LibraryData defineData() {
    return LibraryData(
      loading: true,
      addingToLibrary: false,
      loadedFavoritesHash: [],
      alreadyLoadedFirstFavoriteState: [],
      items: [],
      addingToFavorites: false,
    );
  }

  @override
  LibraryMethods defineMethods() {
    return LibraryMethods(
      updateLastTimePlayed: (id) async {
        final item = await _getLibraryItemUsecase.exec(id);
        if (item != null) {
          item.lastTimePlayed = DateTime.now();
          await _updateLibraryItemUsecase.exec(
            id,
            item,
          );
          final loadedItem =
              data.items.where((element) => element.id == id).firstOrNull;
          if (loadedItem != null) {
            updateData(
              data.copyWith(
                items: data.items..[data.items.indexOf(loadedItem)] = item,
              ),
            );
          }
          updateData(data);
        }
      },
      removeFromPlaylist: (playlistId, track) async {
        if (playlistId == 'favorites') {
          methods.toggleFavorite(track);
          methods.getLibrary();
          return;
        }
        final playlist = await _getLibraryItemUsecase.exec<PlaylistEntity>(
          playlistId,
        );
        if (playlist != null) {
          await _updateLibraryItemUsecase.exec<PlaylistEntity>(
            playlistId,
            playlist
              ..value.tracks.removeWhere(
                    (element) => element.hash == track.hash,
                  ),
          );
        }
        methods.getLibrary();
      },
      updatePlaylistName: (id, name) async {
        final playlist = await _getLibraryItemUsecase.exec<PlaylistEntity>(id);
        if (playlist != null) {
          await _updateLibraryItemUsecase.exec<PlaylistEntity>(
            id,
            playlist..value.title = name,
          );
        }
        methods.getLibrary();
      },
      getLibraryItem: (id) async {
        final item = await _getLibraryItemUsecase.exec(id);
        return item;
      },
      addToLibrary: <T>(item) async {
        updateData(
          data.copyWith(
            addingToLibrary: true,
          ),
        );
        await _addToLibraryUsecase.exec<T>(item);
        updateData(
          data.copyWith(
            addingToLibrary: false,
          ),
        );
        await methods.getLibrary();
        dispatchEvent(
          BaseControllerEvent(
            id: 'libraryToggled',
            data: data,
          ),
        );
      },
      getLibrary: () async {
        updateData(
          data.copyWith(
            loading: true,
          ),
        );
        final items = await _getLibraryItemsUsecase.exec();
        updateData(
          data.copyWith(
            loading: false,
            items: items,
          ),
        );
      },
      addToPlaylist: (tracks, playlistId) async {
        if (playlistId == 'favorites') {
          for (final track in tracks) {
            await methods.toggleFavorite(
              track,
              ignoreIfAdded: true,
            );
          }
          return;
        }
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
            customItems: [
              ...tracks.map((e) => TrackModel.toMusilyTrack(e)),
            ],
          );
        }
        late final LibraryItemEntity<PlaylistEntity>? playlist;
        final item = await _getLibraryItemUsecase.exec(
          playlistId,
        );

        if (item?.value is PlaylistEntity) {
          playlist = item as LibraryItemEntity<PlaylistEntity>;
        } else {
          playlist = null;
        }

        if (playlist != null) {
          final currentPlaylistItemsHash = playlist.value.tracks.map(
            (element) => element.hash,
          );
          final filteredTracks = tracks.where(
            (track) => !currentPlaylistItemsHash.contains(
              track.hash,
            ),
          );
          for (final track in filteredTracks) {
            playlist.value.tracks.add(track);
          }
          await _updateLibraryItemUsecase.exec<PlaylistEntity>(
            playlistId,
            playlist,
          );
          methods.getLibrary();
        } else {
          methods.toggleFavorite(
            tracks.first,
            ignoreIfAdded: true,
          );
        }
      },
      deleteLibraryItem: (id) async {
        if (id == 'favorites') {
          updateData(
            data.copyWith(
              loadedFavoritesHash: [],
            ),
          );
        }
        await _deleteLibraryItemUsecase.exec(id);
        dispatchEvent(
          BaseControllerEvent(
            id: 'libraryToggled',
            data: data,
          ),
        );
        methods.getLibrary();
      },
      toggleFavorite: (
        track, {
        ignoreIfAdded = false,
      }) async {
        updateData(
          data.copyWith(
            addingToFavorites: true,
          ),
        );
        if (_playerController.data.tracksFromSmartQueue.contains(
              track.hash,
            ) &&
            _playerController.data.playingId == 'favorites') {
          _playerController.updateData(
            _playerController.data.copyWith(
              tracksFromSmartQueue: _playerController.data.tracksFromSmartQueue
                ..removeWhere(
                  (item) => item == track.hash,
                ),
            ),
          );
          _playerController.methods.getSmartQueue(
            customItems: [
              TrackModel.toMusilyTrack(track),
            ],
          );
        }
        final favoritesPlaylist =
            await _getLibraryItemUsecase.exec<PlaylistEntity>('favorites');
        if (favoritesPlaylist == null) {
          await _addToLibraryUsecase.exec(
            PlaylistEntity(
              id: 'favorites',
              title: 'favorites',
              trackCount: 1,
              tracks: [track],
            ),
          );
          updateData(
            data.copyWith(
              loadedFavoritesHash: data.loadedFavoritesHash
                ..add(
                  track.hash,
                ),
              addingToFavorites: false,
            ),
          );
          methods.getLibrary();
          return;
        }
        final itemsFiltered = favoritesPlaylist.value.tracks.where(
          (element) => element.hash == track.hash,
        );
        if (itemsFiltered.isNotEmpty) {
          if (ignoreIfAdded) {
            updateData(
              data.copyWith(
                addingToFavorites: false,
              ),
            );
            return;
          }
          final index = favoritesPlaylist.value.tracks.indexOf(
            itemsFiltered.first,
          );
          favoritesPlaylist.value.tracks.removeAt(index);
          updateData(
            data.copyWith(
              loadedFavoritesHash: data.loadedFavoritesHash
                ..remove(
                  track.hash,
                ),
            ),
          );
          dispatchEvent(
            BaseControllerEvent(
              id: 'favoriteToggled',
              data: data,
            ),
          );
        } else {
          favoritesPlaylist.value.tracks.add(track);
          if (!data.loadedFavoritesHash.contains(track.hash)) {
            updateData(
              data.copyWith(
                loadedFavoritesHash: data.loadedFavoritesHash
                  ..add(
                    track.hash,
                  ),
              ),
            );
          }
          dispatchEvent(
            BaseControllerEvent(
              id: 'favoriteToggled',
              data: data,
            ),
          );
        }
        await _updateLibraryItemUsecase.exec(
          'favorites',
          favoritesPlaylist,
        );
        methods.getLibrary();
        updateData(
          data.copyWith(
            addingToFavorites: false,
          ),
        );
      },
      isFavorite: (track) {
        if (data.loadedFavoritesHash.contains(track.hash)) {
          return true;
        }
        if (!data.alreadyLoadedFirstFavoriteState.contains(track.hash)) {
          // methods.loadFavoriteStatus(track);
        }
        return false;
      },
      loadFavorites: () async {
        final favoritesPlaylist =
            await _getLibraryItemUsecase.exec<PlaylistEntity>('favorites');
        if (favoritesPlaylist == null) {
          return;
        }
        updateData(
          data.copyWith(
            loadedFavoritesHash: [
              ...favoritesPlaylist.value.tracks.map((element) => element.hash),
            ],
          ),
        );
        methods.getLibrary();
      },
      downloadCollection: (tracks, downloadingId) async {
        _downloaderController.methods.setDownloadingKey(
          downloadingId,
        );
        for (final track in tracks) {
          if (isValidDirectory(track.url ?? '')) {
            continue;
          }
          _downloaderController.methods.addDownload(
            TrackModel.toMusilyTrack(
              track,
            ),
          );
        }
      },
      cancelCollectionDownload: (tracks, downloadingId) async {
        _downloaderController.methods.setDownloadingKey('');
        await _downloaderController.methods.cancelDownloadCollection(
          tracks.map((e) => TrackModel.toMusilyTrack(e)).toList(),
        );
      },
    );
  }
}
